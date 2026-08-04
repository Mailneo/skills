# Mailneo error codes

Every error is the envelope described in `api-map.md`; branch on
`error.code` (stable, never renamed), not on `message`. `error.param` names
the offending field when there is one; `doc_url` deep-links the code's row in
the hosted reference. Always capture `request_id` when reporting a failure.

## 400 — fix the request (retrying unchanged will not help)

| Code | Meaning | Remedy |
|---|---|---|
| `validation_failed` | The body or a parameter failed validation; `param` carries the path (e.g. `body.emails.3`). Also used for refused-by-name fields (`status` on a draft create) and over-deep bodies. | Fix the named field. Send-shaped fields on write endpoints are refused deliberately — use the send flow. |
| `invalid_json` | The body is not parseable JSON. | Fix the syntax (quote keys, remove trailing commas). |
| `unsupported_parameter` | A parameter this endpoint does not accept. | Remove it; check `api-map.md` for what the endpoint takes. |
| `idempotency_key_required` | This write demands an `Idempotency-Key` header (bulk upserts, sends, replays). | Supply one; the script does automatically. |
| `cursor_invalid` | The pagination cursor is stale, foreign, or hand-modified. | Restart the walk from page one. Do not construct cursors. |
| `filter_unsupported` | A filter/segment condition outside the allowlisted grammar, or a segment count over dashboard-only conditions. | Use the fields and operators in `workflows.md` recipe 3; build engagement-count segments in the dashboard. |
| `sort_unsupported` | The `sort` value is not a sortable column here. | Use one of the endpoint's documented sort fields. |
| `expand_unsupported` | The `expand` value is not available here. | Remove or correct it. |
| `version_unsupported` | The `Mailneo-Version` header names an unknown version. | Omit the header or use a published version. |

## 401 — credential problems

| Code | Meaning | Remedy |
|---|---|---|
| `api_key_missing` | No `x-api-key` header arrived. | Set `MAILNEO_API_KEY`; check the header wiring. |
| `api_key_malformed` | The value is not shaped like a Mailneo key. | Re-copy the key; whitespace and truncation are the usual culprits. |
| `api_key_invalid` | Well-formed but not a live key. | The key was deleted or mistyped — mint or re-copy at Settings -> API Keys. |
| `api_key_expired` | Past its expiry date. | Rotate: create a replacement key. |
| `api_key_revoked` | Explicitly revoked. | Someone turned this key off, possibly deliberately — ask before replacing it. |
| `api_key_environment_mismatch` | A TEST key against LIVE or vice versa. | Use the key from the matching environment. |
| `invalid_token` | An OAuth bearer token failed (expired, revoked, malformed). | Refresh or re-authorize; not applicable to `x-api-key` callers. |

## 402 — plan ceilings (money or plan moves these)

| Code | Meaning | Remedy |
|---|---|---|
| `quota_exceeded` | The plan's contact limit or monthly email quota is exhausted. | Check `GET /usage`; upgrade the plan or free capacity. Back off — retrying cannot succeed this period. |
| `plan_upgrade_required` | The endpoint needs a higher plan (sends require BUSINESS). | Tell the user which plan gates the feature; do not retry. |

## 403 — allowed to authenticate, not to do this

Never retry a 403 unchanged. The body says exactly what is missing.

| Code | Meaning | Remedy |
|---|---|---|
| `insufficient_scope` | The key lacks this endpoint's scope; the message names it (e.g. "requires the \"subscribers:write\" scope"). | Relay the named scope; the user grants it on a new key at Settings -> API Keys. Dry runs additionally need the `:read` scope. |
| `role_insufficient` | The key's creator's team role does not permit this. | A team admin must act or issue the key. |
| `forbidden_scope_pair` | The key combines scopes the platform refuses together (send scopes cannot coexist with person-data read scopes). | Use two keys: one to read audiences, one to send. |
| `send_not_permitted` | The credential requires out-of-band approval for sends, which the API does not yet offer. | Send from the app, or use a key minted without `requires_approval`. |
| `send_domain_not_allowed` | The key's `send_domains` allowlist is empty or does not cover a from-address on this send. | Mint a key allowlisting the domain, or drop the offending sending account from the draft. |
| `complaint_rate_exceeded` | The team's 30-day complaint rate is at or above 0.20%, so API sends are paused. | Stop sending. Review list hygiene and consent (see the email-deliverability skill); the breaker lifts as the rate falls. |

