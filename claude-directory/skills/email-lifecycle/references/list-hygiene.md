# List growth and hygiene

Growth and hygiene are one discipline, not two. Every acquisition decision
is also a future hygiene problem or non-problem: an address that arrived
through a clear, specific opt-in almost never bounces, complains, or needs
sunsetting in year one; an address that arrived through a sweepstakes
widget or an import of unknown provenance starts costing you immediately.
Mailbox providers score the sender, not the campaign — see
**email-deliverability** for the reputation mechanics this feeds.

## Growing the list

### The trade at the form

People give an address in exchange for something specific. The specificity
is the point: "get our newsletter" converts poorly and produces lukewarm
subscribers; "get the 12-point pre-flight checklist we run before every
product launch" converts better and produces subscribers who remember why
they signed up. Whatever the incentive, the form must say what regular
email the person is agreeing to ("plus one teardown email every Thursday")
— an incentive-only signup that then receives weekly promotions generates
complaints, and in most consent regimes it is a bundling problem too
(see **email-compliance**).

Practical form guidance, from aggregate industry testing:

- **Fewer fields win.** Email alone, or email plus first name. Every
  additional field costs signups; collect the rest progressively later.
- **Placement is a portfolio.** Embedded forms inside relevant content
  (mid-article converts better than end-of-article, because readers are
  still there), a persistent but quiet footer or sticky-bar option, and
  at most one interruptive surface — exit-intent overlays capture people
  who were leaving anyway and are the least annoying of the popup
  family. Typical popup conversion is low single digits (1–4%);
  well-matched embedded offers on high-intent pages can do far better.
- **Match magnet to page.** A checklist offered on the article it
  extends converts several times better than a generic sitewide offer.
- **Say the cadence at the form.** "One email a week, unsubscribe
  anytime" costs almost nothing at signup and measurably reduces later
  complaints, because nobody feels ambushed.

### Single vs double opt-in

Double opt-in (subscriber must click a confirmation link before receiving
anything) versus single opt-in (address is live immediately) is a
risk-and-region decision, not a religion.

| Factor | Single opt-in | Double opt-in |
|---|---|---|
| List growth | Faster — every form fill counts | Expect to lose roughly 15–30% at the confirmation step |
| Address quality | Typos, bots, and spite-signups get in | Only working, wanted addresses get in |
| Consent proof | Weak — you hold an IP and a timestamp | Strong — you hold a confirmed action from the mailbox owner |
| Deliverability | You absorb the bounce/complaint cost of the junk | Confirmed lists bounce and complain far less |

Decision recipe:

- **Mailing into Germany or Austria: double opt-in, no debate.** Courts
  there treat single opt-in as insufficient proof of consent; double
  opt-in with a neutral confirmation email (no marketing content in it)
  is the established standard.
- **EU/UK generally:** consent must be provable. Double opt-in is not
  literally mandated by the GDPR, but it is the cheapest reliable proof,
  so default to it.
- **US/consumer, low-risk vertical, forms protected by a bot check:**
  single opt-in is defensible if you compensate with hygiene — verify
  addresses at capture or before first send, watch early bounce rates,
  and sunset aggressively.
- **Anything high-abuse** (giveaways, co-registration, paid signup
  traffic, gated downloads promoted broadly): double opt-in regardless
  of region. These channels attract exactly the addresses that burn
  sender reputation.

If a confirmation email goes unclicked, send at most one reminder within
a couple of days, then drop the address. Never "rescue" unconfirmed
signups into the main list months later.

### Imports: the only rule that matters

Import only addresses whose owners knowingly opted in **to you**. That
covers migrating from a previous platform, merging your own product
signups (where marketing consent was actually collected), and restoring
your own backups.

Never import purchased, rented, scraped, appended, or "partner-shared"
lists. The reasons are concrete, not moral posturing:

- **Spam traps.** Sold lists contain recycled and pristine trap
  addresses maintained by mailbox providers and blocklist operators.
  One send to a trap-seeded list can blocklist your domain. There is no
  way to screen traps out — that is the design.
- **The complaint math is unsurvivable.** The major mailbox providers'
  bulk-sender rules (in force since 2024) set a hard spam-complaint
  ceiling of 0.3% with a recommended target under 0.1%. That is three
  complaints per thousand sends. People who never heard of you complain
  at many times that rate; a single purchased-list send can put you over
  the ceiling for your entire domain, taking your legitimate mail down
  with it.
- **Legal exposure.** Mailing bought addresses breaches the GDPR's
  consent requirements, Canada's consent regime, and similar laws
  elsewhere; even where technically lawful it usually breaches your
  sending platform's terms, and platforms suspend accounts for it.
- **It does not even work.** Opens on purchased lists commonly land
  under 5% — a tenth of a mediocre opt-in list — before counting the
  reputation damage to everything else you send.

Gray areas to treat as cold, not opt-in: conference badge scans, business
cards collected at a booth, addresses from a webinar you co-hosted where
the other party owned the registration. If the person did not knowingly
agree to *your* list, they are not on it.

## Keeping the list clean

### List decay is the baseline

Expect roughly 20–25% of any list to go bad per year (industry
verification datasets cluster at 22–23%; B2B decays faster because job
changes kill addresses — a majority of role-based contact data changes
within a year). A 10,000-address list left untouched for a year has
~2,000 dead entries. Hygiene is not a one-time cleanup; it is a monthly
metabolism. Before re-mailing any segment that has been idle for 6+
months, run it through an address-verification service and drop the
invalid and risky results.

