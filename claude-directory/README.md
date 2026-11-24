# Mailneo for Claude (directory plugin)

The Claude Directory edition of Mailneo's email-marketing plugin. It bundles:

- **The Mailneo connector** (`https://api.mailneo.co/mcp`): ask Claude about your
  subscribers, lists, segments, campaign and newsletter performance and
  deliverability, and have it build lists and segments, draft campaigns, manage
  templates and register webhooks. Sign in with OAuth and choose the access you
  grant. It can never send email: you send from the Mailneo app.
- **Four knowledge skills**: email copywriting, deliverability, lifecycle
  strategy and compliance.

Requires a Mailneo Business plan. Revoke access any time under
Settings → API Keys → Connected apps in Mailneo.

- Docs: https://www.mailneo.co/documentation/resources/mcp
- Privacy: https://www.mailneo.co/privacy
- Support: hi@mailneo.co

This folder is generated in part: the four knowledge skills are copies of
`../skills/` kept in sync by `scripts/sync-directory-plugin.sh`. The `mailneo`
skill here is connector-only and maintained separately.
