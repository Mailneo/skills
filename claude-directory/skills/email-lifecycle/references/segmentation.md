# Segmenting an owned list

One test before creating any segment: **what will this segment receive
that the rest of the list will not?** Different content, different
frequency, different offers, or exclusion from a send are all valid
answers. "It would be interesting to know" is not — that is a report, not
a segment. Segmentation earns its complexity only when it changes what
you send.

## Engagement tiers (start here)

The first segmentation every program needs, because it drives hygiene,
cadence, and deliverability all at once. Define engagement on real
signals — clicks, site visits, purchases, replies — not opens alone,
since Apple's Mail Privacy Protection auto-fires opens for a large share
of recipients.

A four-tier recipe for a weekly sender (scale windows with your cadence,
as in [list-hygiene.md](list-hygiene.md)):

| Tier | Definition | Treatment |
|---|---|---|
| Active | Engaged within 90 days | Full cadence, all campaign types, first to get new offers |
| Cooling | Engaged 90–180 days ago | Reduced frequency, best content only, no marginal sends |
| Dormant | Nothing in 180+ days | Re-permission sequence only; excluded from broadcasts |
| New | Subscribed < 60 days, still in grace period | Welcome journey; count nothing against them yet |

Two operational notes:

- When testing risky content or raising frequency, do it on Active
  first. When mailbox-provider reputation is shaky, mail *only* Active
  until it recovers — concentrating volume on people who engage is the
  standard recovery move (see **email-deliverability**).
- Recompute tiers on a schedule (weekly is fine), not at send time by
  hand. In **mailneo**, these are saved segments over engagement
  filters; the send preview shows the resulting audience size before
  anything is armed.

## Lifecycle stage

Where the person is in their relationship with you, independent of how
much they click:

- **Subscriber** — opted in, never bought/activated.
- **Activated** — did the first meaningful thing (first purchase, first
  project created, first booking).
- **Established** — repeat behavior; the relationship is real.
- **Lapsed** — was established, has stopped (define by your natural
  repurchase or usage interval, not a universal number).

The reason to encode this: the same broadcast is often wrong for half of
it. A discount on a first order should exclude Established (it trains
your best customers to wait for coupons); a power-user feature deep-dive
is noise to Subscribers. Most journeys in
[journeys.md](journeys.md) are really lifecycle-transition machines —
welcome moves Subscriber → Activated, win-back targets Lapsed.

## Behavioral segments

Built from what people do, and only worth building where behavior
predicts interest:

- **Topic affinity from clicks.** Tag links by topic; two or three
  clicks on a topic is a working signal. A cycling-gear retailer that
  tags clicks as road/mountain/commuting can stop sending mountain-bike
  clearances to people who have only ever clicked commuting content —
  that single change typically moves unsubscribe rates more than any
  subject-line work.
- **Site/product behavior.** Viewed a pricing page, used a feature,
  abandoned a cart — these usually deserve a *triggered journey* rather
  than a standing segment; see [journeys.md](journeys.md).
- **Stated preference.** What they chose in the preference center
  (below) outranks inferred signals when the two conflict.

## RFM, adapted to email

Classic RFM scores customers on Recency, Frequency, Monetary value. For
email programs, adapt the axes to what you can observe:

- **R** — days since last meaningful engagement (click, purchase,
  visit).
- **F** — engagement events in the last 90–180 days.
- **M** — monetary value where you have commerce data; for content
  programs substitute depth (replies, referrals, time-on-page, paid
  tier) or drop the axis and run RF only.

Score each axis 1–5 by quintile within your own list (never against
external benchmarks), and act on a handful of named cells rather than
all 125 combinations:

| Cell | Shape | Action |
|---|---|---|
| Champions | High R, F, M | Protect: early access, asks for feedback/referrals, *fewer* promotions |
| Loyal-but-quiet | High F/M, slipping R | Priority win-back — highest-value recoverable group on the list |
| Promising | High R, low F/M | Nurture toward the second action; this is where onboarding pays off |
| Drifting | Low R and F | Fold into the Cooling/Dormant hygiene track |

One honest caveat: recency dominates. If you only have capacity to act
on one axis, act on R — it is the strongest single predictor of future
engagement, and it is what your sunset policy already uses.

## Preference centers

A preference center is segmentation the subscriber does for you, and the
best unsubscribe-prevention surface you have.

- Offer few, real choices: topics you actually publish separately,
  frequency (weekly / monthly digest / major-announcements-only), and a
  snooze ("pause for 30/90 days"). Every option must map to a send
  decision you really make — a topic checkbox nobody honors is a lie.
- No login required; reach it from a link in every footer, next to the
  unsubscribe link. The placement is the point: it offers an
  alternative at the exact moment someone considers leaving. Programs
  that add an opt-down path typically convert a meaningful share of
  would-be unsubscribes into reduced-frequency subscribers.
- Honor changes immediately, and treat stated preferences as consent
  records (see **email-compliance**).
- The one-click unsubscribe required by mailbox providers must still
  unsubscribe in one click — a preference center may be offered *after*
  or *alongside*, never as an obstacle in front of opting out.

## Over-segmentation: the failure mode

More programs are hurt by too many segments than too few. Warning signs
and rules of thumb:

- **Segments too small to learn from.** Below a few hundred recipients
  you cannot read campaign metrics on a segment, and below ~1,000 per
  arm you cannot test anything (see
  [cadence-and-testing.md](cadence-and-testing.md)). If a segment is
  that small, it should exist only if the *action* is obvious without
  measurement.
- **Content debt.** Five segments receiving genuinely different
  versions means five versions to write, render, and QA, every send,
  forever. Segment count is a standing tax on every future campaign;
  pay it only where the engagement difference covers it.
- **Orphan segments.** Definitions that made sense once and now silently
  select the wrong people. Audit quarterly: every saved segment either
  received differentiated treatment in the last quarter or gets
  deleted.
- **The right ramp:** start with engagement tiers (4), add lifecycle
  stage when you have a conversion event worth acting on, add topic
  affinity when you demonstrably publish distinct topics. Most programs
  under 50,000 subscribers never need more than 6–8 live segments.

Micro-personalization (dynamic fields, per-user recommendations) is a
different tool than segmentation and often a better answer than another
segment: one campaign, variable content, no new standing structure.
