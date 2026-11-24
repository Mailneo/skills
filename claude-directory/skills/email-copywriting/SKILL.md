---
name: email-copywriting
description: "Use when writing or reviewing email copy: subject lines, preview text, body structure, CTAs, personalization, follow-up sequences — for cold outreach, newsletters, or one-off broadcasts. Do NOT use for deliverability or sending-infrastructure questions (email-deliverability), automated sequence triggers and timing (email-lifecycle), or legal requirements and consent rules (email-compliance)."
---

# Email Copywriting

Write emails that respect the reader and still get replies. Everything here
assumes one non-negotiable: the message must work even when the recipient
knows exactly what it is. Tricks that depend on the reader believing something
false are excluded — they are legally risky, they burn sender reputation, and
the whole channel runs on trust.

## The method

Apply this order to any email-writing task. The subject line comes last.

1. **Audience before words.** Name the one person you are writing to: their
   role, what they already know, what they care about this week. If you cannot
   say why this specific reader benefits from this specific message, stop —
   no copy fixes an irrelevant email.
2. **One goal.** Decide the single action the email exists to produce: a
   reply, a click, a booking, a read. One email, one ask. Two asks split
   attention and usually get neither.
3. **Structure before sentences.** Pick the skeleton for the format:
   cold outreach is observation → value → ask
   (see [references/cold-outreach.md](references/cold-outreach.md));
   broadcasts are hook → value → CTA
   (see [references/newsletter-copy.md](references/newsletter-copy.md)).
4. **Draft long, cut hard.** Write everything, then delete most of it. Every
   line must earn the next line's read. A cold email should land between 50
   and 125 words; a newsletter section rarely needs more than three short
   paragraphs.
5. **Subject and preview text last, as a pair.** Only after the body is done
   do you know what promise it can honestly cash. Write the subject and the
   preview snippet together — inboxes display them as one unit
   (see [references/subject-lines.md](references/subject-lines.md)).
6. **Read it aloud once.** Anything you would not say across a table gets
   rewritten or cut.

## The rules that matter most

1. **Relevance is the entry ticket.** Targeting beats copy. A sharp email to
   the wrong person loses to a plain email to the right one, every time.
2. **Write to one person.** "You" sentences outperform "I/we" sentences.
   Recount your draft: if it opens with your company and your product, flip
   it until the reader is the subject of most sentences.
3. **Front-load everything.** Mobile clients truncate subjects around 35–40
   characters and previews around 40–70. First words carry the weight — in
   subjects, previews, first lines, and CTAs alike.
4. **Specificity beats cleverness.** "Cut quote turnaround from 9 days to 1"
   outworks "streamline your operations." Concrete nouns, real numbers,
   named outcomes.
5. **Match the ask to the relationship.** A stranger gets a one-word-reply
   question, not a calendar link. A subscriber gets one clear CTA, not five.
   The friction of the ask must fit the trust you have earned so far.
6. **Personalize with observation, not mail-merge.** A researched line about
   the recipient's actual work doubles reply rates in a way
   `{{first_name}}` never will. Never imply more research than you did.
7. **Keep it simple to read.** Copy written at roughly a grade 3–8 reading
   level gets measurably more responses than college-level prose. Short
   common words, short sentences, short paragraphs.
8. **The body must cash the subject's promise.** Curiosity gaps are fine;
   bait-and-switch is not. An open earned by deception converts to a spam
   complaint, and modern filters score engagement.
9. **Every commercial email identifies itself and offers a real way out.**
   Truthful sender name, honest subject, a working opt-out honored promptly.
   This is both law in most jurisdictions and good copy discipline — see the
   email-compliance skill for the legal detail.
10. **Test one variable at a time.** Subject against subject, ask against
    ask, never both at once. Judge by replies and clicks, not opens — open
    tracking is unreliable under modern privacy proxies.

## Never do

- **Hide or soften the opt-out.** Replacing an unsubscribe mechanism with a
  buried "reply 'no' if not interested" line is a compliance failure dressed
  as informality.
- **Manufacture scarcity or urgency.** "Only 2 spots left" when there is no
  limit is a deceptive practice. Deadlines are copy assets only when real.
- **Fake personal effort.** Phony "sent from my phone" signatures,
  deliberately broken links engineered to provoke replies, or personalization
  theater that implies research you never did.
- **Use pretext framings.** A "quick survey," podcast invitation, or
  "who should I talk to?" ask that is secretly a pitch is deception even if
  every sentence is technically true. Use those angles only when genuine.
- **Randomize phrasing to dodge spam-filter fingerprinting.** Vary copy to
  serve readers and tests, never to evade provider abuse detection — that is
  the defining behavior of a spam operation.

## Going deeper

- [references/subject-lines.md](references/subject-lines.md) — principles,
  the subject/preview pairing, spam-filter reality, 18 reusable patterns,
  what to A/B test.
- [references/cold-outreach.md](references/cold-outreach.md) —
  compliance-first framing, the three-part anatomy, personalization tiers,
  ask design, follow-up sequences, reply handling.
- [references/newsletter-copy.md](references/newsletter-copy.md) — broadcast
  structures, editorial voice, scannability, content-to-promotion ratios,
  welcome and win-back copy, CTA design for opted-in audiences.
- [references/formatting.md](references/formatting.md) — readability targets,
  mobile constraints, accessibility, plain-text vs HTML, link and image
  hygiene, the P.S. pattern.

## Sibling skills

- **mailneo** — execute what you write: create and send campaigns,
  newsletters, and sequences through the Mailneo API.
- **email-deliverability** — whether the email arrives at all: sender
  reputation, authentication, volume, list hygiene.
- **email-lifecycle** — when automated emails fire and in what order:
  triggers, timing, journey design. This skill covers the words inside them.
- **email-compliance** — the legal floor: consent, required disclosures,
  opt-out rules per jurisdiction. When copy advice here conflicts with a
  legal requirement, the law wins.
