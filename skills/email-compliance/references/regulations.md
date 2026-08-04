# Regulation summaries and the cold-email lawfulness matrix

> **This is practical guidance, not legal advice.** These are working
> summaries for engineers and marketers, not statutory analysis. Penalty
> caps and deadlines below were checked in mid-2026 and several adjust
> annually — verify current figures before relying on an exact number, and
> take jurisdiction-specific questions to a qualified lawyer.

Orientation: the recipient's location decides which statute applies, and a
mixed list means every applicable statute applies at once.

| Regime | Model | Penalty order of magnitude |
| --- | --- | --- |
| US — CAN-SPAM | Opt-out | Tens of thousands of dollars *per email* |
| EU — GDPR + ePrivacy | Opt-in | Up to EUR 20M or 4% of global turnover (GDPR tier) |
| UK — PECR + UK GDPR | Opt-in | Up to GBP 500k (PECR); GBP 17.5M or 4% (UK GDPR) |
| Canada — CASL | Opt-in | Up to CAD 10M per violation (organizations) |
| Australia — Spam Act | Opt-in | Millions of AUD for repeat corporate offenders |

## United States — CAN-SPAM Act (2003)

**Who it covers.** Any "commercial electronic mail message" — a message
whose primary purpose is advertising or promotion. No consent is required
before sending, and the Act draws no B2B/B2C line: it is an **opt-out
regime**, which is exactly why compliant US cold email is lawful.
Transactional and relationship messages (receipts, account notices) are
exempt from most requirements, but their header information still may not
be false or misleading.

**Every commercial message must:**

- Carry accurate header information — From, To, reply-to and routing must
  identify the person or business that actually initiated the message.
- Use a subject line that does not deceive about the message's content.
- Identify itself as an advertisement (the law is flexible about how, but
  the disclosure must be clear and conspicuous).
- Include a valid physical postal address: a street address, a post-office
  box registered with the postal service, or a registered private mailbox.
- Include a clear and conspicuous opt-out notice with a working mechanism.

**Unsubscribe rules.** The mechanism must be able to process opt-outs for
at least **30 days** after the message is sent. Requests must be honored
within **10 business days**. You may not charge a fee, demand any
information beyond an email address, require a login, or require more than
a reply email or a visit to a single web page. Opted-out addresses may not
be sold or transferred (except to a vendor helping you comply).

**Liability.** Both the company whose product is promoted and the company
that physically sends can be liable; compliance cannot be contracted away
to an agency. Aggravated conduct — harvested addresses, dictionary
attacks, automated account creation, relaying through unauthorized
machines — increases exposure and can become criminal.

**Penalties.** Civil penalties are assessed **per individual email**, not
per campaign, and the cap is inflation-adjusted annually — a little over
USD 53,000 per email as of the 2025 adjustment. One non-compliant blast to
a modest list is, on paper, an eight-figure exposure.

