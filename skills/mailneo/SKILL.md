---
name: mailneo
description: "Use when the user wants to manage email marketing through Mailneo: subscribers, lists, segments, contacts, campaigns, newsletters, templates, suppressions, analytics, webhooks, or sending. Works through the Mailneo connector (MCP tools) or a MAILNEO_API_KEY. Do NOT use for general email-writing advice without API operations."
---

# Operating the Mailneo API

You are driving a production email platform on behalf of a human. Reads are
cheap and safe; sends and deletes affect real inboxes and real opt-outs. The
rules below exist in that order of importance.

## The send rule (read this first)

**Never confirm a send without an explicit human yes.** Sending is two API
calls by design:

1. `POST /campaigns/{id}/send-preview` (or `/newsletters/{id}/send-preview`)
   returns an impact block — eligible recipients after suppression and opt-out
   filtering, credits required, sending addresses, daily-cap headroom — plus a
   single-use confirmation token bound to that exact plan.
2. `POST /campaigns/{id}/send` (or `/newsletters/{id}/send`) takes the token
   and arms the send. Arming is irreversible through the API.

Between those two calls there must be a human. Show them the impact block,
ask "send to N recipients from these addresses?", and only call step 2 after
they say yes. Never chain preview and confirm in one action, never treat a
prior instruction like "send the newsletter" as pre-approval of numbers the
human has not seen. The token expires in 15 minutes and dies on any audience
or content drift — a `409 send_plan_changed` means re-preview and re-ask,
because the numbers the human approved are no longer the numbers.

## Two ways in: the connector and the API key

This plugin bundles the **Mailneo connector** (MCP server at
`https://api.mailneo.co/mcp`). When its tools are available — names like
`get_workspace_info`, `find_subscribers`, `get_segment`,
`create_campaign_draft` — prefer them for reads, audience work, drafts,
templates and analytics. The user signs in once through OAuth and chooses the
scopes; there is no key to handle. Start with `get_workspace_info` to learn
the team, scopes and plan.

The connector **cannot send** — by design, no MCP tool reaches a send route.
For anything it does not cover (sending, deletes, imports, webhooks beyond
creation), fall back to the API-key path below, and only if the user has set
`MAILNEO_API_KEY`. If neither is available, tell the user to connect Mailneo
(`/mcp` in Claude Code, or Settings -> Connectors in Claude) or to create an
API key; never ask them to paste a credential into the conversation.

## Setup check (API-key path)

Before the first real operation through the API:

1. Confirm the key exists: `MAILNEO_API_KEY` must be set in the environment.
   If not, stop and tell the user to create one in the Mailneo dashboard under
   Settings -> API Keys and export it. Never ask them to paste the key into
   the conversation.
2. Call `GET /me` (scope-free) to learn the key's identity, team, environment
   (`LIVE` or `TEST`) and `scopes`. Call `GET /usage` (also scope-free) for
   plan, contact and email-quota headroom.
3. Compare the granted scopes against what the task needs (each operation's
   scope is in `references/api-map.md`). If a scope is missing, say so up
   front: the fix is a new key with that scope granted at Settings -> API
   Keys, not a retry. A `403 insufficient_scope` response names the missing
   scope — relay it, never retry a 403 unchanged.

Sending has extra preconditions beyond the `*:send` scope: a BUSINESS plan, a
LIVE key, a `send_domains` allowlist on the key covering every from-address,
and an ACTIVE sending account. The preview call checks all of them and its
error codes name what is missing.

## Request discipline

- Base URL: `https://api.mailneo.co/api/v2`. Auth: `x-api-key` header.
- Every success is `{ "data": ..., "meta": { "request_id": ... } }`; every
  failure is `{ "error": { type, code, message, param?, doc_url, request_id },
  "meta": { request_id } }`. Quote the `request_id` when reporting a failure —
  it is what Mailneo support can look up.
- Lists are cursor-paginated: follow `meta.next_cursor` while `meta.has_more`
  is true. `meta.synced_through` appears only on the final page; store it and
  pass it back as `?updated_since=` for incremental syncs (upsert by `id` —
  you will occasionally re-see a row).
- Send an `Idempotency-Key` header on every write (POST/PATCH/DELETE).
  Generate one UUID per logical operation and reuse it on retries: the retry
  replays the first response instead of repeating the work. A new UUID on a
  retry is how the same contact gets created twice.
