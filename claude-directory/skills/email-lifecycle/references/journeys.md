# Automated journeys

## Trigger thinking vs schedule thinking

A broadcast goes out on *your* clock; a journey fires on *the
recipient's* clock — the moment they subscribe, buy, abandon, or go
quiet. That timing difference is why triggered email consistently posts
engagement several multiples above batch sends (platform aggregates
commonly report ~3x the click rate and far higher conversion): the
message arrives while the recipient's attention is already on you.

Practical consequence: **build the journeys before optimizing the
newsletter.** A program's first four automations, in order of leverage —
welcome, post-purchase (or post-activation), abandonment, win-back.
Everything below assumes the copy itself comes from
**email-copywriting** and execution from **mailneo**; this file is the
structure, timing, and exit logic.

Journey hygiene rules that apply to all of them:

- **Every journey has exit criteria.** Purchase exits the abandonment
  flow; a click exits win-back; an unsubscribe exits everything,
  instantly, mid-sequence.
- **Cap concurrency.** A person in two journeys plus the weekly
  broadcast is getting too much mail. Common policy: welcome takes
  priority and suppresses broadcasts for its duration (or at least its
  first week); at most one other journey active per person; a global
  frequency cap of N messages per week that journeys and broadcasts
  share.
- **Hold out when you change one.** Journeys run unattended for months;
  changes need holdout comparison, not vibes — see
  [cadence-and-testing.md](cadence-and-testing.md).

## Welcome series

Engagement peaks in the first days after signup and never returns to
that level. An empty welcome slot wastes the best attention you will
ever get from these people.

Structure — 4 emails over ~12 days is the workhorse shape:

| # | When | Job |
|---|---|---|
| 0 | Instantly | Deliver exactly what the form promised (the download, the confirmation, the first issue). Set expectations: what they'll get, how often, from what address. One sentence inviting a reply — replies are gold for mailbox-provider reputation. |
| 1 | Day 2–3 | Orientation: the why behind the thing they joined, and the single best piece of value you have. Not your history — their payoff. |
| 2 | Day 5–7 | Proof and depth: your most-loved content, a customer story, the feature that retains people. |
| 3 | Day 10–14 | The ask: the conversion step appropriate to your model (first purchase with a modest incentive, trial activation, topic/frequency preferences — a one-question "what are you here for?" doubles as segmentation input). |

Worked example — a meal-kit service: email 0 delivers the promised
"10 dinners in 20 minutes" recipe pack and says "we email menus on
Tuesdays"; day 3 explains how box skipping works (the #1 anxiety at
signup, learned from support tickets); day 6 shows three real weeknight
photos from customers plus the dietary-filter feature; day 12 offers
first-box pricing with a real expiry. Each email one job, every timing
gap 2–4 days, no daily bombardment.

Tuning notes:

- The instant email matters most; latency between signup and email 0
  should be seconds, not hours.
- If the sequence sells, sell late; if it teaches, teach from email 0.
- New subscribers in the welcome window are exempt from sunset math and
  usually from broadcasts (avoid the day-one triple-send).

## Nurture / drip sequences

For considered decisions (B2B software, courses, high-ticket goods)
where the gap between "interested" and "ready" is weeks or months.

Design rules:

- **One idea per email.** A sequence is a curriculum, not a brochure;
  each message teaches one thing and earns the next open.
- **Sequence beats blast, but goals beat sequence.** Define the exit
  event (booked a demo, started a trial, bought) and remove people the
  moment they hit it — nothing reads more robotic than "just checking
  if you saw my last email about the thing you already bought."
- **Cadence loosens over time.** Every 3–4 days early, weekly after
  the first two weeks, then hand off to the regular newsletter rather
  than dripping forever. A drip that never ends is just a badly
  disguised broadcast list.
- Branch on behavior sparingly: one branch on the key signal (clicked
  pricing vs didn't) is manageable; five-way branching trees rot
  because nobody can QA them. Complexity is a maintenance debt exactly
  like over-segmentation.

Example — a 6-touch trial nurture for a scheduling tool: day 0 setup
(one action: connect your calendar), day 2 the aha feature, day 5 a
customer workflow story, day 9 objection handling (security/permissions
page), day 12 trial-ending heads-up with plan comparison, day 14 last
day + direct reply invitation. Users who convert exit instantly; users
who connected nothing by day 5 get the branch asking what blocked them.

## Re-engagement / win-back

When: trigger from your engagement tiers, scaled to cadence — daily
senders after ~30–45 quiet days, weekly after ~90–150, monthly after
6–9 months. For *customer* win-back (bought before, stopped), trigger
at 1.5–2x the natural repurchase interval instead.

Shape — three emails is the sweet spot; more just delays the goodbye:

1. **Value reminder** — your best recent material or what's changed
   since they drifted. No guilt ("we miss you" performs worse than
   simply being interesting again).
2. **Different angle or offer** — opt-down to a digest, a preference
   ask, or (commerce) a real incentive. Save the discount for this
   step, not the first.
3. **The goodbye** — honest statement that mailing stops, one click to
   stay. This email reliably outperforms the first two; the deadline is
   the content.

When to let go: no engagement across the sequence → suppress, per the
sunset policy in [list-hygiene.md](list-hygiene.md). Set expectations
honestly: single-digit to ~20% reactivation of a dormant pool is a
*good* outcome, and the campaign is still worth running at 5%, because
its other product is a cleaner list. Do not run win-back on addresses
that also fail verification — dead mailboxes cannot be won back, only
bounced.

## Post-purchase / post-activation

The most under-built journey, and the cheapest revenue in email —
retention costs a fraction of acquisition.

- **Order confirmation is transactional** — instant, factual, and
  boring on purpose. Keep marketing out of it (both for law — see
  **email-compliance** — and because its 70–90% open rate depends on it
  being trusted).
- **Day 2–5: the success check-in.** Getting-started help, care
  instructions, setup guide — the email that reduces returns and
  support tickets.
- **Day 10–21: the review/feedback ask,** timed after the product has
  actually been used (ask after delivery plus realistic first-use time,
  not after payment).
- **Later: replenishment or cross-sell** on the product's natural
  cycle — a coffee roaster nudging at day 25 of a 30-day bag, not day
  3. First-time buyers get a "second purchase" incentive far more
  productively than established customers do (see
  [segmentation.md](segmentation.md) on lifecycle stage).

## Cart / checkout abandonment (basics)

The essentials — this is a deep e-commerce specialty, but the basic
recipe captures most of the value:

1. **1–4 hours after abandonment:** plain reminder with the cart
   contents and a one-click path back. No discount. Many abandoners
   were interrupted, not dissuaded; recover them at full price.
2. **~24 hours:** handle the common objections — shipping cost/time,
   returns policy, a short bit of social proof.
3. **~48–72 hours:** the incentive, if you use one at all, with a real
   expiry. Every incentive here trains repeat abandoners; consider
   limiting discounts to first-time buyers or high-value carts.

Exit on purchase, obviously — and cap how often one person can enter
the flow (once per 30–60 days), or serial browsers get nagged weekly.
Well-run three-email sequences recover a mid-single-digit to ~15% slice
of abandoned checkouts; claims much above that usually measure clicks,
not completed orders.

One consent caveat: abandonment email requires that you *have* the
address with marketing (or at least legitimate-interest) permission —
identified logged-in customers, or a checkout email field with proper
notice. Emailing an address someone typed but never submitted consent
for is surveillance, not marketing; **email-compliance** covers where
the line sits per regime.
