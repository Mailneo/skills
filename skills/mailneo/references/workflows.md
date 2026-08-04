# Mailneo workflows

End-to-end recipes using `scripts/mailneo-api.sh` (aliased here as `mn`):

```sh
alias mn="$PWD/scripts/mailneo-api.sh"
```

Every recipe assumes the setup check from SKILL.md has already run: key
present, `mn me` succeeded, scopes verified.

## 1. First contact: know what you are holding

```sh
mn me            # team, environment (LIVE/TEST), effective scopes
mn get /usage    # plan, contact slots, monthly email quota, API usage
```

Read `environment` before anything else — a TEST key can never send. Compare
`scopes` against the operations the task needs (`api-map.md`) and report any
gap before starting work, not when the 403 arrives.

## 2. Onboard and import an audience

Scopes: `lists:write`, `subscribers:write`, `subscribers:read` (or
`contacts:write` + `contacts:read` for CRM-side contacts).

```sh
# One idempotency key for the whole logical import, so retries replay.
export MAILNEO_IDEMPOTENCY_KEY="import-waitlist-2026-08-04"

mn post /lists '{"name": "Launch waitlist", "description": "Imported from CSV"}'
# -> note data.id as LIST_ID

mn post /subscribers '{"email": "ada@example.com", "first_name": "Ada", "tags": ["waitlist"]}'
# -> note data.id; repeat per subscriber (or loop over the CSV)

mn post /lists/LIST_ID/subscribers '{"subscriber_ids": ["SUB_1", "SUB_2"]}'
unset MAILNEO_IDEMPOTENCY_KEY
```

For CRM contacts, `POST /contacts/bulk` upserts up to 100 per call by email,
transactionally — batch the file into chunks of 100 and use one idempotency
key per chunk (`import-file-chunk-3`), so a network retry cannot double-write
a chunk. `resource_already_exists` on a single-contact POST means switch to
PATCH for that record.

Adding to a list will not resurrect an UNSUBSCRIBED membership — that refusal
is the opt-out working. Do not route around it by deleting and recreating the
subscriber.

## 3. Build a segment with the filter grammar

Scopes: `segments:write`, `segments:read`.

`conditions` is a strict validated language, not free-form JSON: a group
(`operator`: `AND` or `OR`) of conditions, nestable two levels, 1-100
conditions per group. Each leaf names a field, an operator, and usually a
value. The allowlisted fields and their operators:

| Field | Operators | Notes |
|---|---|---|
| `email`, `name`, `firstName`, `lastName` | `equals`, `not_equals`, `contains`, `not_contains`, `starts_with`, `ends_with` | `is_set`/`is_not_set` on `firstName`/`lastName` only. |
| `status` | `equals`, `not_equals`, `in`, `not_in` | Over `ENABLED`, `DISABLED`, `BLOCKLISTED`. |
| `score` | `equals`, `not_equals`, `greater_than`, `less_than`, `greater_than_or_equals`, `less_than_or_equals`, `in`, `not_in` | Numbers only. |
| `tags` | `contains`/`not_contains` (one tag), `equals`/`not_equals` (all of), `in`/`not_in` (any of), `is_set`/`is_not_set` | |
| `lists` | `in`, `not_in` | List ids; means a CONFIRMED subscription to any of them. Ids must be your team's. |
| `subscription_status` | `equals` | Over `UNCONFIRMED`, `CONFIRMED`, `UNSUBSCRIBED`. |
| `createdAt`, `updatedAt`, `lastContactedAt` | `equals` (whole day), `before`, `after`, `between` | ISO 8601 date strings. |
| `lastOpenedAt`, `lastClickedAt` | `before`, `after` | Open/click activity relative to a date. |
| `customFields.<path>`, `attributes.<path>` | `equals`, `not_equals`, `contains`, `is_set`, `is_not_set` | Your own keys; an unknown path just matches no one. |

