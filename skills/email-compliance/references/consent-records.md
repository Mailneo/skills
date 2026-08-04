# Consent records, erasure and data hygiene

> **This is practical guidance, not legal advice.** It describes record
> keeping and data handling patterns that hold up well in practice.
> Retention periods, transfer mechanisms and the finer points of erasure
> law vary by jurisdiction — take specific questions to a qualified
> lawyer.

Consent is an evidentiary problem before it is a legal one. In every
opt-in regime the burden of proof sits with the sender: "they are on the
list" proves nothing, because the question is always *how they got there*.
Design the records first and the sending program on top of them.

## What a defensible consent record contains

One record per address, written at the moment of consent and never edited
afterwards:

- **Who** — the email address, plus any name or account identifier given.
- **When** — a timestamp with timezone.
- **Where** — the source: the form URL, page, event or flow in which
  consent was collected.
- **What they saw** — the exact consent wording and the version of the
  privacy notice displayed at that moment. Snapshot form versions; a
  record that points at "the current signup page" proves nothing about
  what the page said two years ago.
- **What they agreed to** — the scope: which sender, which message
  categories (newsletter vs product announcements vs partner offers).
  Consent to one is not consent to all.
- **How** — the affirmative act: a checkbox that started unchecked, a
  button press, a verbal confirmation someone logged. Pre-ticked boxes
  and consent buried in terms of service are invalid in the EU, UK and
  Canada.
- **Confirmation evidence**, if double opt-in was used: the confirmation
  message identifier and the timestamp of the confirming click.

Store these append-only and keep them for as long as you rely on the
consent, plus your jurisdiction's limitation period. When someone
withdraws, record the withdrawal the same way — the pair tells the whole
story.

## Double opt-in as evidence

Double opt-in — a signup followed by a confirmation email whose link the
person must click before any marketing flows — is legally *required*
almost nowhere. It is nonetheless the strongest consent evidence that
exists, because it proves control of the mailbox: a form submission alone
shows only that someone typed an address, and courts in the strictest
jurisdictions (Germany in particular) have treated single opt-in as
unprovable for exactly that reason.

Two implementation notes. The confirmation email itself must be neutral —
no offers, no promotion — because in opt-in regimes a marketing message
sent before consent is confirmed is itself unsolicited marketing. And the
unclicked signups are not a shadow list: no click, no consent, no mail.
Double opt-in also filters typos, bots and spite signups, which is why the
deliverability case for it is as strong as the legal one. Flow mechanics
live in the email-lifecycle skill.

## Imports and list provenance

Consent does not transfer. It was given to a named party for named
purposes; it does not travel with the address to whoever acquires it.
That single fact decides most import questions:

- **Purchased or rented lists.** The soft opt-in can never apply (you had
  no sale relationship), and consent collected by a broker almost never
  names you specifically enough to be valid. Regulators treat bought
  lists as presumptively non-consented, and most sending platforms ban
  them outright — the third layer of the model fails even where the first
  arguably passes.
- **Lead-gen forms, co-registration, event and conference lists.** Usable
  only if the wording the person saw named you (or a clearly defined
  category including you) and the organizer can hand you the records
  above. "Partners may contact you" is weak; a named-sender checkbox is
  strong.
- **Migrating between tools.** Bring the consent records with the
  addresses, and bring the suppression list *first* — an import that
  resurrects past opt-outs is the classic self-inflicted violation.

Before any import, get answers in writing: where collected, when, under
what wording, whether the records exist per address, when the list was
last mailed, and its bounce and complaint history. Then tag every
imported segment with its provenance, so a complaint or a regulator's
question years later can be answered from data instead of memory. Age
matters too: implied-consent windows expire (Canada's are explicit —
two years, six months), and regulators expect re-permission rather than
resumed mailing for long-dormant lists.

## Erasure requests vs suppression retention

Two different requests arrive looking similar, and conflating them causes
violations in both directions:

- **"Stop emailing me"** — an objection / opt-out. Add the address to the
  suppression list and keep the record. Do not delete it.
- **"Delete my data"** — an erasure request. Delete the profile, the
  history, the tracking data — everything *except* the minimum needed to
  keep honoring the opt-out.

The point that surprises people: honoring an objection forever requires
*remembering* the address forever. A suppression entry retained after an
erasure request is not a compliance failure — it is compliance. Erasure
rights everywhere give way to retention necessary to meet a legal
obligation, and the obligation to never mail this person again is exactly
that. Deleting the suppression entry would guarantee unlawful re-contact
the next time an import or integration reintroduces the address.

Practice: keep the minimum (the address or a salted hash, the date, the
reason — unsubscribe, complaint, erasure), hold it in a store the
marketing tools can check but not mail from, and tell the requester
plainly: "we have deleted your data and retained only your address on our
do-not-contact list so this decision is honored." Suppression must also be
global — across brands, sending tools and future imports — or it is
theater.

The operational distinction matters in tooling as well: in the mailneo
skill's API terms, a suppression is reversible and a subscriber or
contact deletion is permanent erasure. An erasure request therefore maps
to *delete plus suppress*, never delete alone.

## Data-processing hygiene for email tools

The email platform processes personal data on your behalf, which pulls in
the ordinary data-protection duties:

- **Processor agreement.** Have a data-processing agreement with every
  tool that touches subscriber data, review its subprocessor list, and
  confirm a lawful transfer mechanism if data leaves the recipient's
  region.
- **Minimization.** Sync only the fields the program uses. Every column
  copied into the email tool is another column to erase, export and
  defend.
- **Retention schedule.** Subscriber data should have a defined lifetime:
  sunset long-inactive addresses (policy patterns in email-lifecycle)
  and purge event-level data you no longer use. Consent evidence outlives
  the subscriber record; suppression entries outlive everything.
- **Deletion propagation.** An erasure request must reach every copy: the
  email platform, the CRM, the data warehouse, exports, archive mailboxes
  and any webhook consumers. Backups may be handled on a documented decay
  schedule rather than same-day, but the policy must exist and be
  followed.
- **Access control.** Least privilege on the sending tool — an exported
  list in the wrong hands is a breach, not a marketing incident.
- **Engagement tracking.** Opens and clicks tied to a person are personal
  data in opt-in jurisdictions: disclose the tracking in your privacy
  notice, and note that some European regulators read the rules as
  requiring consent for tracking pixels specifically — a live question
  that belongs with your lawyer, not a default to assume away.
