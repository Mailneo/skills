# Troubleshooting: from symptom to cause

Work the tree top-down. Before anything else, distrust your instruments:
open tracking is noisy in both directions. Privacy features that proxy and
prefetch images (Apple Mail's is the big one) fire "opens" nobody performed,
inflating rates; image blocking hides opens that did happen, deflating them.
Steer by the robust signals — bounces, provider dashboards, replies, clicks,
seed placement — and treat open rate as a trend line, not a truth.

## The decision tree

### 1. Opens are low (relative to *your* baseline)

A placement problem until proven otherwise. Check in this order — it runs
from cheapest to check and most likely, downward:

1. **Authentication, on live mail.** Send to a test mailbox at each major
   provider and read raw headers ("Show original" in Gmail). SPF, DKIM,
   DMARC must all pass, with *your* domain as the authenticating domain.
   A rotated DKIM key, an edited SPF record, or an expired platform
   delegation silently fails weeks after someone touched DNS. Details:
   [authentication.md](authentication.md).
2. **Bounce log, read closely.** Rejection texts name their reasons:
   authentication failures cite policy codes, blocklist blocks name the
   list (often with a lookup URL), rate limiting says try later. The
   diagnosis is frequently sitting verbatim in the bounce you have not
   read. Classification guide below.
3. **Complaint rate.** Check the provider dashboards (below). Above 0.1%
   and climbing predicts trouble; above 0.3% *is* the trouble.
4. **Blocklists.** Check the operators' own lookup tools (section below).
5. **What changed** — see the sudden-drop audit.
6. **Content and links, last.** Content matters less than reputation, but
   shared tracking domains, link shorteners, mismatched link text vs
   destination, and attachments all add risk. Widely circulated claims that
   a tracking pixel alone costs some fixed slice of placement (a "20%"
   figure makes the rounds) are not verifiable and should not drive
   decisions — but the underlying direction is real: remote content from a
   shared tracking hostname inherits that hostname's reputation.

Heuristic bands from outreach practice — under ~30% opens means placement
trouble, 30–50% means look at targeting and subject lines first — are
serviceable *only* as rough priors, given how corrupted open data is. The
ordered checks above outrank them.

### 2. Opens are fine; replies/clicks are not

Mail is arriving; humans are declining. This is not deliverability. Route
to the `email-copywriting` skill (message, offer, ask) and the
`email-lifecycle` skill (list fit, segmentation, fatigue). Confirm placement
once with a seed test if paranoid, then stop debugging the wrong layer.

### 3. Sudden drop after a specific date

Reputation rarely collapses spontaneously — correlate the drop date against
a change audit:

- **DNS**: DKIM key rotation, SPF edits, expired delegations, registrar
  migration, tracking-domain certificate expiry.
- **List**: a new import, a purchased or scraped segment, a reactivation
  campaign into a stale cohort (complaint spikes live here).
- **Volume**: a spike beyond ~2–3× baseline, or resumption after silence.
- **Platform**: ESP migration, IP pool change, new dedicated IP, new
  sending subdomain.
- **Template**: new design, new link domains, first use of attachments.
- **External**: blocklist event, a provider policy-enforcement date, a
  compromised mailbox or web form on your domain spewing spam you have
  not noticed. Check outbound logs for volume you did not send.

One of these almost always lines up. Fix that, then run the recovery ramp
in [warmup-and-volume.md](warmup-and-volume.md).

## Seed testing, honestly

A seed test sends one message to a panel of mailboxes you (or a tool)
control across major providers and records the folder it lands in.

What it can tell you: systemic failures — authentication broken, a whole
provider junking or rejecting you, blocklist fallout, spam-folder placement
at a specific provider. As a before/after check around a change, it is
genuinely useful.

What it cannot tell you: where mail lands for *your actual recipients*.
Modern filtering is heavily personalized by each recipient's engagement
history with you; seed mailboxes have no history, so their placement is a
generic floor, not your real number. Panels also cannot price in your
audience's tab behavior, and Promotions-tab placement is not spam — treat
tab data as informational, not a defect to fix.

Practical use: above ~90% inbox on seeds, stop optimizing — the residue is
noise. Below that, look for a *systemic* pattern (one provider, one auth
mechanism) rather than chasing individual seed mailboxes. Re-test after
changes; continuous seed streams mostly generate anxiety.

## Reading Google Postmaster Tools

Free; verify your domain with a DNS TXT record. The current version (v2)
centers a **Compliance status** dashboard — a per-requirement Pass /
Needs work grade against the bulk-sender rules (authentication, DMARC,
one-click unsubscribe, spam rate, encryption, and so on), computed on a
multi-day rolling window over real traffic to personal Gmail accounts. It
is the first screen to check: it tells you *which* requirement Gmail thinks
you are failing. Because the window rolls, fixes take days to reflect —
do not conclude a fix failed after 24 hours.

The classic dashboards remain and matter:

- **Spam rate** — the enforced metric: user-reported spam among
  authenticated mail delivered to active inboxes, daily. Correlate any
  spike with what you sent that day. Target < 0.1%; never touch 0.3%.
- **Domain / IP reputation** — Bad, Low, Medium, High. "High" correlates
  with inbox delivery; a drop here usually trails a spam-rate spike by a
  few days.
- **Delivery errors** — rejected and temp-failed percentages with reason
  categories; rising errors are the early warning of a listing or policy
  breach.
- **Authentication** — the percentage of traffic passing SPF, DKIM, DMARC;
  a sagging line here means some stream (often a forgotten system) is
  sending unauthenticated.
- **Feedback loop** — campaign-level complaint aggregation, only populated
  if you embed the required identifier header. Note Gmail's FBL is
  aggregate-only: Gmail never reveals which recipient complained.

Caveats: data appears only at sufficient volume, low-volume days are
omitted, updates lag about a day, and everything covers consumer Gmail —
workspace-hosted corporate recipients are invisible here.

## Reading Microsoft SNDS

Microsoft's Smart Network Data Services is the counterpart for
Outlook.com/Hotmail/Live traffic, keyed by **IP address**, not domain (so
on a shared pool the data mixes in your neighbors — access usually sits
with whoever owns the IPs). Registration is free at Microsoft's postmaster
site.

- **Filter result color**: green — under 10% of the IP's mail spam-filtered;
  yellow — 10–90%; red — over 90%. Yellow is the working zone for most
  bulk senders; red means Microsoft delivery is effectively down.
- **Trap hits**: SNDS reports activity periods against Microsoft's spam
  traps. Any trap hit is a list-quality alarm — traps arrive on lists via
  scraping, purchase, or ancient addresses. That conversation continues in
  the `email-lifecycle` skill.
- **Complaint data**: complaint rates per IP per activity period.
- Data appears only when the IP sends Microsoft enough mail (on the order
  of 100+ messages/day).

Enroll separately in **JMRP** (Junk Mail Reporting Program): it forwards
you each complaint as it happens, including the reported message. Use it to
suppress complainers immediately and to identify *which* campaign draws
fire. Suppressing everyone who complains is both required hygiene and free
complaint-rate reduction.

## Blocklists: check, then delist — do not domain-hop

Check directly with the operators (aggregate checkers are fine for
screening, but confirm at the source before acting). The lists that
actually move delivery:

- **Spamhaus** — the one major providers and most corporate filters
  actually consult. Its lookup center tells you which specific list you are
  on, and the type dictates the exit:
  - *SBL* (manual listings for spam sources): fix the cause, then follow
    the listing's removal process — often via your host or network owner.
  - *CSS* (automated, targets snowshoe patterns — low volume spread across
    many IPs/domains): expires on its own once the behavior stops; repeat
    listings mean the sending pattern itself is the problem.
  - *XBL* (compromised machines): find and clean the infected host or
    leaking credential, then request removal.
  - *PBL* (policy: dynamic/residential space that should not emit SMTP):
    not an accusation — either send through a proper relay or, if you
    legitimately operate a server there, self-remove.
  - *DBL* (domains, not IPs): clean up the cause, then request delisting.
- **SpamCop** — automated and time-based: IPs delist themselves 24–48
  hours after reports stop. There is no form and no expedite; the only
  lever is stopping the mail that draws reports.
- **Barracuda** — request removal through its reputation-system form;
  typically processed in hours to days.
- URI lists (targeting the *domains in your links* rather than your IP)
  can junk mail even when your IP is clean — another reason link domains
  and tracking domains must be yours and well-kept.

Universals: delisting is **free** everywhere that matters — anyone charging
a "delisting fee" is a scammer, and paying does nothing. And every operator
verifies the cause is fixed; requesting removal while the behavior continues
burns credibility and slows the next request.

A correction to advice found in outreach playbooks, which hold that one or
two listings are tolerable and that a widely listed domain is "cheaper to
replace than to delist": for a legitimate sender this is wrong on both
halves. Delisting is free, procedural, and usually fast once the cause is
fixed — while replacing the domain resets you to zero reputation, forfeits
the diagnosis (whatever caused the listings comes along to the new domain),
and lands you in the snowshoe pattern that CSS and the domain lists are
explicitly built to catch. Repeated listings are a message about the mail,
not the domain.

## Bounce classification and handling

Keep total bounces under **2%**; sustained higher rates are the classic
signature of a guessed or decayed list and damage reputation faster than
almost anything else. Rules:

- **Hard bounces** (permanent: no such user, no such domain, 5.1.x codes):
  suppress immediately and permanently. One send's grace, zero retries.
- **Soft bounces** (temporary: mailbox full, server busy, 4xx codes):
  retry within the send window; suppress after 3–5 consecutive soft
  bounces across campaigns.
- **Block/policy bounces** (5.7.x codes, texts naming a blocklist,
  "reputation", "authentication required", "access denied"): these are not
  address problems and must not be handled as address suppressions. Each
  is a deliverability incident: read the text, extract the named cause,
  and route to the relevant section above. The provider-specific
  enforcement codes (Gmail's 5.7.26 family, Microsoft's 5.7.15) are
  decoded in [bulk-sender-rules.md](bulk-sender-rules.md).

Pre-send address verification (does the mailbox exist and accept mail) is
worth running on any list segment older than a few months and on every
import — it converts would-be hard bounces into silent skips. Ongoing
hygiene policy lives in the `email-lifecycle` skill. If the sending stack
is Mailneo, the `mailneo` skill covers pulling bounce and complaint data
per campaign through the API, which turns most of this file's questions
into queries.
