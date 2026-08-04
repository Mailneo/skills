# Cadence, benchmarks, and testing

## Cadence

### What the evidence actually says

- **Frequency lifts totals and taxes the list at the same time.** More
  sends per week means more total clicks and revenue in the short run,
  while per-send engagement falls and unsubscribes rise. The curve
  bends, it doesn't cliff: research on consumer programs puts the
  fatigue zone around 4–5+ emails per week from one sender, but the
  honest reading is that the right frequency is where *your* complaint
  and unsubscribe trends stay flat while revenue per subscriber still
  grows — a number you find by ramping, not by lookup.
- **Consistency beats volume.** A cadence held steady for a year builds
  an expectation in both the reader and the mailbox provider's
  reputation model. The two classic self-inflicted wounds are the
  sudden burst (quiet list, then daily promotions in a peak season —
  complaint spike, reputation damage) and the long silence (nothing for
  six months, then a blast to a decayed list — bounce spike, spam-folder
  placement). If you can only sustain monthly, send monthly forever
  rather than weekly in bursts.
- **Say the cadence at signup and keep the promise.** Deviations are
  what people punish, not the number itself. Daily can work — for a
  list that signed up for daily.
- **Returning from a gap:** re-ramp. After 3+ silent months, verify the
  list, mail the most recently engaged slice first, and widen over a
  few sends — do not blast the full file on day one
  (see [list-hygiene.md](list-hygiene.md) on decay).
- **Cap the total, not just the broadcasts.** Journeys plus broadcasts
  is what the subscriber experiences. A global cap (e.g. 4 marketing
  emails per person per week, journeys prioritized over broadcasts)
  prevents the week where a welcome, a win-back, and two promotions all
  land on the same person.
- **Let people opt down.** A frequency choice in the preference center
  retains a real share of would-be unsubscribers
  (see [segmentation.md](segmentation.md)).

### Send times and timezones: the honest version

Send-time effects are real and modest. Across published tests, the gap
between a good and bad send time is typically 5–15% on opens and less on
clicks — worth taking, dwarfed by list quality, subject, and offer. Do
not spend optimization budget here before the big levers are pulled.

What is worth doing: send during the recipient's waking hours;
mid-week/mid-morning is a fine default that countless tests fail to beat
by much; hold day-and-time steady so regulars know when to expect you;
if your list spans continents, localize by timezone so nobody gets the
3 a.m. delivery. Per-recipient "optimal send time" features produce
single-digit lifts at best — fine to enable, wrong to celebrate.
Triggered journeys ignore all of this by design: the trigger *is* the
timing, and a cart reminder at 11 p.m. Sunday outperforms a perfectly
scheduled Tuesday broadcast.

## Benchmarks (use with both hands on the caveats)

**Caveat 1 — opens are inflated.** Apple's Mail Privacy Protection
pre-fetches tracking pixels, firing "opens" no human performed. On lists
with a large Apple-mail share, reported open rates run 15–35 percentage
points above true reading, and roughly half of recorded opens can be
machine events. Post-2021 numbers are not comparable to older ones.
**Caveat 2 — benchmark tables disagree** with each other by wide margins
(methodology, vertical mix, what counts as a send). Use ranges to sanity
check, and your own trend line to manage.

Rough ranges for permission-based B2C/B2B marketing email, mid-2020s:

| Metric | Typical range | Notes |
|---|---|---|
| Open rate (reported) | 25–45% | Inflated by machine opens; nonprofits/government/hobby niches at the top, retail/e-commerce lower |
| Click-through rate (of delivered) | 1–3% | Highly offer-dependent; 2%+ is healthy for most verticals |
| Click-to-open (CTOR) | 5–15% | The better content-quality signal, though its denominator is inflated too |
| Unsubscribe rate | 0.1–0.5% per send | Under ~0.3% healthy; a spike flags a content or frequency mistake |
| Spam complaint rate | < 0.1% target | 0.3% is the mailbox-provider enforcement cliff, not a "range" |
| Bounce rate | < 2% | Above that, the audience selection included stale addresses |
| Automated journeys | ~2–4x broadcast CTR | Welcome and abandonment flows sit at the top |