### Bounce handling

- **Hard bounce** (address does not exist): suppress immediately and
  permanently, on the first occurrence. Repeatedly hitting dead
  addresses is the fastest reputation killer there is.
- **Soft bounce** (mailbox full, temporary failure): retry is fine, but
  track consecutively. After 3–5 consecutive soft bounces across
  separate campaigns, treat as hard and suppress — "temporarily"
  full mailboxes that stay full for a month are abandoned.
- **Watch the rate.** Keep total bounces under 2% of any send; a spike
  above that on one campaign means the audience selection included
  stale addresses — pause and investigate before the next send.

Most sending platforms automate the mechanics; your job is to never
override them (see the suppression rules below) and to notice trends.
In **mailneo**, bounce suppressions are written by the delivery pipeline
with a `reason` you can audit via the suppressions API.

### Complaint processing

A spam-button press is the strongest negative signal a recipient can
send. Handle it as an absolute:

- Suppress complainers immediately and permanently. Never mail an
  address that has complained, ever, for any campaign type.
- Register for the feedback loops mailbox providers offer (your
  platform usually does this for you) so complaints actually reach your
  suppression list.
- Track complaint rate per campaign *and* per acquisition source.
  Target under 0.1%; treat 0.3% as a cliff edge, because at the major
  providers it is one. A single source (one giveaway, one import)
  producing outsized complaints should be cut as a source, not just
  cleaned as a segment.
- Make unsubscribing effortless — one-click unsubscribe headers are now
  required of bulk senders anyway, and every person who unsubscribes
  easily is a person who did not press the spam button instead.

### Suppression-list discipline

The suppression list is the program's memory of "no". Rules:

- It is global (applies to every campaign, journey, and one-off send),
  permanent, and survives platform migrations and re-imports. When you
  move platforms, the suppression list moves first.
- Never delete suppression entries to "clean up the list". Each entry
  encodes a bounce, a complaint, or an opt-out; deleting it re-enables
  mail to someone who was deliberately blocked. Removing an
  *unsubscribe* suppression is a compliance decision that requires that
  person's fresh, explicit consent — not an operational cleanup.
- Unsubscribes take effect immediately in practice. Legal regimes allow
  a short processing window; queued sends going out after someone opted
  out generate complaints regardless of what the law allows.
- Erasure requests are different from suppression — see
  **email-compliance** for when you must delete rather than suppress,
  and the hashed-suppression pattern that lets you honor both.

### Sunset policy: concrete recipes

A sunset policy defines when a non-engaging subscriber stops receiving
mail. Anchor thresholds to your cadence — "180 days inactive" means 25
ignored emails for a weekly sender and 6 for a bimonthly one.

Because Apple's Mail Privacy Protection fires opens by machine, define
"engaged" on signals a machine does not fake: clicks, site visits,
purchases, replies, preference updates. Opens can *extend* engagement for
non-Apple recipients but should never be the only thing keeping someone
in the mailable pool.

| Your cadence | Move to "lapsing" after | Re-permission after | Suppress after |
|---|---|---|---|
| Daily | 30–45 days no engagement | 60–90 days | 90–120 days |
| Weekly | 90 days | 150–180 days | ~180–210 days |
| Monthly | 120–180 days | 9–12 months | 12 months |

Stage behavior:

- **Lapsing:** cut their frequency (weekly → every other week), send
  your best material only. Many people cool because of volume, not
  disinterest; opting them down retains a surprising share.
- **Re-permission:** a short explicit sequence (below). New subscribers
  get a grace period — never sunset anyone in their first 60–90 days,
  and never count the welcome-journey window against them.
- **Suppress:** stop mailing. Keep the address suppressed (so a future
  import cannot resurrect it) unless an erasure obligation says delete.

### Re-permission campaign recipe

Worked example — a woodworking-plans newsletter, weekly cadence, 40,000
subscribers, 9,000 of whom have not clicked anything in 180 days:

1. **Email 1 — the honest question.** Subject names the situation
   ("Still want the Thursday plans?"). One line of why you're asking,
   one button: "Keep sending them." No guilt, no ten-paragraph recap.
2. **Email 2 (5–7 days later) — the best-of.** Three most-clicked
   plans of the year, same single button. This catches people whose
   silence was circumstantial, not terminal.
3. **Email 3 (5–7 days after that) — the goodbye.** "No click by
   Friday and we'll stop emailing — you can come back anytime." Some
   programs add an opt-down option here (monthly digest instead of
   weekly); it converts fence-sitters.

Anyone who clicks re-enters the active pool with a fresh clock. Everyone
else is suppressed on schedule — *without* a follow-up "we noticed you
didn't respond" email. Expect single-digit to low-teens reactivation of
the dormant pool; the campaign's real product is the clean 31,000-person
list whose engagement rates and reputation improve the moment the dead
weight stops receiving mail. Resist the sunk-cost argument ("we paid to
acquire them"); the acquisition cost is spent either way, and continuing
to mail the unresponsive spends *more* by taxing delivery to the people
who do read.

The copy for each of these messages is **email-copywriting** territory;
executing the segments and suppressions through the API is **mailneo**.
