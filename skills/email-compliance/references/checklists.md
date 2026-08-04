# Compliance checklists

> **This is practical guidance, not legal advice.** These checklists
> encode the common floor and the major regimes' mechanics as of mid-2026;
> they do not replace review of your specific facts by a qualified lawyer,
> especially for jurisdiction-specific questions.

Regulation detail behind each item is in regulations.md; record-keeping
detail in consent-records.md.

## Every commercial email (pre-send)

Run this on any message whose primary purpose is promotion, every time:

- [ ] From name and address truthfully identify the actual sender; the
      reply path works and is monitored.
- [ ] Subject line makes no claim the body does not honor.
- [ ] The commercial nature of the message is apparent, not disguised as
      personal or transactional mail.
- [ ] Physical postal address present (required in the US and Canada;
      good practice everywhere).
- [ ] Visible unsubscribe: free, no login, no data demanded beyond the
      email address.
- [ ] At bulk volume: one-click unsubscribe headers present and the
      endpoint honors the automated POST (see email-deliverability).
- [ ] Suppression list applied at send-assembly time — not at list-build
      time, when later opt-outs would be missed.
- [ ] Every recipient has a documented basis: consent record, soft
      opt-in eligibility, a written legitimate-interest assessment, or
      the US opt-out lane.
- [ ] All claims in the body are true, including any scarcity or urgency
      — a deadline or capacity limit stated must actually exist.
- [ ] The sending platform's terms permit this list and this use.

## Cold campaign — US B2B

For unsolicited outreach to recipients in the United States:

- [ ] Jurisdiction check done: recipients confirmed US-based; EU, UK,
      Canadian and Australian addresses removed or handled under their
      own rules (see the matrix in regulations.md).
- [ ] Header information accurate; sending domain and identity are really
      yours, with no lookalike misdirection.
- [ ] Subject line non-deceptive; no pretext framing (fake survey, fake
      referral request, fake reply threading such as a bogus "Re:").
- [ ] Message identified as commercial; physical postal address included.
- [ ] Opt-out notice clear and conspicuous — an explicit statement, not a
      euphemism buried in a sign-off. A reply-based mechanism is
      permitted, but only alongside a notice that plainly says the
      recipient can opt out and how.
- [ ] Opt-out mechanism stays operable for at least 30 days after the
      send.
- [ ] Opt-outs honored within 10 business days — engineered as
      immediate.
- [ ] Opted-out addresses never sold, transferred or reused.
- [ ] List source documented; no harvested or scraped-at-scale addresses
      and no auto-generated accounts anywhere in the pipeline (these are
      the statute's aggravated violations).
- [ ] If sending on a client's behalf: both parties compliant and the
      contract says who does what — liability attaches to both.
- [ ] Sending platform's terms actually permit unsolicited outreach —
      many prohibit it regardless of CAN-SPAM.

## EU / UK audience

For any campaign whose list includes EU or UK recipients:

- [ ] A basis exists per recipient and is written down: a consent record
      meeting the standard in consent-records.md, soft opt-in
      eligibility (own prior customer, own similar products, opt-out
      offered at collection and since), or — for corporate B2B addresses
      in member states that permit it — a documented
      legitimate-interest assessment.
- [ ] No consent relies on a pre-ticked box, inactivity, or acceptance
      of terms of service.
- [ ] Recipients whose data you did not collect directly have received a
      transparency notice identifying you and their rights.
- [ ] Member-state check done for B2B sending — Germany and Austria are
      consent-only even for business recipients.
- [ ] Sole traders and partnerships in the UK treated as individuals,
      not corporates.
- [ ] Objections and unsubscribes honored immediately and
      unconditionally — there is no balancing test against a marketing
      objection.
- [ ] Withdrawal of consent is as easy as giving it was.
- [ ] Erasure requests delete the data but retain a minimal suppression
      record (see consent-records.md).
- [ ] Processor agreement in place with the email tool; transfer
      mechanism confirmed if data leaves the region.

## Unsubscribe-handling SLA

The standing machinery, independent of any single campaign:

- [ ] Every commercial template contains the unsubscribe link — checked
      as part of template review, not assumed.
- [ ] The link works without login, payment or any data beyond the
      address, and works from every client including mobile.
- [ ] One-click headers present on bulk marketing mail; the POST endpoint
      suppresses without rendering a page or asking questions.
- [ ] Internal target: suppression effective immediately. Hard ceilings
      honored with margin: about two days (provider expectation), five
      business days (Australia), ten business days (US, Canada).
- [ ] Reply-channel opt-outs count: replies saying "unsubscribe",
      "remove me", "stop" are detected — by human or machine — and
      suppressed within the same SLA.
- [ ] Suppression is global: all brands, all sending tools, all future
      imports check it before an address becomes mailable.
- [ ] Suppression entries are never deleted by cleanup jobs; removing
      one is an explicit human decision about a named address (the
      mailneo skill enforces this shape at the API level).
- [ ] Re-subscription happens only through a new affirmative act by the
      person — never by import, migration or support ticket.
- [ ] Time-from-request-to-suppression is measured, and failures alert
      someone whose job it is to care.
- [ ] The unsubscribe path is tested end-to-end on a schedule (monthly
      is reasonable): click it, confirm the suppression landed, confirm
      the next send excluded the address.

## Audit your current practice

Questions to ask of a running program. Any "no" or "I don't know" marks
real exposure:

1. Pick a random address on your list: can you produce when, where and
   how they consented, and the exact wording they saw?
2. Which jurisdictions are actually represented on your list — measured,
   not assumed?
3. What happens, step by step, when someone clicks unsubscribe, and how
   long until the next send excludes them? Have you timed it?
4. If someone replies "take me off your list", does that reach a person
   or system that acts on it within your SLA?
5. When someone asks you to delete their data, does your process retain
   the suppression entry — and does anything else re-import the address
   later?
6. Do imports and integrations check the suppression list before an
   address becomes mailable?
7. Can you name the legal basis for every segment you mailed last month,
   and show the legitimate-interest assessment where that is the basis?
8. Are your urgency and scarcity claims verifiable facts?
9. In agency or client relationships, does the contract say who owns
   compliance, records and opt-out handling — knowing the law holds both
   parties liable?
10. When did you last read the acceptable-use policy of your sending
    platform, and would your current list survive it?
11. Does anyone review complaint rates and provider feedback for
    compliance signals, not just deliverability ones?
12. If a regulator asked about one specific message tomorrow, could you
    reconstruct from records its content, audience, per-recipient basis
    and opt-out state at send time?
