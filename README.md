# Mailneo Skills

Run your entire email marketing from an AI coding agent. Five [Agent Skills](https://agentskills.io)
— the open `SKILL.md` standard understood by **Claude Code, OpenAI Codex CLI, Cursor,
Gemini CLI, and GitHub Copilot** — that combine an email-marketing knowledge base with
hands-on operation of the [Mailneo](https://www.mailneo.co) API.

Install them, set one environment variable, and talk:

> *"Find my most engaged subscribers from the last 90 days and draft them a win-back
> newsletter. Show me the send preview before anything goes out."*

The agent uses the knowledge skills for craft and the `mailneo` skill for the API calls.

## The skills

| Skill | What it knows |
|---|---|
| **`mailneo`** | Operating the Mailneo API end to end: subscribers, lists, segments, contacts, campaigns, newsletters, templates, suppressions, analytics, webhooks — and the send discipline (a send is always previewed, shown to you, and confirmed by you). |
| **`email-copywriting`** | Subject lines, preview text, body structure, CTAs, personalization, follow-ups — for cold outreach and newsletters. |
| **`email-deliverability`** | SPF/DKIM/DMARC, warmup, volume, the Google/Yahoo/Microsoft bulk-sender rules, complaint math, troubleshooting inbox placement. |
| **`email-lifecycle`** | List growth, hygiene and sunset policies, segmentation, welcome/nurture/win-back journeys, cadence, A/B testing that is honest about sample size. |
| **`email-compliance`** | CAN-SPAM, GDPR, CASL, PECR — consent, unsubscribe rules, cold-email lawfulness by jurisdiction, and the tactics you must not use. Practical guidance, not legal advice. |

The four knowledge skills are platform-agnostic — they are useful even if you never
touch the Mailneo API.

## Install

**Any agent (auto-detects what you have installed):**

```bash
npx skills add Mailneo/skills
```

**Claude Code (marketplace):**

```
/plugin marketplace add Mailneo/skills
/plugin install email-marketing@mailneo
```

**Codex CLI (manual):**

```bash
git clone https://github.com/Mailneo/skills && cp -r skills/skills/* ~/.codex/skills/
```

**Claude Code (manual):** same, into `~/.claude/skills/` (or `.claude/skills/` in a project).

## Connect your Mailneo account

**Option A: the Mailneo connector (recommended in Claude Code).** The plugin bundles
Mailneo's MCP server (`https://api.mailneo.co/mcp`). After installing, run `/mcp`, pick
**mailneo** and sign in. You choose which scopes to grant on the consent screen, and there
is no key to store. The connector reads your audience and analytics and writes drafts,
lists, segments and templates. It **cannot send email**; no tool reaches a send route.

**Option B: an API key** (any agent, and the only way to send):

1. In Mailneo: **Settings → API Keys → Create key**. Grant the scopes you want the agent
   to have — reads only is a fine way to start; add `*:write` scopes when you're ready,
   and the `*:send` scopes only if you want the agent to be able to *propose* sends.
2. Export it where your agent runs:

```bash
export MAILNEO_API_KEY=mk_live_...
```

The `mailneo` skill uses the connector when it is connected, falls back to your key for
anything the connector does not cover, and adapts to the scopes it finds.

## Safety, by design

Sending through the Mailneo API is a two-step protocol: a **preview** returns exactly who
would receive the email, what it costs, and a single-use confirmation token; only a
separate **confirm** call sends. The `mailneo` skill hard-codes the discipline on top:
the agent must show you the preview impact and get your explicit yes before confirming —
and if the audience changed in between, the API itself forces a fresh preview. An agent
cannot silently email your list.

## Try these first

- *"Audit my email deliverability setup and tell me what the 2024+ bulk-sender rules require that I'm missing."*
- *"Draft five subject lines for a product-launch newsletter to dormant users, then A/B-test-worthy variants of the best one."*
- *"Which of my segments has the highest open rate? Show the numbers."*
- *"Import these 200 contacts, put them on a new list called Beta Users, and set up a welcome email — draft only."*
- *"Is it legal to cold-email German prospects for my B2B tool? What would a compliant version look like?"*

## Privacy and support

- Privacy policy: https://www.mailneo.co/privacy
- Data processing: https://www.mailneo.co/dpa
- Connector docs: https://www.mailneo.co/documentation/resources/mcp
- Support: hi@mailneo.co

The plugin sends data only to `api.mailneo.co`, the Mailneo API and connector.

## License

MIT © Mailneo. The knowledge here is general guidance — compliance content is not legal
advice, and numbers are honest heuristics, not guarantees.