Engagement **counts** (`opens_count` and friends) are deliberately not
accepted — the API cannot evaluate them, so build those in the dashboard.
Everything this endpoint accepts is guaranteed evaluatable by the count
endpoint.

```sh
mn post /segments '{
  "name": "Engaged VIPs",
  "conditions": {
    "operator": "AND",
    "conditions": [
      {"field": "status", "operator": "equals", "value": "ENABLED"},
      {"field": "tags", "operator": "contains", "value": "vip"},
      {"field": "lastOpenedAt", "operator": "after", "value": "2026-05-01"}
    ]
  }
}'
mn get /segments/SEG_ID/count   # live aggregate — cache it, do not poll
```

An unsupported field or operator answers `400 filter_unsupported` naming the
offender; fix the condition rather than retrying.

## 4. Draft and send a newsletter (human approval required)

Scopes: `newsletters:write`, `newsletters:send`. Preconditions checked by the
preview: BUSINESS plan, LIVE key, `send_domains` on the key covering the
from-address, ACTIVE sending account, audience attached (in the app), team
complaint rate under the breaker.

```sh
# 1. Draft. Send-shaped fields (status, send_at, send_days, drip flags) are
#    refused by name — the draft is all this scope can produce.
mn post /newsletters '{
  "name": "August product notes",
  "subject": "What shipped in August",
  "body": "<html>...rendered HTML...</html>",
  "email_account_id": "ACC_ID"
}'
# -> NL_ID. Attach the audience (lists/segment) in the Mailneo app; list
#    targeting via API is planned but not live.

# 2. Preview — resolves the real plan and mints the confirmation token.
export MAILNEO_IDEMPOTENCY_KEY="send-august-notes"
mn post /newsletters/NL_ID/send-preview '{}'
```

The preview's `data` carries `recipients` (the breakdown after opt-in and
suppression filtering), `credits_required`, `send_cap` headroom,
`from_addresses` and `confirmation.token`.

**3. STOP.** Show the human the numbers in plain language:

> This will send "What shipped in August" to **1,284** subscribers (1,391 on
> the lists, 92 unsubscribed/suppressed, 15 invalid) from
> news@yourdomain.com, using 1,284 of your 4,716 remaining daily send
> credits. Shall I send it?

Wait for an explicit yes. If the answer is anything but yes, stop here — the
token simply expires after 15 minutes and nothing was scheduled.

```sh
# 4. Only after the yes:
mn post /newsletters/NL_ID/send '{"confirmation_token": "cst_..."}'
unset MAILNEO_IDEMPOTENCY_KEY
# -> 202, status SCHEDULED; the scheduler starts it within about a minute.
```

`409 send_plan_changed` (or `confirmation_stale`/`confirmation_invalid`)
means the audience or content drifted, or the token expired or was already
used: re-run the preview, show the human the **new** numbers, and ask again.
The drift check is the feature — the send that happens is provably the send
that was approved.

Campaigns are the same flow on `/campaigns/{id}/send-preview` and
`/campaigns/{id}/send` (recipients and multiple sending accounts are the
campaign-side differences; tokens are not interchangeable between the two
resources).

## 5. Suppression hygiene sweep

Scopes: `suppressions:read`, `suppressions:write`; `suppressions:delete` only
if removals were explicitly requested.

```sh
# Check one address before mailing it from anywhere:
mn get /suppressions/user%40example.com    # 404 = not suppressed

# Import an external do-not-mail file (idempotent — re-posting is safe and
# never overwrites a bounce/complaint record's reason):
mn post /suppressions '{"emails": ["a@example.com", "b@example.com"], "reason": "MANUAL"}'
# Response says which addresses were added vs already_suppressed.

# Review what the pipeline has recorded:
mn get "/suppressions?reason=bounce:hard" --all
```

