# Warmup and volume: building a reputation without faking one

Filters score senders on accumulated history. New infrastructure has none,
so it starts at maximum suspicion — the burden of proof is on you, and the
only currency accepted is real recipients engaging with real mail over time.
Everything in this file is a variation on that theme; everything this file
warns against is an attempt to counterfeit it.

## Domain reputation vs IP reputation

Two ledgers, often conflated:

- **Domain reputation** attaches to the domains in your mail: the From
  domain, the DKIM `d=` domain, link domains. It follows you across
  providers and IPs. This is the ledger you own forever.
- **IP reputation** attaches to the sending address. On a shared pool your
  platform manages it (and every pool tenant affects it); on a dedicated IP
  it is entirely yours to build and to ruin.

"Warming" means building each ledger gradually. Moving to a new platform
warms a new IP story but carries your domain history with it — good or bad.
Swapping domains resets the domain ledger to zero, which is worse than
almost any recoverable negative history (and see the anti-pattern section
before considering it).

## Shared vs dedicated IP

| | Shared pool | Dedicated IP |
|---|---|---|
| Reputation | Inherited from the pool — the platform's vetting does the early work | Entirely yours; starts cold |
| Volume floor | None | Needs steady volume to sustain a readable signal — common platform guidance clusters around 100k–300k+ messages/month; below roughly 50k/month the signal is too thin to hold a stable reputation |
| Spikes | Absorbed by pool volume | Conspicuous against your own baseline |
| Bad neighbors | Possible on loosely policed pools | Impossible — you are your only neighbor |
| Warmup | Not needed for the IP (domain still warms) | 4–6 weeks of ramping before full volume |

Default advice: stay on a reputable shared pool until volume is consistently
in six figures per month **and** you have the monitoring discipline to
notice problems within a day. A dedicated IP is control, and control of a
reputation is only an asset if you actively manage it. High-volume senders
often run two dedicated IPs (or IP + shared) to separate transactional from
marketing traffic so a marketing mistake cannot junk password resets.

## IP warming: the ramp

For a new dedicated IP (numbers are a template, not a law — the metrics
gate the schedule, not the calendar):

1. Start with a few hundred messages/day to your **most engaged** recipients
   — people who opened or clicked in the last 30 days. Early engagement is
   the deposit that opens the account.
2. Roughly **double volume every 2–3 days**, per provider, while complaint,
   bounce, and deferral metrics stay clean.
3. Watch for **4xx deferrals** ("try again later", rate-limit codes). That
   is the provider explicitly telling you to slow down. Honor it: hold or
   halve volume for a couple of days, then resume. Pushing through
   deferrals converts them into rejections.
4. Expect different pacing per provider — Microsoft is notoriously slower
   to extend trust than Gmail — so track the ramp per destination, not in
   aggregate.
5. Full volume typically lands **4–6 weeks** out for six-figure monthly
   senders; longer for larger.

## Domain warmup, done organically

A fresh domain (or a long-dormant one) needs the same patience even on a
shared IP pool:

- **Wait before bulk.** Give a new domain 2–4 weeks of light, legitimate
  use before meaningful campaign volume. Registrar-fresh domains sending
  volume on day one is a spam signature so classic that filters treat
  domain age itself as a factor.
- **Real correspondence first.** Human one-to-one mail — onboarding
  conversations, support replies, genuine business correspondence — from
  the accounts that will later send campaigns.
- **Engaged-first ordering.** When campaign sending starts, send to the
  segment most likely to open and reply, and expand outward. Never point a
  new domain at the coldest part of a list.
- **Transactional before promotional.** Receipts and notifications earn
  opens at near-100% rates; they are the ideal first impression.
- **Ramp, then hold.** Increase volume stepwise and hold each step a few
  days. The goal is a boring, predictable graph.

## The warmup-network trap

A category of tooling automates "warmup" by enrolling your mailbox in a pool
of other enrolled mailboxes that email each other, auto-open, reply with
canned positive text, mark messages important, and drag them out of the spam
folder — manufacturing every engagement signal providers use to identify a
trusted human sender.

Popular outreach playbooks treat these networks as mandatory infrastructure,
run permanently alongside campaigns at something like a 1:1 ratio with real
mail. **This skill's position is the opposite: do not use them.** The
reasons are practical, not just principled:

