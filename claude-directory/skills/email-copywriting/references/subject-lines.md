# Subject Lines and Preview Text

The subject line has exactly one job: earn an open from the right reader,
honestly. It cannot sell, explain, or close. Write it after the body, because
only a finished body tells you what promise the subject can cash.

## Principles

### Curiosity gap, not bait-and-switch

The strongest open-driver is incomplete information the body resolves:
"The pricing change that backfired" works because the reader must open to
learn which change and why. The line between curiosity and clickbait is
whether the body pays the promise in full, early. If a reader could finish
your email and feel tricked, the subject fails — and under engagement-based
filtering, tricked readers become deletes-without-reading and spam
complaints that degrade placement of everything you send later. See the
email-deliverability skill for how those signals compound.

### Specificity

Vague subjects read as bulk mail because they could have been sent to
anyone. "Your wholesale page's 3-week lead time" could only have been sent
to one company; "Improve your operations" could have been sent to a million.
Numbers, named nouns, and concrete outcomes signal that a person looked at
something before writing.

### Length: write for the truncation point

Mobile clients show roughly 33–41 characters of a subject before cutting it
off; desktop clients show up to about 70. Since most opens happen on
phones, treat ~40 characters as your working budget and put the
load-bearing words first. Short subjects are not a style preference — they
are a rendering constraint. Two-to-four-word subjects often outperform
longer ones precisely because nothing gets truncated and they read like a
note from a person, not a campaign.

### Personalization

Adding the recipient's name or company to a subject reliably lifts opens —
but bare `{{first_name}}` insertion is worn, and readers recognize it.
Personalization works best when it proves specificity: "Priya — question
about Fernwood's wholesale program" beats "Priya, a question for you"
because the second could be a merge template and the first could not.
Never personalize deceptively: "your account" when no account exists, or
"re:" prefixes faking a prior conversation, are misrepresentation and, in
many jurisdictions, unlawful header deception.

### The subject/preview pairing is one unit

Inboxes render subject and preview text side by side; readers scan them as
a single sentence. Write them together:

- **Subject:** `The invoice that never sent`
- **Preview:** `A billing bug story, and the checklist that catches it.`

The preview should extend the subject, not repeat it and not waste the
space. Roughly 40–70 characters show on mobile and up to ~100 on desktop;
front-load, same as the subject.

Mechanics to know: the preview is either an explicit hidden snippet at the
top of the HTML or, if you set nothing, whatever text the client finds
first — which is how "View in browser | Unsubscribe" ends up as your
preview. Always set it deliberately. If your template's visible copy would
bleed into the preview after your snippet ends, pad the snippet with
invisible whitespace characters so the preview ends where you intended.

## Spam-filter reality (what actually matters)

The folklore that certain "trigger words" ("free," "sale," exclamation
marks) send mail to spam is mostly obsolete. Modern filters at the major
mailbox providers are machine-learning systems scoring dozens of signals
at once — sender reputation, authentication, complaint rates, and above
all recipient engagement: do people open, read, reply, delete unread, or
mark as spam. An established sender with strong engagement can say "free"
all day; a poor-reputation sender gets filtered no matter how sanitized
the vocabulary.

What this means for copywriting:

- Write the clearest honest subject; do not contort wording to dodge a
  mythical keyword list.
- The subject's real filter-relevance is indirect: subjects that attract
  opens and replies build the engagement history that keeps you inboxed,
  and subjects that disappoint train recipients to ignore or report you.
- Content still matters at the extremes — shouting caps, heavy
  punctuation!!!, misleading claims, and mismatched sender identity are
  genuine negative signals, mostly because they correlate with mail people
  report.
- Never vary or randomize subject wording to prevent filters from
  recognizing a bulk campaign. That is filter evasion, it violates mailbox
  provider policies, and it is the signature move of spam operations.
  Variation is for testing and for humans, not for evading detection.

## Emoji

Evidence is mixed and audience-dependent. Emoji can lift opens for consumer
audiences and seasonal sends, and can depress them for professional
audiences where they read as promotional. Rules of thumb: at most one, at
the start or end rather than mid-sentence, never as a substitute for a
word, and never in cold outreach to strangers. Rendering differs across
platforms, so check that the emoji you chose is not ambiguous or broken
elsewhere. Treat emoji as an A/B test variable, not a default.

## Eighteen patterns

Abstract templates with invented examples. Adapt the shape, not the words.

| # | Pattern | Invented example |
|---|---------|------------------|
| 1 | Specific number + topic | `3 onboarding emails you're not sending` |
| 2 | Named observation about the reader | `Your checkout flow on mobile` |
| 3 | Question answerable in one word | `Still handling refunds by hand?` |
| 4 | Curiosity gap the body resolves | `The pricing change that backfired` |
| 5 | Name + concrete topic | `Priya — Fernwood's wholesale program` |
| 6 | Company + concrete noun | `Harborlight's onboarding docs` |
| 7 | Single-noun subject | `renewals` |
| 8 | How-result, actor named | `How Bluegate cut no-shows 22%` |
| 9 | The common-mistake frame | `The mistake in most cart emails` |
| 10 | Direct offer, cost stated | `A teardown of your signup flow (free)` |
| 11 | Referral routing (genuine only) | `Who owns partnerships at Peakstone?` |
| 12 | Follow-through on a promise | `The checklist I mentioned` |
| 13 | Timely hook tied to reader's calendar | `Before Q4 planning locks` |
| 14 | Contrarian claim | `More follow-ups won't fix this` |
| 15 | Outcome, not category | `Fewer no-shows at Bluegate` |
| 16 | Genuine deadline, plainly stated | `Workshop seats close Friday` |
| 17 | Re-engagement check | `Should we stop emailing you?` |
| 18 | Plain announcement | `New: export to spreadsheet` |

Notes on use: pattern 11 is only legitimate when you truly want the
routing, not as pitch camouflage. Pattern 16 requires a real deadline —
inventing one is a deceptive practice. Pattern 7 works because it looks
like an internal note; it stops working the moment the body reads like an
ad, which the reader experiences as a small betrayal.

## What to A/B test

One variable per test, same body, adequate volume, then judge:

- **Length:** a 3-word version against a 7–9 word version.
- **Specificity:** number-led against curiosity-led for the same content.
- **Personalization:** company-name subject against topic-only subject.
- **Preview text:** extending the subject against a second, different hook.
- **Register:** sentence-case casual against plain-descriptive.
- **Emoji:** with and without, for owned audiences only.

Judge winners by downstream metrics — replies, clicks, conversions — not
raw opens. Privacy features in major mail clients pre-fetch or proxy
images, which inflates or hides opens in both directions. Winning subjects
also fatigue: a pattern that wins for months will decay as your audience
habituates, so keep a rotation of testable challengers.

## Don'ts

- No fake `Re:` or `Fwd:` prefixes implying a conversation that never
  happened — header deception, plus an instant trust burn on open.
- No bait-and-switch: every subject claim must be cashed in the body.
- No manufactured urgency ("FINAL NOTICE") for routine commercial mail.
- No all-caps, no stacked punctuation, no alarm-styled subjects.
- No misleading personalization implying an account, order, or
  relationship that does not exist.
- No wording contortions or randomization aimed at spam filters rather
  than readers.

Related: [formatting.md](formatting.md) for mobile rendering details;
[cold-outreach.md](cold-outreach.md) and
[newsletter-copy.md](newsletter-copy.md) for format-specific subject
guidance; back to [SKILL.md](../SKILL.md).