Removing a suppression (`DELETE /suppressions/{suppressionId}`) re-enables
mail to that address the moment it returns. Before doing it: fetch the record
and read `reason`; dry-run the delete (`?dry_run=true`) and show the impact;
and require the human to name the address and the reason they believe mailing
it again is right. Pipeline-sourced suppressions (bounces, complaints) will
be re-created automatically if the condition recurs — deleting them does not
fix the cause. Never bulk-delete suppressions.

## 6. Deliverability health check

Scopes: `analytics:read`, `accounts:read`.

```sh
mn get "/analytics/overview?start=2026-07-01&end=2026-08-01"
mn get /accounts --all
mn get /usage
```

Read the overview's event totals as ratios: delivered/sent, bounces and
complaints against delivered. The platform pauses API sends at a 0.20%
complaint rate over 30 days (`complaint_rate_exceeded` on preview), and
Gmail's guidance starts biting at 0.10% — treat anything approaching that as
an emergency, and hand the interpretation to the **email-deliverability**
skill. From `/accounts`, any account not `ACTIVE` cannot send and will fail a
send preview with `sending_domain_unverified`; reconnecting it is an app
action. `/analytics/devices` and `/analytics/geography` take the same
`start`/`end`/`campaign_id` parameters when the question is where and how
mail is being read.

## 7. Webhooks with signature verification

Scopes: `webhooks:write`, `webhooks:read` (contact-bearing events also need
`contacts:read` or `suppressions:read` on the key).

```sh
mn get /webhooks/events        # the catalog; never hard-code event names
mn post /webhooks '{
  "url": "https://example.com/hooks/mailneo",
  "events": ["campaign.completed", "suppression.added", "unsubscribe.created"],
  "name": "ops-notifications"
}'
```

The response contains `secret` (`whsec_...`) exactly once — store it in the
user's secret store immediately; no endpoint returns it again. The URL must
be publicly resolvable (private-range and loopback addresses are refused at
registration).

Verifying deliveries — the consumer contract:

- `X-Mailneo-Signature: t=<unix-seconds>,v1=<hex>` where the signature is
  HMAC-SHA256 over `"<t>.<raw body bytes>"` with the secret. Compare in
  constant time; accept if any `v1=` entry matches (that is how secret
  rotation works); reject if `|now - t|` exceeds 300 seconds.
- Deduplicate on `X-Mailneo-Event-Id` — delivery is at-least-once and
  ordering is not guaranteed. Replays keep the same event id (correct under
  dedup) with a fresh timestamp and signature.
- Verify against the exact raw bytes received — re-serializing the JSON
  first will change them and fail the check.

Debugging: `mn get /webhooks/WH_ID/deliveries` for the log, then
`mn post /webhooks/WH_ID/deliveries/DEL_ID/replay '{}'` to re-send one.

## 8. Incremental sync (mirror Mailneo into another system)

Scope: the resource's `:read`. Works on any list endpoint marked "sync" in
`api-map.md`.

First run — full walk, keep the watermark:

```sh
mn get /subscribers --all 2>meta.json >subscribers.json
jq -r '.synced_through' meta.json     # store this value
```

(`--all` follows every cursor; the final page's `meta` — the one with
`synced_through` — lands on stderr.)

Every later run — ask only for what changed:

```sh
mn get "/subscribers?updated_since=$WATERMARK" --all 2>meta.json >changed.json
```

The contract, and why:

- **Upsert by `id`, never insert.** The watermark is held ~5 seconds behind
  now precisely so you occasionally re-see a row rather than ever missing one.
- **Store `synced_through` only from a fully drained walk.** It appears only
  on the last page for exactly this reason — persisting a watermark
  mid-walk would cover pages never fetched. With `--all` this is automatic.
- **Deletes are invisible to `updated_since`.** A deleted row simply stops
  appearing; schedule an occasional full walk (or consume webhook events such
  as `contact.deleted`) to reap deletions.
- On `400 cursor_invalid`, the saved cursor is stale: restart that walk from
  page one. The watermark, unlike the cursor, never goes stale.