**Adjacent US law.** CAN-SPAM mostly preempts state anti-spam statutes,
but not state laws about fraud or deception. Separately, state privacy
statutes (California's and its successors elsewhere) grant access and
deletion rights over the data you hold about their residents; they change
your data handling, not the opt-out sending model.

## European Union — GDPR + ePrivacy Directive

Two instruments stack. The **ePrivacy Directive** (as transposed into each
member state's national law) governs the act of sending electronic
marketing; the **GDPR** governs the personal data underneath — and a work
email address that identifies a person is personal data. Both apply to
senders outside the EU when the recipients are in it.

**Consent regime.** Unsolicited email marketing to individuals requires
**prior consent**. The GDPR sets the standard: freely given, specific,
informed and unambiguous, given by a clear affirmative act. Pre-ticked
boxes are invalid (the EU's top court has said so explicitly), consent
bundled into terms of service is not "freely given", withdrawal must be as
easy as giving, and the sender bears the burden of proving consent exists
(see consent-records.md).

**The soft opt-in.** The one general exception: you obtained the address
from an existing customer in the context of a sale of your product or
service, you market only your **own similar** products or services, and
you offered a free, easy way to refuse both at collection and in every
subsequent message. It never applies to bought lists or third-party
promotion.

**Legitimate interest and B2B.** The GDPR's recitals recognize direct
marketing as a possible legitimate interest, but that answers only the
GDPR layer — it does not override the ePrivacy consent requirement for the
send itself. Legitimate interest matters mainly where a member state's
transposition permits B2B email without consent. Even there you need a
documented legitimate-interest assessment, a transparency notice to people
whose data you did not collect from them, and an **absolute** right to
object: when someone objects to direct marketing you stop, with no
balancing test.

**Member-state variation (the trap in "EU B2B is fine").** Germany treats
email advertising without prior express consent as unlawful for businesses
and consumers alike, courts there effectively require double opt-in as
proof, its existing-customer exception is narrow, and competitors can
enforce by cease-and-desist letter with legal fees attached. Austria is
similarly opt-in for B2B. Some other states (for example the Netherlands,
Belgium, France in practice) leave more room for messages to corporate
addresses with a clear opt-out. There is no EU-wide safe answer: check the
recipient's country.

**Erasure vs suppression.** The right to object to direct marketing is
unconditional, and honoring it forever requires *remembering* the address.
Retaining a minimal suppression record after an objection — or even after
an erasure request — is itself lawful and necessary: erasure obligations
give way to retention needed to comply with a legal obligation, and
deleting the suppression entry would guarantee unlawful re-contact via the
next import. Keep the minimum (address or hash, date, reason), keep it out
of marketing-usable stores, and say that this is what you do.

**Penalties.** GDPR fines reach EUR 20M or 4% of global annual turnover,
whichever is higher; ePrivacy penalties are set nationally and vary.
Marketing-consent violations are among the most commonly fined GDPR
breaches.

## United Kingdom — PECR + UK GDPR

The UK kept the same two-layer structure after leaving the EU: **PECR**
governs the sending, the **UK GDPR** governs the data.

**Individual vs corporate subscribers.** PECR's consent rule protects
"individual subscribers" — which includes sole traders and ordinary
partnerships, so a B2B list is legally mixed. Sending to individual
subscribers requires consent (GDPR standard) or the **soft opt-in**:
details collected during a sale or negotiations for a sale, marketing your
own similar products or services, and a refusal option at collection and
in every message.

**Corporate subscribers** (limited companies, LLPs, public bodies) sit
outside the consent rule — you may email them unsolicited — but you must
still identify yourself and provide a working opt-out, and the UK GDPR
still applies to the named individual's work address: you need a lawful
basis (usually a documented legitimate-interest assessment) and must stop
on objection.

**Bought lists** are effectively unusable for email: the soft opt-in can
never apply to them, and consent collected by someone else rarely names
you specifically enough to be valid.

**Penalties.** The regulator can fine up to GBP 500,000 for PECR breaches
— and it fines routinely — plus UK GDPR penalties up to GBP 17.5M or 4% of
global turnover for the data-protection side.

## Canada — CASL

Widely regarded as the strictest of the major regimes. It covers any
"commercial electronic message" (CEM) sent to or from Canada.

**Consent first.** Consent — express or implied — must exist *before* the
message is sent, and the sender bears the burden of proving it.

- **Express consent**: an affirmative opt-in (pre-checked boxes do not
  count) in response to a request that identified who is asking and for
  what. It lasts until withdrawn. Trap: an email asking for permission is
  itself a CEM, so you cannot lawfully email someone to request consent
  you do not yet have.
- **Implied consent** is time-boxed by category: an existing business
  relationship lasts **two years** from the last transaction; an inquiry
  lasts **six months**; an email address the person conspicuously
  published, or gave you directly, may be used only if no "no unsolicited
  messages" note accompanies it **and** the message is relevant to the
  person's business role.

**Every CEM must** identify the sender and anyone on whose behalf it is
sent, include contact information valid for at least 60 days, and carry a
no-cost unsubscribe mechanism that keeps working for 60 days after the
send and is honored within **10 business days**.

**Penalties.** Administrative monetary penalties up to CAD 1M per
violation for individuals and CAD 10M for organizations, with personal
liability possible for directors and officers. The private right of action
in the statute has been suspended indefinitely, but regulator enforcement
is real and has produced six-figure penalties. Treat Canadian addresses as
opt-in only.

## Australia — Spam Act 2003

**Consent regime.** Commercial electronic messages require **express or
inferred consent**. Inferred consent comes from an existing relationship,
or — narrowly — from a work address the person conspicuously published,
provided the message is relevant to their role and the publication carries
no "no unsolicited messages" note.

**Every message must** accurately identify the sender (with contact
details valid for at least 30 days) and include a functional unsubscribe
facility that works for at least **30 days** after sending, costs no more
than ordinary transmission, and does not require a login, account creation
or extra personal information. Opt-outs must be honored within **5
business days**.

**Penalties.** Civil penalties scale with company size and repeat
offenses into the millions of AUD per day of contravention. The regulator
enforces frequently, including against household-name brands — a common
finding is messages that kept flowing after unsubscribe, or unsubscribe
flows that required logging in.

## Elsewhere, in one line each

- **New Zealand** — opt-in with functional unsubscribe (2007 statute),
  similar shape to Australia's.
- **Japan** — opt-in for advertising email since 2008, with sender
  identification and opt-out requirements.
- **Singapore** — unsubscribe facility and accurate labeling required for
  unsolicited bulk mail, with consent obligations for the personal data
  underneath.
- **South Africa** — opt-in for electronic direct marketing with an
  existing-customer exception, under its data-protection statute.
- **Brazil** — no dedicated spam statute; its general data-protection law
  requires a lawful basis, so the GDPR-style analysis applies.

Default posture for any country you have not checked: assume opt-in.

## The provider layer (2024+)

In February 2024, Google and Yahoo began enforcing bulk-sender rules for
anyone sending roughly **5,000+ messages per day** to their users; Microsoft
followed for its consumer mailboxes in 2025. The core requirements:

- Full authentication: SPF and DKIM, plus an aligned DMARC policy.
- **One-click unsubscribe** on marketing mail: the `List-Unsubscribe`
  (HTTPS URL) and `List-Unsubscribe-Post` headers (RFC 8058), with the
  automated POST honored within **two days**.
- User-reported spam rate kept below **0.3%**, with about 0.1% as the
  working target.

Two consequences. First, the two-day unsubscribe expectation is far
stricter than any statute — build for it and the legal deadlines are moot.
Second, these rules attach to the *recipient's mailbox provider*, not to
any jurisdiction: a perfectly CAN-SPAM-compliant US sender still loses
Gmail and Yahoo delivery without them. Implementation mechanics live in
the email-deliverability skill.

## Cold-email lawfulness matrix

"Cold" here means: no prior consent, no prior relationship. Rows are the
**recipient**, because their location and status pick the law.

| Recipient | Cold email lawful? | What it takes |
| --- | --- | --- |
| US — any recipient (B2B or B2C) | **Yes** | The full CAN-SPAM floor: truthful headers and subject, ad identification, postal address, clear opt-out working 30+ days, honored within 10 business days |
| Canada — any recipient | **Rarely** | An implied-consent lane must exist: role-relevant conspicuously published address with no opt-out note, or a live business relationship — plus full CEM formalities |
| UK — corporate subscriber | **Conditionally** | No PECR consent needed, but UK GDPR requires a documented legitimate-interest assessment, sender identification and an opt-out in every message |
| UK — individual subscriber (incl. sole traders) | **No** | Consent or soft opt-in only |
| EU — individual | **No** | Prior consent; legitimate interest does not substitute for the ePrivacy consent requirement on the send itself |
| EU — corporate / B2B | **Member-state dependent** | Prohibited without consent in Germany and Austria; permitted with conditions in some states — per-country check, legitimate-interest assessment, transparency notice, opt-out |
| Australia — any recipient | **Rarely** | Express or inferred consent; the published-address lane requires role relevance and no opt-out note |

**The worked contrast.** A compliant US B2B cold email — truthful,
identified as commercial, postal address, working opt-out — is lawful
because the US regime only regulates *how* to send. Send the identical
message to an individual in the EU and it is presumptively unlawful: the
send needs prior consent under the recipient country's ePrivacy rules,
the data processing needs a GDPR basis plus a transparency notice (since
you did not collect the address from them), and if challenged, *you* must
produce the evidence. At best — for corporate addresses in permissive
member states — a documented legitimate-interest analysis can carry it;
at worst (Germany, Austria) there is no lane at all.

Two closing cautions: "individual" in the opt-in regimes describes the
subscriber, not the message topic — B2B *content* does not convert a
protected recipient into fair game. And a person's location is a fact
about them, not about your intent; if you cannot tell where your list's
recipients are, you cannot tell which of these rows you are in.