Directional patterns that survive the noise: relevance niches (hobby,
government, nonprofit) out-engage commodity retail; automated beats
broadcast everywhere; smaller, well-pruned lists out-rate big unpruned
ones. If your program tracks revenue, steer by revenue per subscriber
per month and treat the table above as smoke detection only.

## A/B testing that is actually valid

### The method

1. **One variable per test.** Subject A vs subject B — same content,
   same audience, same time. Change two things and a win teaches you
   nothing repeatable.
2. **Randomize the split** (any decent platform does) and size arms
   equally.
3. **Pick the metric before sending**, and prefer the deepest one your
   volume can support: conversions > clicks > opens. Post-MPP, opens
   remain usable for *relative* subject-line tests — machine opens
   inflate both arms roughly equally — but never for absolute claims.
4. **Decide at a threshold, not by eyeball.** 95% confidence is the
   convention; run the numbers through any standard two-proportion
   calculator rather than trusting "B looks higher."
5. **Let the test finish.** Engagement arrives over 24–72 hours;
   calling a winner at hour one favors whichever arm early-openers
   liked, and peeking repeatedly until significance appears
   manufactures false wins.
6. **Re-run winners.** A single significant result at 95% still has a
   1-in-20 false-positive floor — and you are running many tests. A
   finding you would bet the program on should replicate once.

### Sample-size intuition

The math is unforgiving on low-base-rate metrics. Approximate
per-arm sizes for a standard test (95% confidence, 80% power):

| You want to detect | Needed per arm | Total list (50/50 test) |
|---|---|---|
| Opens 30% → 36% (big subject-line swing) | ~1,000 | ~2,000 |
| Opens 30% → 33% (typical subject-line win) | ~4,000 | ~8,000 |
| Clicks 3% → 4.5% (huge content change) | ~2,600 | ~5,200 |
| Clicks 3% → 3.6% (typical content win) | ~14,000 | ~28,000 |
| Clicks 2% → 2.4% | ~21,000 | ~42,000 |

The lesson in that table: a 10,000-subscriber list can genuinely test
subject lines, can detect only dramatic click differences, and cannot
resolve button-color-sized effects at all — the winner it declares on
those is coin-flip noise wearing a lab coat.

### When the list is too small for significance

Below roughly 5,000–10,000 recipients per send, formal per-send testing
mostly stops working. Do this instead:

- **Test only big swings.** Question vs statement subject, long vs
  short email, discount vs no discount. Small lists can still see
  large effects.
- **Accumulate across sends.** Commit to one hypothesis ("curiosity
  subjects beat descriptive ones *for this list*") and run it as the
  A/B split across 4–6 consecutive campaigns, then judge the pooled
  results. Slower, but real.
- **Make directional bets and move on.** When evidence can't be bought
  at your scale, adopt the practice with the strongest external
  evidence (clear expectations, pruned list, triggered journeys),
  watch your trend lines, and don't pretend a 400-person split told
  you something. An honest "we chose this on judgment" beats a fake
  "the data said."
- **Borrow power from the base rate.** Whatever you test, test it on
  the highest-base-rate metric the hypothesis allows — subject-line
  hypotheses on opens, not clicks.
- **Never conclude from one send.** Small-list results swing wildly
  send to send; a repeated pattern is the smallest believable unit.

### Holdouts for automation changes

Journeys are always-on, so "before vs after" comparisons are polluted by
seasonality and list drift. When changing a welcome series, win-back, or
abandonment flow:

- Keep 10–20% of newly triggered entrants on the **old** version for
  2–4 weeks (longer for slow-converting journeys) and compare cohorts
  that entered in the same window.
- For "should this journey exist at all," hold out a slice that
  receives *nothing* and measure the true incremental effect —
  abandonment flows especially flatter themselves by claiming
  purchases that would have happened anyway.
- Judge journeys on their end goal (activation, second purchase,
  reactivation), not per-email opens; an extra email can raise total
  clicks while lowering completion.

Holdout mechanics are a segmentation exercise — a random-percentage
split held stable for the test window — executable through **mailneo**
segments. And before crediting any test win, rule out the boring
explanation first: a delivery difference between arms (one variant
spam-foldered) mimics a copy effect; **email-deliverability** covers
the checks.