## 404 — absent, or not yours

| Code | Meaning | Remedy |
|---|---|---|
| `not_found` | No such record **visible to this team**. Cross-tenant ids intentionally answer 404, never 403, so a 404 does not prove the id is free. | Verify the id came from this team's own listings. On `GET /suppressions/{email}`, 404 is the good answer: not suppressed. |

## 409 — state conflicts (the request may be fine; the world moved)

| Code | Meaning | Remedy |
|---|---|---|
| `idempotency_key_reused` | Same `Idempotency-Key`, different body. | New logical operation, new key. Reuse a key only for byte-identical retries. |
| `request_in_flight` | The original request under this key is still executing. | Wait and retry with the same key; it will replay the result. |
| `resource_already_exists` | A visible uniqueness clash (contact email already in the team). | PATCH the existing record instead of re-POSTing. |
| `resource_limit_reached` | A fixed platform ceiling (e.g. max webhook endpoints per team) — not a plan matter. | Delete one, then retry the same request. |
| `resource_state_invalid` | The resource exists but its state forbids this: editing an armed campaign, replaying to a disabled webhook. | Put the resource in the right state (often an app action: un-schedule, re-enable), then retry unchanged. |
| `confirmation_required` | This operation only proceeds with a confirmation token from its preview step. | Run the preview, get the human's yes, confirm with the token. |
| `confirmation_stale` | The confirmation token has expired (15-minute life). | Re-preview, re-present the impact, get a fresh yes. |
| `confirmation_invalid` | The token is not valid here: wrong resource, wrong key, already used, or garbage. | Re-preview. Tokens are single-use and bound to resource + team + key; campaign and newsletter tokens never interchange. |
| `send_plan_changed` | The resolved plan drifted between preview and confirm — recipients, suppressions, content, or accounts changed. | Re-preview, show the human the **new** numbers, and get a new explicit yes. Never treat this as a formality. |
| `campaign_not_ready` | The draft cannot send: missing subject, content, sending account, or no eligible recipients after filtering. | The message lists what is missing; complete the draft (audience attachment is an app action), then preview again. |
| `sending_domain_unverified` | A referenced sending account is not ACTIVE, or no longer exists. | Reconnect or verify the account in the app (`GET /accounts` shows status), then preview again. |

## 413 / 415

| Code | Meaning | Remedy |
|---|---|---|
| `payload_too_large` | Body over the size limit. | Split the batch (bulk endpoints cap at 100 rows anyway). |
| `unsupported_media_type` | Wrong content type or encoding. | Send `Content-Type: application/json`, UTF-8. |

## 429 — back off; `Retry-After` is authoritative

| Code | Meaning | Remedy |
|---|---|---|
| `rate_limit_exceeded` | Too many requests in the window. | Sleep for `Retry-After` seconds, then resume. Slow the loop rather than racing the limiter. |
| `send_cap_exceeded` | The key's daily send cap (counted across its whole rotation lineage) has no headroom for this send. | `Retry-After` points at UTC midnight when the counter resets. Nothing to retry sooner; a bigger cap is a key setting. |

## 5xx — the platform's fault

| Code | Meaning | Remedy |
|---|---|---|
| `internal_error` (500) | Unexpected server error; details are logged server-side under `request_id`. | Retry once after a pause; if it persists, report the `request_id` to Mailneo support. |
| `service_unavailable` (503) | A dependency is temporarily down (send-cap checks deliberately fail closed this way — nothing was sent). | Honor `Retry-After` and retry; safe by design on the send path. |
