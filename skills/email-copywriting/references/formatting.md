# Formatting, Readability, and Accessibility

How an email reads is inseparable from what it says. The same words win or
lose depending on whether they survive a phone screen, a screen reader, an
image-blocking client, and a distracted human giving you eight seconds.

## Readability targets

Simpler prose gets more responses — this is one of the best-evidenced
findings in email. Analysis of tens of millions of messages found that
copy at roughly a third-grade reading level outperformed college-level
writing by about a third more responses, and beat even high-school-level
writing by double digits. Aim for a US grade 3–8 score.

Practically:

- Prefer the short common word: "use" not "utilize," "help" not
  "facilitate," "so" not "consequently."
- Cut jargon, buzzwords, and hype verbs ("revolutionize," "supercharge",
  "unlock") — they add syllables and subtract trust.
- Check drafts with any grade-level readability scorer — free ones are
  built into many editors — when the stakes justify it.
- Simple is not simplistic: the ideas can be sophisticated; the sentences
  carrying them should not be.

## Sentences and paragraphs

- Sentences: mostly under ~15 words; vary length so the rhythm doesn't
  flatline, but let short be the default.
- Paragraphs: 1–3 sentences, one idea each. On a phone, a 4-sentence
  paragraph is a wall.
- Line breaks are free; use them generously. White space is what makes an
  email feel answerable instead of homework.
- Active voice, concrete subjects: "We shipped the fix" not "The fix was
  shipped."
- Write like you speak, then tighten. Reading a draft aloud catches the
  sentences no human would say.
- Delete throat-clearing: "I hope this finds you well," "I just wanted to
  reach out," "As you may know." Start where the content starts.
- Emphasis (bold, italics) is a spice: a few bolded phrases can carry a
  skimmer through a newsletter; bolding whole sentences carries no one.
- Cold email length: 50–125 words. Newsletters can run long if every
  section survives the cut on its own merits.

## Mobile-first constraints

More than half of opens happen on phones, so the phone is the primary
canvas, not the edge case.

- **Width:** HTML emails at 600px maximum, single column. Multi-column
  layouts stack unpredictably across clients.
- **Type size:** body text at least 16px; smaller sizes trigger zooming
  and abandonment.
- **Tap targets:** buttons and links need roughly 44px of touch area, and
  should not sit adjacent to other links a thumb could hit instead.
- **Truncation:** subjects show ~33–41 characters, preview text ~40–70
  (see [subject-lines.md](subject-lines.md)); front-load both.
- **The 8-second test:** on a phone, the first screen must convey who this
  is from, what it's about, and why the reader should keep scrolling —
  before any scrolling happens.
- Send a test to yourself and open it on an actual phone before any
  campaign goes out.

## Accessibility

A meaningful share of any list reads with a screen reader, magnification,
high-contrast mode, or images off. Accessible email is also plainly better
email for everyone.

- **Semantic structure.** Real heading elements (`<h1>`, `<h2>`) and real
  paragraph tags, in logical order — not styled `<div>`s and `<span>`s.
  Screen readers navigate by headings; a heading-free email is a wall.
- **Alt text on every image.** Describe the information the image carries
  ("Chart: reply rate doubles when the first line is personalized"), not
  its appearance ("chart.png"). Purely decorative images get an empty
  `alt=""` so screen readers skip them.
- **Never put essential copy only inside an image.** Image-blocking
  clients and screen readers both lose it. Headlines, offers, and CTAs
  must exist as real text.
- **Contrast:** at least 4.5:1 for body text, 3:1 for large text. Grey-on-
  white aesthetic minimalism routinely fails this.
- **Don't rely on color alone** to signal meaning ("items in red are
  urgent") — pair color with a word or symbol.
- **Descriptive link text.** "Read the pricing guide," never "click here"
  or a bare URL; screen-reader users often navigate a list of links out of
  context.
- **Set the document language** in the HTML so screen readers pronounce
  the content correctly.
- **Left-align body text.** Centered or justified paragraphs are slower to
  read for everyone and hostile to dyslexic readers.

## Plain text vs HTML

Neither is universally right; the format should match the relationship.

- **Cold outreach: plain text or minimal HTML.** A real one-to-one email
  from a person contains no hero images, buttons, or brand headers, and
  cold email should look like what it claims to be. Styled templates in a
  cold context read as marketing before the first word lands. Beware
  invisible HTML pasted in from rich-text editors — it bloats the message
  and can hurt placement.
- **Newsletters and broadcasts: restrained HTML.** Opted-in readers expect
  structure, images, and buttons. Restraint still wins: text-forward
  layouts with a few images outperform image-heavy designs, which also
  fail when images are blocked by default — as they are in many corporate
  clients.
- **Always include the plain-text MIME part** alongside HTML. Some clients
  and assistive tools prefer it, and an HTML-only message is a mild
  negative signal to filters.
- **Tracking weights.** Open tracking works by remote image, which privacy
  proxies in major mail clients now pre-fetch or block — so open data is
  unreliable in both directions, and in cold contexts the pixel itself
  can cost inbox placement. Steer by replies and clicks. Details in the
  email-deliverability skill.

## Link and image hygiene

- **Cold email: zero or one link,** and ideally none until the recipient
  says yes to receiving something. Every link is a small trust demand and
  a filter signal.
- **No attachments in cold email, ever** — scanners treat unexpected
  attachments as malware risk, and so do humans.
- **No URL shorteners.** They hide the destination, which is exactly what
  phishing does; filters and readers penalize accordingly.
- **Newsletters: links are fine, purposeful, and labeled.** Every link's
  text should say where it goes. Audit templates for stale boilerplate
  links that leak into preview text.
- **Images enhance; text carries.** Compress images, define their
  dimensions so layouts don't jump while loading, and confirm the email
  survives images-off intact.
- **One visual CTA per send** (see
  [newsletter-copy.md](newsletter-copy.md)); a button and a matching text
  link can point at the same destination.

## The P.S. pattern

The P.S. line is among the most-read lines in any email — skimmers hit
the sign-off and catch it on the way out. Uses that earn it:

- One genuinely personal note in cold outreach ("P.S. Your talk on cold
  chains at the Fernwood summit is why I wrote — the pallet-tracking bit
  especially."), which lands only when true.
- A low-key secondary point in a newsletter ("P.S. The workshop from
  issue 12 now has a self-serve version.") — the one sanctioned exception
  to the single-CTA rule, kept soft.
- A deadline restated once, if the deadline is real.

One P.S. maximum. A P.S. that is obviously templated ("P.S. {{company}}
is exactly the kind of business we help!") reads worse than none.

Related: [subject-lines.md](subject-lines.md),
[cold-outreach.md](cold-outreach.md),
[newsletter-copy.md](newsletter-copy.md); back to
[SKILL.md](../SKILL.md).
