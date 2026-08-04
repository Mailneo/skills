# Mailneo v2 API map

Base URL `https://api.mailneo.co/api/v2` · auth header `x-api-key` · rendered
reference at https://www.mailneo.co/documentation/api (generated from the same
spec this file is distilled from).

## Envelopes

Success:

```json
{ "data": ..., "meta": { "request_id": "..." } }
```

List responses add paging to `meta`: `has_more` (branch on this — there is no
`total`), `next_cursor` (opaque; a stale or hand-edited one answers
`400 cursor_invalid`, restart from page one), and — only on endpoints that
support `?updated_since=`, only on the final page — `synced_through`, the
watermark to store for the next incremental run.

Write responses add `dry_run` (always present) to `meta`, plus `impact` when
it is true: `{ would_create, would_update, would_delete, affected_count,
affected_ids, quota }`. A dry run returns `data: null`.

Error:

```json
{
  "error": {
    "type": "authentication_error | permission_error | invalid_request_error | not_found_error | conflict_error | rate_limit_error | quota_error | api_error",
    "code": "snake_case_stable_code",
    "message": "human-readable",
    "param": "body.field.path (when applicable)",
    "doc_url": "https://www.mailneo.co/documentation/api/getting-started#<code>",
    "request_id": "..."
  },
  "meta": { "request_id": "..." }
}
```

Codes are a stable contract — branch on `error.code`, not on `message`.
Full catalog with remedies: `errors.md`.

## Scopes (25)

`contacts:read` `contacts:write` `contacts:delete` ·
`subscribers:read` `subscribers:write` `subscribers:delete` ·
`lists:read` `lists:write` · `segments:read` `segments:write` ·
`campaigns:read` `campaigns:write` `campaigns:send` ·
`newsletters:read` `newsletters:write` `newsletters:send` ·
`templates:read` `templates:write` ·
`suppressions:read` `suppressions:write` `suppressions:delete` ·
`analytics:read` · `accounts:read` · `webhooks:read` `webhooks:write`

`GET /me` and `GET /usage` are scope-free. `dry_run=true` additionally
requires the resource's `:read` scope. Send scopes also require a BUSINESS
plan, a LIVE key, and a non-empty `send_domains` allowlist on the key.

## Common list parameters

`limit` (1-100, default 25) · `cursor` · `order` (`asc`/`desc`, default
`desc`) · `updated_since` (ISO 8601; on the endpoints marked "sync" below).
Some lists also take `sort`.

## Operations

Notation: sync = supports `?updated_since=` + `synced_through`.

### System

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /me | (none) | Key identity, team, environment (LIVE/TEST), effective scopes. |
| GET | /usage | (none) | Current-period plan, contact and email-quota usage — self-throttle instead of discovering a 402. |

### Contacts

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /contacts | contacts:read | List; sync. Filters: `status` (ACTIVE/CONVERTED/LOST/UNQUALIFIED/ARCHIVED), `email`, `source`, `tags`; `sort` in `updated_at`/`created_at`/`last_activity_at`. |
| POST | /contacts | contacts:write | Create one contact. `resource_already_exists` if the email exists (then PATCH instead). |
| POST | /contacts/bulk | contacts:write | Upsert up to 100 by email, one transaction, all-or-nothing. Idempotency-Key required. |
| GET | /contacts/{contactId} | contacts:read | Retrieve one. |
| PATCH | /contacts/{contactId} | contacts:write | Merge-patch. |
| DELETE | /contacts/{contactId} | contacts:delete | Permanent erasure. Dry-run first. |

### Subscribers

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /subscribers | subscribers:read | List; sync. Filters: `status` (ENABLED/DISABLED/BLOCKLISTED), `email`, `source`, `tags`, `list_id`. |
| POST | /subscribers | subscribers:write | Create (email, name fields, tags, custom_fields, ...). |
| GET | /subscribers/{subscriberId} | subscribers:read | Retrieve one. |
| PATCH | /subscribers/{subscriberId} | subscribers:write | Merge-patch. |
| DELETE | /subscribers/{subscriberId} | subscribers:delete | Permanent erasure, including delivery-log anonymisation. Dry-run first. |

### Lists

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /lists | lists:read | List; sync. Filters: `type`, `optin`, `name`. |
| POST | /lists | lists:write | Create (`name`, `type`, `optin`, `description`, `tags`). |
| GET | /lists/{listId} | lists:read | Retrieve one. |
| PATCH | /lists/{listId} | lists:write | Merge-patch. |
| DELETE | /lists/{listId} | lists:write | Delete the list. Dry-run first. |
| GET | /lists/{listId}/subscribers | subscribers:read | Members of one list; sync. |
| POST | /lists/{listId}/subscribers | lists:write | Add by `subscriber_ids`. Will not resurrect an UNSUBSCRIBED membership. |
| DELETE | /lists/{listId}/subscribers/{subscriberId} | lists:write | Marks the membership UNSUBSCRIBED (the row is the opt-out record; it is kept). |

### Segments

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /segments | segments:read | List; sync. Filter: `name`. Stored conditions are not echoed on reads. |
| POST | /segments | segments:write | Create from the validated filter grammar (fields/operators: `workflows.md`). Everything accepted is countable. |
| GET | /segments/{segmentId} | segments:read | Retrieve one. |
| PATCH | /segments/{segmentId} | segments:write | Update name/conditions. |
| DELETE | /segments/{segmentId} | segments:write | Delete. Dry-run first. |
| GET | /segments/{segmentId}/count | segments:read | Live match count (costly — cache, do not poll). Dashboard-only conditions answer `400 filter_unsupported`. |

