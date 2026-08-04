---
name: email-deliverability
description: "Use when diagnosing or preventing inbox-placement problems: SPF/DKIM/DMARC, warmup, sending volume, spam complaints, blocklists, bounce rates, bulk-sender requirements. Do NOT use for copy questions (email-copywriting) or list-management strategy (email-lifecycle)."
---

# Email deliverability

Deliverability is whether the mail you send reaches an inbox at all. It is
decided by machines at the receiving end, using signals you mostly control,
before any human sees your subject line. This skill is the diagnostic and
preventive playbook for those signals.

## The mental model

Mailbox providers score every message on four factors that **multiply, not
add**. A zero in any one of them zeroes the product, and no strength in the
others buys it back.

1. **Identity** — can the receiver cryptographically verify who sent this?
   SPF, DKIM, DMARC alignment, matching forward/reverse DNS, TLS. Binary in
   practice: since 2024 the major providers reject bulk mail that fails it.
2. **Reputation** — the history attached to your domain and sending IP:
   past complaint rates, trap hits, blocklist events, bounce patterns.
   Earned slowly, lost quickly, and remembered longer than you would like.
3. **Engagement** — what recipients do with your mail: open, reply, move to
   spam, delete unread, rescue from spam. Providers weight their own users'
   behavior toward *your* mail above everything else.
4. **Volume behavior** — how much you send and how consistently. Filters
   model your normal; sudden spikes, long silences followed by blasts, and
   brand-new infrastructure at high volume all read as spammer behavior.

When triaging, ask which factor broke. Authentication failures are checkable
in minutes; reputation damage takes weeks to repair; engagement problems are
usually list problems wearing a deliverability costume.

## Non-negotiables (the 2026 baseline)

Since February 2024 (Google and Yahoo) and May 2025 (Microsoft), these are
entry requirements for anyone sending meaningful volume, not best practices:

- [ ] **SPF passing** for the return-path domain
- [ ] **DKIM signing** with the sender's own domain (not only the platform's)
- [ ] **DMARC record** published — `p=none` minimum, enforcement the goal
- [ ] **Alignment**: the visible From domain matches the SPF or DKIM domain
- [ ] **One-click unsubscribe** (RFC 8058 headers) on commercial mail,
      honored within **two days**
- [ ] **Spam complaint rate** below **0.3%** — treat **0.1%** as the real limit
- [ ] **Bounce rate** below **2%**, with hard bounces suppressed immediately
- [ ] **Valid forward and reverse DNS** for sending IPs; **TLS** in transit
- [ ] Sending domain resolves to a real website that identifies the sender

Non-compliant bulk mail is now rejected at the SMTP level by all three major
providers — it does not even reach the spam folder. Details, thresholds, and
the per-provider table: [references/bulk-sender-rules.md](references/bulk-sender-rules.md).

## Triage: which reference to open

| Symptom | Start here |
|---|---|
| New domain/IP, or planning volume growth | [references/warmup-and-volume.md](references/warmup-and-volume.md) |
| Mail rejected with 5.7.x errors, or auth uncertainty | [references/authentication.md](references/authentication.md) |
| Open rate collapsed, mail landing in spam | [references/troubleshooting.md](references/troubleshooting.md) |
| Sudden drop after a specific date | [references/troubleshooting.md](references/troubleshooting.md) — "what changed" audit |
| Blocklist notice or bounce mentioning a blocklist | [references/troubleshooting.md](references/troubleshooting.md) — blocklist section |
| Complaint rate creeping up, provider warnings | [references/bulk-sender-rules.md](references/bulk-sender-rules.md) |
| Opens fine, but no replies or clicks | Not a deliverability problem — see the `email-copywriting` and `email-lifecycle` skills |
| Choosing shared vs dedicated IP | [references/warmup-and-volume.md](references/warmup-and-volume.md) |
| DMARC policy progression, BIMI, tracking domains | [references/authentication.md](references/authentication.md) |

## Numbers worth memorizing

| Metric | Threshold | Why |
|---|---|---|
| Spam complaint rate | < 0.3% hard cap, < 0.1% target | Provider-enforced; sustained breaches bring rejection |
| Bounce rate | < 2%, ideally near zero | High bounces are the classic address-guessing signature |
| Bulk-sender line | ~5,000 msgs/day to one provider | Triggers the full requirement set; classification is sticky |
| Unsubscribe honoring | ≤ 2 days | Google and Yahoo requirement, not a courtesy |
| New-domain patience | 2–4 weeks before real volume | Fresh infrastructure is scored harshly by design |
| Warmup ramp | roughly double every 2–3 days, only while metrics hold | Faster ramps trigger throttling |

## What this skill will not help you do

Deliverability tooling is routinely abused to make unwanted mail look wanted.
Three tactics circulate widely in outreach playbooks and are out of scope
here except as warnings, because they are provider-ToS violations, are
detectable, and poison the sender running them:

- **Fabricated-engagement warmup networks** — bot pools that open, reply to,
  and rescue each other's mail to fake a good reputation.
- **Disposable-domain farming** — treating burned domains as consumables and
  rotating in lookalike replacements.
- **Fingerprint dodging** — content randomization and signature rotation done
  specifically so filters cannot recognize a bulk campaign.

Each is covered, with the honest alternative, in
[references/warmup-and-volume.md](references/warmup-and-volume.md).

## Related skills

- `mailneo` — pulling sending, bounce, and complaint analytics or managing
  sender accounts through the Mailneo API, so diagnosis starts from real
  numbers instead of guesses.
- `email-lifecycle` — list hygiene, sunset policies, and re-permission
  campaigns; the cheapest way to cut complaints is to stop mailing people
  who stopped wanting mail.
- `email-compliance` — the legal layer (opt-out law, consent regimes).
  Deliverability compliance and legal compliance overlap but are not the
  same thing; passing one does not grant the other.
- `email-copywriting` — when placement is healthy and the problem is that
  nobody responds.
