---
name: email-compliance
description: "Use when questions involve the legality of sending: consent, unsubscribe requirements, CAN-SPAM, GDPR, CASL, PECR, cold-email lawfulness, data retention/erasure. Do NOT use for deliverability mechanics (email-deliverability) or copy (email-copywriting)."
---

# Email compliance

> **This is practical guidance, not legal advice.** It describes how the law
> around commercial email generally works so you can choose safe defaults.
> Statutes, regulatory guidance and penalty figures change, and how they
> apply to a specific business is fact-dependent — jurisdiction-specific or
> high-stakes questions belong with a qualified lawyer.

## The three-layer model

Every commercial email must clear three independent rule sets, and the
strictest applicable rule wins:

1. **The law of the recipient's jurisdiction.** Not the sender's. A US
   company mailing a list that contains German addresses is doing
   German-law sending for those addresses. The world splits into two
   regimes: **opt-out** (the US — unsolicited commercial email is lawful if
   every message carries the required disclosures and a working opt-out)
   and **opt-in** (the EU, UK, Canada, Australia and most others — consent
   or a narrow statutory exception must exist *before* the send).
2. **Mailbox-provider rules.** Since 2024 the major consumer mailbox
   providers require authenticated mail, one-click unsubscribe headers and
   low complaint rates from bulk senders. Treat this as de facto law in
   every jurisdiction: it is enforced by delivery denial, with no court and
   no appeal, and it is stricter than most statutes.
3. **Platform terms of service.** The sending platform's own rules — many
   prohibit purchased lists or unsolicited sending outright, whatever local
   law says — enforced by account suspension.

"Is this legal?" is therefore never one question. Ask three: lawful for
this recipient's jurisdiction? within provider rules at this volume?
within the sending platform's terms?

## The universal floor

Whatever the jurisdiction mix of a list, these five hold everywhere and
satisfy the overlap of every major regime:

- **Identify yourself truthfully.** Real sender name, accurate From and
  reply path, and — where required — a physical postal address. Never
  misrepresent who is sending or why.
- **Working unsubscribe in every commercial message.** Visible, free of
  charge, no login, nothing demanded beyond the email address. At bulk
  volume, also the one-click unsubscribe headers (mechanics in
  email-deliverability).
- **Honor opt-outs fast.** Legal maximums: 10 business days (US, Canada),
  5 business days (Australia), promptly / without undue delay (UK, EU).
  Provider expectation: about two days. Engineer for immediate and every
  deadline takes care of itself.
- **Keep consent records.** Who consented, when, where, to what, and the
  exact wording they saw. In every opt-in regime the burden of proving
  consent sits with the sender. See references/consent-records.md.
- **Suppress forever.** An opt-out never expires, and even a deletion
  request does not purge the suppression list — retaining a minimal
  do-not-contact record is itself lawful and necessary
  (references/consent-records.md explains why).

## Tactics to refuse

Each of these circulates in cold-outreach culture as advice. Each is an
anti-pattern with a legal reason attached:

- **A casual reply-to-decline line as the only opt-out.** US law does
  permit a reply-based opt-out, but the notice must be clear and
  conspicuous — a buried "no worries if not" written to disguise the
  message's commercial nature fails that standard, fails every opt-in
  regime outright, and fails the provider one-click rule at bulk volume.
- **Broken-link ploys** (a dead "personalized video" link sent so the
  recipient replies to report it): engineered deception — a deceptive
  commercial practice, and every reply it wins is obtained under false
  pretenses.
- **Fake mobile signatures** on desktop-composed bulk mail: a
  misrepresentation of the message's nature; a small lie in the same legal
  category as the large ones.
- **Phrasing randomization or signature rotation done to dodge filters.**
  Deliberately defeating provider abuse detection violates provider terms
  and is standing evidence the sender knows the mail is unwanted. Natural
  variation for quality is fine; variation *aimed at filters* is not.
- **Fabricated-engagement warmup networks** (bots opening, replying with
  positive sentiment, rescuing mail from spam folders): synthetic
  engagement built to deceive reputation systems — a provider-terms
  violation and the same species as fake reviews.
- **Disposable lookalike-domain farming.** Burning and replacing domains
  launders sender reputation, circumvents limits providers impose on
  purpose, and lookalike domains can make a message's origin materially
  misleading.
- **Manufactured scarcity** ("only two spots left" with no real limit):
  false availability claims are deceptive commercial practices, and EU
  consumer law bans false scarcity by name.
- **Pretext angles** — fake research surveys, fake podcast invitations,
  fake who-is-the-right-person mails that are really pitches.
  Misrepresenting a message's purpose is deception even when every
  individual sentence is true.
- **Volume models that presume no consent.** Unsolicited bulk mail tuned
  to stay under detection thresholds is unlawful by default in the EU, UK,
  Canada and Australia — and even in the US, every message still owes the
  full disclosure-and-opt-out floor.
- **Anything that works only if the recipient believes something false** —
  about the sender, the message's origin, its personalization, its
  scarcity or its purpose. Deception is what regulators punish hardest and
  the fastest way to lose the channel entirely.

## Cold email, briefly

Unsolicited B2B email is lawful in the US precisely because its statute is
an opt-out regime: it governs *how* you send, not *whether* you may. The
same message to an EU or UK individual is unlawful without prior consent;
to a Canadian recipient it needs an express- or implied-consent lane; to
an Australian recipient, express or inferred consent. And "B2B" is not a
jurisdiction: several European countries protect business recipients — or
at least sole traders — exactly like consumers. The per-jurisdiction
analysis, including member-state variation, is the cold-email lawfulness
matrix in references/regulations.md.

## References

- **references/regulations.md** — working summaries of each major regime
  (who it covers, consent model, unsubscribe rules, penalty magnitudes)
  for the US, EU, UK, Canada and Australia; one-line awareness of others;
  the 2024+ provider layer; and the cold-email lawfulness matrix.
- **references/consent-records.md** — what a defensible consent record
  contains, double opt-in as evidence, imported-list provenance, erasure
  requests versus suppression retention, and data-processing hygiene for
  email tooling.
- **references/checklists.md** — pre-send, cold-campaign (US B2B),
  EU-audience and unsubscribe-SLA checklists, plus an audit-your-practice
  question list.

## Related skills

**email-deliverability** covers the one-click unsubscribe headers and
authentication the provider layer demands; **email-lifecycle** covers the
double opt-in flows and sunset policies that generate the consent evidence
described here; **mailneo** operates suppression lists and permanent
erasure through the platform API. For what the message should say, use
**email-copywriting** — nothing in it overrides anything in here.