### Campaigns

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /campaigns | campaigns:read | List; sync. Filters: `status`, `type`. |
| POST | /campaigns | campaigns:write | Create a DRAFT (`name`, `subject`, `body`, `preheader`, `email_account_ids`, `timezone`). `status`/`scheduled_at` refused by name — arming is the send flow. |
| GET | /campaigns/{campaignId} | campaigns:read | Retrieve one. |
| PATCH | /campaigns/{campaignId} | campaigns:write | Merge-patch a DRAFT; anything armed is `409 resource_state_invalid`. |
| DELETE | /campaigns/{campaignId} | campaigns:write | Delete a DRAFT; refuses once send evidence exists. Dry-run first. |
| POST | /campaigns/{campaignId}/send-preview | campaigns:send | Step 1: resolve the plan, run every gate read-only, return impact + single-use token (15 min). Idempotency-Key required. |
| POST | /campaigns/{campaignId}/send | campaigns:send | Step 2: verify token, re-run gates, `409 send_plan_changed` on any drift, reserve credits, arm. 202. Idempotency-Key required. |

### Newsletters

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /newsletters | newsletters:read | List; sync. Filters: `status`, `type`, `campaign_mode`, `name`. |
| POST | /newsletters | newsletters:write | Create a broadcast DRAFT (`name`, `subject`, `body`, `content_type`, `from_*`, `reply_to`, `email_account_id`, `tags`). `status`/`send_at`/`send_days`/drip flags refused by name. Audience is attached in the app. |
| GET | /newsletters/{newsletterId} | newsletters:read | Retrieve one. |
| PATCH | /newsletters/{newsletterId} | newsletters:write | Merge-patch a DRAFT only. |
| DELETE | /newsletters/{newsletterId} | newsletters:write | Delete a DRAFT; refuses once send evidence exists. Dry-run first. |
| POST | /newsletters/{newsletterId}/send-preview | newsletters:send | Step 1, as for campaigns; broadcasts only (drip and workflow-backed refused). |
| POST | /newsletters/{newsletterId}/send | newsletters:send | Step 2, as for campaigns. Campaign and newsletter tokens are not interchangeable. |

### Templates

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /templates | templates:read | List; sync. Filters: `category`, `search`. |
| POST | /templates | templates:write | Create (`name`, `subject`, `body`, `category`, `description`). |
| GET | /templates/{templateId} | templates:read | Retrieve one. |
| PATCH | /templates/{templateId} | templates:write | Merge-patch. |
| DELETE | /templates/{templateId} | templates:write | Delete. Dry-run first. |

### Suppressions and unsubscribes

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /suppressions | suppressions:read | List; sync. Filters: `email`, `reason`. |
| POST | /suppressions | suppressions:write | Suppress up to 100 addresses; `reason` accepts only `MANUAL`. Re-posting is safe; existing records are untouched. |
| GET | /suppressions/{email} | suppressions:read | Is this address suppressed? 404 = not suppressed. URL-encode the address. |
| DELETE | /suppressions/{suppressionId} | suppressions:delete | Un-suppress — RE-ENABLES mail. Check `reason`, dry-run, and require explicit human intent. Response never echoes the address. |
| GET | /unsubscribes | suppressions:read | Unsubscribe event history (no sync watermark). Filters: `email`, `source`, `campaign_id`. |

### Analytics

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /analytics/overview | analytics:read | Delivery/engagement event totals. Params: `start`, `end`, `campaign_id`. |
| GET | /analytics/devices | analytics:read | Device, OS and browser breakdown. Same params. |
| GET | /analytics/geography | analytics:read | Country breakdown. Same params. |

### Sending accounts

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /accounts | accounts:read | Connected mailboxes and health; sync. Filters: `status` (`ACTIVE` = can send), `provider`. Metadata only, never credentials. |
| GET | /accounts/{accountId} | accounts:read | Retrieve one. |

### Webhooks

| Method | Path | Scope | Purpose |
|---|---|---|---|
| GET | /webhooks | webhooks:read | List endpoints; sync. Filters: `active`, `event`. |
| POST | /webhooks | webhooks:write | Register (`url`, `events`, `name`, `description`, `headers`). Response contains `secret` ONCE — store it. Contact-bearing events also require `contacts:read` or `suppressions:read` on the key. |
| GET | /webhooks/events | webhooks:read | The event-name catalog; validate against this, never hard-code. |
| GET | /webhooks/{webhookId} | webhooks:read | Retrieve one (no secret). |
| PATCH | /webhooks/{webhookId} | webhooks:write | Update url/events/active. |
| DELETE | /webhooks/{webhookId} | webhooks:write | Delete the endpoint. |
| GET | /webhooks/{webhookId}/deliveries | webhooks:read | Delivery log, newest first (no sync watermark; payloads not included — correlate by `event_id`). |
| POST | /webhooks/{webhookId}/deliveries/{deliveryId}/replay | webhooks:write | Re-deliver as a new delivery row; same `X-Mailneo-Event-Id`, fresh timestamp and signature. Idempotency-Key required. |
