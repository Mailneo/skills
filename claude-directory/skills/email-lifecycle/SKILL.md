---
name: email-lifecycle
description: "Use when planning or improving list growth, list hygiene, segmentation, automated journeys (welcome, nurture, win-back), sending cadence, or A/B testing strategy for permission-based email. Do NOT use for writing the copy itself (email-copywriting) or inbox-placement mechanics (email-deliverability)."
---

# Email lifecycle strategy

This skill is about running a permission-based email program over time: who
gets on the list, what happens to them while they are on it, and how they
leave. It assumes every address gave you consent. If the question is about
mailing people who did not ask to hear from you, stop — that is a different
legal and ethical regime (see **email-compliance**), and none of the advice
here transfers.

## The lifecycle model

Every subscriber moves through five stages. Most program problems are one
stage being skipped or starved.

1. **Acquire** — someone trades their address for something specific.
   The quality of that trade (clear expectation, real value, provable
   consent) determines everything downstream.
2. **Onboard** — the first two weeks. Engagement will never be higher
   than it is right now; a welcome journey that delivers the promised
   value and sets expectations is the single highest-leverage automation.
3. **Engage** — the long middle. Regular sends, behavioral triggers,
   segmentation that changes what people receive rather than just
   labeling them.
4. **Sustain** — interest fades in everyone eventually. Watch for
   cooling engagement, reduce frequency for the fading, run
   re-engagement before people go fully dark.
5. **Sunset** — stop mailing people who stopped reading. Run one
   re-permission attempt, then suppress. Lists decay at roughly 20–25%
   a year whatever you do; pruning is maintenance, not failure.

A program with no onboarding wastes its best engagement window. A program
with no sunset slowly poisons its own deliverability. A program that only
broadcasts and never triggers leaves its highest-converting moments
(signup, first purchase, abandonment, going quiet) unanswered.

## The rules that matter most

- **Permission is the product.** An address acquired without a clear,
  provable opt-in is a liability, not an asset. Never import purchased,
  scraped, rented, or "partner-shared" lists — they carry spam traps,
  complaint rates that breach mailbox-provider ceilings, and legal
  exposure, and they underperform opt-in lists by an order of magnitude.
- **Prune ruthlessly.** Mailbox providers judge you by the engagement of
  the people you mail, not the size of your list. 10,000 readers beat
  100,000 ignorers on every metric that matters, including revenue.
  Sunset policies are described with thresholds in
  [references/list-hygiene.md](references/list-hygiene.md).
- **Automate the moments that matter.** Triggered messages (welcome,
  post-purchase, abandonment, win-back) consistently earn several times
  the engagement of batch broadcasts because they arrive when the
  recipient is already paying attention. Build the journeys before you
  optimize the newsletter.
- **Consistency over volume.** A cadence you can sustain forever beats a
  burst you can't. Sudden frequency spikes drive unsubscribes and spam
  complaints; long silences make your next send look like a stranger's.
- **Steer by clicks and conversions, not opens.** Apple's Mail Privacy
  Protection pre-fetches images, so a large share of recorded "opens"
  are machines. Opens still work for relative comparisons (both arms of
  a subject test are inflated equally); they no longer work as an
  absolute engagement measure or as the sole input to a sunset policy.
- **Segment to change behavior, not to admire dashboards.** A segment
  only earns its keep if it receives different content, different
  frequency, or different offers. Three segments you act on beat thirty
  you report on.

## Triage — where to go

| You are asked about... | Go to |
|---|---|
| Signup forms, lead magnets, opt-in method, imports, purchased lists | [references/list-hygiene.md](references/list-hygiene.md) |
| Bounces, complaints, suppression lists, sunset policies, re-permission | [references/list-hygiene.md](references/list-hygiene.md) |
| Engagement tiers, RFM, lifecycle stages, preference centers | [references/segmentation.md](references/segmentation.md) |
| Welcome series, nurture/drip, win-back, post-purchase, cart abandonment | [references/journeys.md](references/journeys.md) |
| How often to send, send times, frequency caps | [references/cadence-and-testing.md](references/cadence-and-testing.md) |
| A/B tests, sample sizes, small-list strategy, holdouts, benchmarks | [references/cadence-and-testing.md](references/cadence-and-testing.md) |

## Sane defaults for a new program

When someone has no policy at all, start here and tune later:

- Double opt-in if operating in or into the EU (mandatory-in-practice in
  Germany/Austria); single opt-in with aggressive hygiene is defensible
  for low-risk US consumer lists.
- Welcome journey: instant delivery of the promised thing, then 3–4
  emails over 10–14 days.
- One broadcast cadence you can keep forever (weekly is the common
  default), announced at signup.
- Suppress hard bounces immediately, soft-bouncing addresses after 3–5
  consecutive failures, complainers instantly and permanently.
- Sunset: no click or other first-party activity in ~180 days (weekly
  cadence) → 3-email re-permission over two weeks → suppress
  non-responders.
- Hold out 10% when changing any journey, for at least two weeks.

## Related skills

- **mailneo** — executing all of this through the API: creating segments,
  managing suppressions, building and arming sends. This skill decides
  what is worth doing; that one does it.
- **email-copywriting** — the actual words for each journey and broadcast.
- **email-deliverability** — authentication, sender reputation, inbox
  placement. Hygiene decisions here directly move reputation there.
- **email-compliance** — consent records, lawful basis, unsubscribe and
  erasure obligations. Consult it before any import or re-permission
  campaign touching EU, UK, or Canadian recipients.