- Before any destructive call, run it with `?dry_run=true` first and read
  `meta.impact` (`would_create` / `would_update` / `would_delete`,
  `affected_ids`, quota effect). A dry run returns `data: null` and commits
  nothing; it needs the resource's `:read` scope in addition to the write
  scope.
- On `429`, honor the `Retry-After` header — do not hammer. A
  `send_cap_exceeded` 429's `Retry-After` points at UTC midnight, when the
  daily cap resets; there is nothing to retry sooner.
- Cross-tenant ids answer `404`, identical to missing ids. A 404 on an id the
  user supplied usually means "not this team's", not "deleted".

## Making calls

Prefer the bundled script — it applies all of the above deterministically:

```sh
scripts/mailneo-api.sh me
scripts/mailneo-api.sh get "/subscribers?status=ENABLED" --all
scripts/mailneo-api.sh post /lists '{"name": "Launch waitlist"}'
scripts/mailneo-api.sh patch /subscribers/SUB_ID '{"tags": ["vip"]}'
scripts/mailneo-api.sh delete "/suppressions/SUP_ID?dry_run=true"
```

It reads `MAILNEO_API_KEY`, adds the auth and `Idempotency-Key` headers,
prints `data` to stdout and `meta` to stderr, follows cursors with `--all`,
and exits 4/5 on 4xx/5xx with the error envelope on stderr. Export
`MAILNEO_IDEMPOTENCY_KEY` to pin one idempotency key across a retried
operation.

If the script is unavailable, raw `curl` following the same rules is fine.
For a JavaScript or TypeScript codebase that wants a durable integration
(rather than you operating the API), point the user at the `@mailneo/sdk`
npm package instead of hand-rolled fetch calls.

## The send workflow

For a campaign (`/campaigns/{id}/...`) and a newsletter
(`/newsletters/{id}/...`) the flow is identical; tokens are not
interchangeable between the two.

1. Draft via `POST` / `PATCH`. Drafts only: `status`, scheduling fields and
   drip flags are refused by name — arming happens exclusively through the
   send flow. Audience attachment (campaign recipients, newsletter lists) is
   done in the app today, not through the API.
2. `POST .../send-preview` (Idempotency-Key required). Read the response:
   `recipients` breakdown, `credits_required`, `from_addresses`, `send_cap`
   headroom, and `confirmation.token`.
3. **Stop. Present the impact to the human in plain language and ask for an
   explicit yes.** This is the point of the design; do not optimize it away.
4. Only after the yes: `POST .../send` with
   `{"confirmation_token": "..."}`. Returns `202` with status `SCHEDULED`;
   the platform's scheduler starts the send within about a minute.
5. On `409 send_plan_changed`, `confirmation_stale` or
   `confirmation_invalid`: the plan drifted or the token expired or was used.
   Re-preview, show the human the new numbers, and get a fresh yes. Never
   present a re-confirmation as a formality.

Full sequence with commands: `references/workflows.md`.

## Destructive operations

- **Deleting a suppression re-enables mail to someone who was deliberately
  blocked.** Check the record's `reason` first: bounce and complaint rows
  were written by the delivery pipeline, unsubscribe rows record an opt-out.
  Un-suppressing an opt-out and then mailing that address is a compliance
  decision that belongs to the human, stated explicitly for that address —
  never infer it from "clean up the suppression list". Always
  `?dry_run=true` first.
- **Subscriber and contact deletes are permanent erasure**, not archiving.
  Dry-run first, show `meta.impact` (count and ids), and get confirmation
  before committing. If the intent is "stop mailing them", the right tool is
  a suppression or list unsubscribe, which are reversible — not a delete.
- Removing a subscriber from a list marks the membership UNSUBSCRIBED rather
  than deleting it, and re-adding will not resurrect an unsubscribed
  membership. That asymmetry is deliberate; do not fight it.

## References

- `references/api-map.md` — every operation: method, path, required scope,
  purpose, notable parameters; plus the scope catalog and envelope shapes.
- `references/workflows.md` — end-to-end recipes: import, segment building
  (with the exact filter grammar), the send flow, suppression hygiene,
  deliverability checks, webhooks, incremental sync.
- `references/errors.md` — every error code with meaning and remedy.

## Related skills

For the craft rather than the API — what to write, when to send, how to stay
deliverable and lawful — use the sibling knowledge skills:
**email-copywriting**, **email-deliverability**, **email-lifecycle**, and
**email-compliance**. This skill is for operating Mailneo; those are for
deciding what is worth operating.
