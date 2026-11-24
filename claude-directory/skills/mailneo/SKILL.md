---
name: mailneo
description: "Use when the user wants to work with their Mailneo email marketing through the Mailneo connector: find subscribers and contacts, build lists and segments, review campaign and newsletter performance, check deliverability and suppressions, draft campaigns, manage templates, or register webhooks. Do NOT use for general email-writing advice that needs no Mailneo data."
---

# Working in Mailneo through the connector

This plugin bundles the **Mailneo connector** (`https://api.mailneo.co/mcp`).
The user signs in once with OAuth, picks one Mailneo team and the access to
grant, and its tools appear: names like `get_workspace_info`,
`find_subscribers`, `get_segment` and `create_campaign_draft`. If the tools
are not available, tell the user to connect Mailneo (Settings → Connectors in
Claude, or `/mcp` in Claude Code). Never ask them to paste a password or key
into the conversation.

## Start by orienting

Call `get_workspace_info` before the first real task. It returns the team,
the user's role, the scopes this connection was granted, plan usage against
limits and the sending accounts. If a task needs a scope that was not
granted, say so up front: the fix is to reconnect and approve that access,
not to retry. An `insufficient_scope` error names the missing scope — relay
it, never retry it unchanged.

The connector requires a Mailneo Business plan. A plan error means the team
needs to upgrade in Mailneo; there is no workaround through the tools.

## What the connector cannot do (on purpose)

- **It cannot send.** No tool reaches a send, schedule or launch route.
  Campaigns are always created as drafts. When the user asks to send, check
  the draft with `get_campaign_readiness`, report what is ready or blocking,
  and tell them to send it from the Mailneo app. Never imply a send happened.
- **It deletes nothing.** Subscribers, contacts, lists, campaigns and
  templates cannot be deleted here. To stop mailing someone, use a
  suppression; for anything else, point the user to the app.
- **It never returns secrets.** Webhook signing secrets are not available
  through `create_webhook_endpoint`; do not tell the user you have one.

## Pick the right tool

| The user wants to… | Use |
|---|---|
| See what audiences exist | `list_audiences` |
| Find people by email, status, tags or list | `find_subscribers` (newsletter) / `find_contacts` (cold outreach) |
| Know everything about one person | `get_subscriber_profile` |
| Search one term across subscribers, lists, segments | `search_across_audiences` |
| Create a list, or add existing people to one | `create_and_populate_list` / `add_subscribers_to_list` |
| Inspect, create or change a segment | `get_segment` / `create_segment` / `update_segment` |
| Compare two lists | `get_list_overlap` |
| See growth and unsubscribes over time | `get_audience_growth`, `get_suppression_summary` |
| Review campaign results | `list_campaigns_with_performance`, `get_campaign_overview`, `compare_campaigns`, `get_top_content` |
| Review newsletters | `get_newsletter_performance` |
| Check sending health | `get_deliverability_summary`, `get_engagement_timeline` |
| Draft or edit a campaign | `create_campaign_draft` / `update_campaign_draft`, then `get_campaign_readiness` |
| Read, write or copy a template | `get_template` / `upsert_template` / `duplicate_template` |
| Work with webhooks | `list_webhook_endpoints`, `get_webhook_health`, `create_webhook_endpoint` |
| Stop mail to an address | `suppress_emails` (see below) |

Read-only tools are safe to call freely. Prefer one intent-level call over
stitching several together — most tools already combine what a question
needs.

## Rules for writes

- **Segments:** `update_segment` replaces the conditions wholesale. Read the
  current definition with `get_segment` first, then send the complete new
  condition set. Open and click *counts* are not accepted as conditions; use
  `lastOpenedAt` / `lastClickedAt` dates instead.
- **Lists:** `add_subscribers_to_list` never re-adds someone who unsubscribed
  from that list. Report the `unsubscribed` group in the result rather than
  trying to force them in — their opt-out stands.
- **Suppression is one-way here.** `suppress_emails` cannot be undone through
  the connector. State exactly which addresses will be suppressed and get a
  clear yes before calling it. Never suppress addresses the user did not name.
- **Drafts:** `update_campaign_draft` only edits campaigns in DRAFT. A
  `resource_state_invalid` error means the campaign is scheduled or sending —
  leave it alone and tell the user.
- Quote the `request_id` from any error when reporting a failure; it is what
  Mailneo support can look up.

## Reading numbers honestly

- Campaign rates are event-based (one person opening five times counts five);
  newsletter rates use unique recipients. Say which you are reporting.
- A `null` rate means nothing was sent or delivered, not zero performance.
- `complete: false` or `exact: false` in a result means a sampling cap was hit
  and the figure is a lower bound. Say so instead of presenting it as exact.

## Related skills

For the craft rather than the platform — what to write, when to send, how to
stay deliverable and lawful — use the sibling skills:
**email-copywriting**, **email-deliverability**, **email-lifecycle** and
**email-compliance**.