- **They violate provider terms.** Google in particular treats automated
  fake engagement as abuse: it forced a prominent warmup network built on
  the Gmail API to shut down in early 2023, and in 2024 moved to bar
  third-party automated warmup from the API generally. Surviving tools
  reconnected over IMAP/SMTP — which changes the plumbing, not the policy.
- **They are detectable.** Warmup pools form closed traffic graphs: the
  same rotating set of accounts endlessly mailing each other with
  templated sentiment, unnatural open timing, and spam-folder rescues at
  scale. Providers process billions of messages a day and classify traffic
  patterns for a living; a bot clique is not a subtle pattern.
- **The signal is poisoned at the source.** Engagement metrics exist to
  measure whether recipients want your mail. Faking them is the same act
  as buying fake product reviews, and when detected it reclassifies the
  account from "unknown" to "actively deceptive" — a far worse starting
  position than cold.

Everything a warmup network fakes, the organic process above produces
honestly. It is slower. That is the point: the delay *is* the vetting.

## The multi-inbox cold-outreach architecture — described honestly

Cold-outreach practice distributes sending across many small accounts:
secondary sending domains (301-redirected to the main site), a few
mailboxes per domain, low per-mailbox daily volume, spares standing by.
Circulating heuristics put the ceiling around a few dozen messages per
mailbox per day — figures like ~50/day including all traffic, 3–5 mailboxes
per domain — and derive capacity math from them (e.g., 1,000 sends/day ≈ 20
mailboxes across 4–7 domains).

Treat those numbers as **practitioner folklore**: no provider publishes a
per-mailbox cold-mail ceiling, the real constraint is behavioral scoring,
and published limits (like workspace suites' recipients-per-day caps) sit
far above them. The architecture's honest rationale is blast-radius
isolation — a reputation problem on one domain does not take down the
primary domain or other lanes.

The caveats are not optional:

- The pattern exists because unsolicited mail at volume accumulates
  complaints. Whether you may send unsolicited mail *at all*, and with what
  disclosures, is jurisdiction-dependent — see the `email-compliance` skill
  before scaling any cold program.
- Secondary domains must be transparently yours (redirecting to your real
  site, truthful WHOIS/registrant organization) — not lookalikes of anyone
  else, and not disguises.
- **Never treat domains as consumables.** Buying batches of domains,
  burning their reputations, and rotating in replacements is reputation
  laundering. Beyond the ethics, it fails on its own terms: blocklist
  operators specifically track fresh lookalike registrations, and the
  low-volume-across-many-domains shape has a name in the filtering world —
  *snowshoe spam* — with a dedicated blocklist category hunting it (see
  [troubleshooting.md](troubleshooting.md)). If domains keep dying, the
  mail is the problem, and the fix is targeting and consent, not inventory.

## Volume consistency for bulk senders

Filters model your baseline. Deviations are scored, in both directions:

- **Spikes**: keep day-over-day growth inside roughly 2–3× baseline. Before
  a seasonal peak, ramp up across the preceding weeks so the peak is a hill,
  not a cliff.
- **Silence**: reputation decays with inactivity. A domain quiet for months
  then blasting its full list looks compromised. Coming back from a pause,
  re-ramp like a mini-warmup, engaged segment first.
- **Cadence**: steady daily/weekly sending at moderate volume beats
  monthly mega-blasts of the same total, because it gives providers a
  continuous, current signal.

## Recovery ramp after an incident

After a complaint spike, blocklisting, or bulking event — once the root
cause is actually fixed:

1. Cut volume hard: mail only the most engaged 10–20% of the list
   (openers/clickers in the last 30 days).
2. Hold there until complaint rate, deferrals, and placement recover —
   typically one to two weeks.
3. Re-expand stepwise, as if warming a new IP, watching the same gates.

Diagnosis of what went wrong belongs in
[troubleshooting.md](troubleshooting.md); the enforced thresholds you are
recovering toward are in [bulk-sender-rules.md](bulk-sender-rules.md).
List-hygiene measures that keep you out of this section — sunset policies,
re-permission, verification of aged addresses — are the `email-lifecycle`
skill's territory.
