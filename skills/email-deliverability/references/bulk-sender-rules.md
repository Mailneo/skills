# Bulk-sender rules: the enforced requirements at Google, Yahoo, and Microsoft

Between 2024 and 2025 the three dominant consumer mailbox providers turned
long-standing best practices into enforced entry requirements. This is the
single largest change in email deliverability in a decade, and any guidance
predating it is incomplete. Current state as of 2026: all three enforce at
the SMTP level — non-compliant bulk mail is *rejected in the connection*,
not spam-foldered.

## Timeline

- **October 2023** — Google and Yahoo jointly announce sender requirements.
- **February 2024** — requirements take effect at both.
- **April–June 2024** — Google ramps enforcement: temporary failures on a
  growing share of non-compliant traffic, then rejections; the one-click
  unsubscribe deadline lands June 2024.
- **May 5, 2025** — Microsoft applies materially the same authentication
  requirements to its consumer domains (outlook.com, hotmail.com,
  live.com), first junking then rejecting non-compliant mail.
- **2026** — steady state: permanent 5xx rejections at all three for
  authentication failures by high-volume senders.

## Who counts as a "bulk sender"

- **Google**: anyone sending **~5,000 or more messages per day to personal
  Gmail accounts** (counted across the organizational domain, subdomains
  included, within a 24-hour period). Crossing the line once is enough —
  **the classification is permanent**; dropping volume later does not
  un-ring the bell.
- **Microsoft**: the same 5,000/day figure against its consumer domains.
- **Yahoo**: no hard published number; treat the same 5,000/day line as
  operative.

Do not architect around ducking the threshold. The sub-threshold
requirements are only slightly lighter (authentication via SPF *or* DKIM,
same spam-rate cap, same DNS/TLS hygiene), providers grade everyone on the
same signals, and splitting volume across domains to stay under the line is
the snowshoe pattern blocklists specifically hunt (see
[troubleshooting.md](troubleshooting.md)). The full requirement set is
simply correct practice at any volume.

## The compliance table

| Requirement | Gmail | Yahoo | Outlook.com |
|---|---|---|---|
| SPF **and** DKIM both pass | Required | Required | Required |
| DMARC record on From domain (min `p=none`) | Required | Required | Required |
| From domain aligns with SPF or DKIM domain | Required | Required | Required |
| One-click unsubscribe (RFC 8058) on commercial mail | Required | Required | Recommended, signaled to become required |
| Honor unsubscribe within 2 days | Required | Required | Recommended |
| Spam complaint rate | < 0.3% hard, < 0.1% advised | Same intent (keep low; 0.3% is the accepted cap) | No published number — governed via SNDS/JMRP data |
| Valid forward + reverse DNS (PTR matches sending host) | Required | Required | Expected |
| TLS for delivery | Required | Expected | Expected |
| RFC 5322-compliant formatting; no provider-domain impersonation in From | Required | Required | Required (valid, functional From/reply-to) |

Alignment is the sleeper clause: plenty of senders "have" SPF, DKIM, and
DMARC yet fail because everything authenticates as their sending platform's
domain rather than their From domain. Mechanics and fixes:
[authentication.md](authentication.md).

## RFC 8058 one-click unsubscribe, mechanically

Two headers on every commercial/marketing message (transactional mail is
exempt):

```
List-Unsubscribe: <https://mail.yourdomain.com/u?t=b64token>, <mailto:unsub@yourdomain.com>
List-Unsubscribe-Post: List-Unsubscribe=One-Click
```

When a recipient clicks the provider-rendered unsubscribe control, the
provider sends an HTTP **POST** to your HTTPS URI with the body
`List-Unsubscribe=One-Click`. Requirements on your endpoint:

- The POST alone completes the unsubscribe. No login, no confirmation page,
  no "manage preferences" interstitial, no additional clicks.
- The URI must carry everything needed to identify the subscription (an
  opaque token — never a bare email address someone could enumerate).
- Idempotent, and tolerant of automated calls: security scanners fetch
  URLs, which is also why GET on that URI must never unsubscribe anyone.
- Suppression takes effect within **two days**, network-wide.

The `mailto:` form may ride alongside as a fallback. Two things the headers
do **not** replace: a visible unsubscribe link in the body (legal regimes
generally require an in-message mechanism — see the `email-compliance`
skill), and actual suppression discipline in your sending system.

Counterintuitive but true: an effortless unsubscribe is deliverability
*protection*. Every recipient who cannot find the exit uses the "report
spam" button instead, and that button is the metric providers enforce.

## Complaint-rate math and monitoring

The enforced metric is **user-reported spam** ÷ **mail delivered to active
inboxes at that provider**, computed daily (Gmail's definition; the others
are directionally the same). Worked example: 40,000 messages delivered to
Gmail inboxes, 48 spam reports that day → 0.12%. Over the advised 0.1%,
under the 0.3% cap — survivable once, alarming as a trend.

Properties that surprise people:

- **Only inboxed mail can be reported.** As placement degrades, the
  denominator shrinks while your most annoyed recipients still find the
  mail — so the *rate* can climb as you send less successfully. Complaint
  problems self-amplify; act early.
- **It is daily, per provider — not a campaign average.** One reactivation
  blast into a stale cohort can put a single day over 0.3% while the
  monthly average looks fine. Gmail tolerates rare bad days; sustained or
  repeated breaches draw enforcement.
- **Per thousand**: 0.1% is one complaint per 1,000 inboxed; 0.3% is three.
  At small volumes single complaints swing the rate — another reason
  sub-threshold senders should behave like bulk senders.

Monitoring stack: Postmaster Tools spam-rate dashboard daily (Gmail),
JMRP individual complaint reports plus SNDS (Microsoft), the Yahoo
complaint feedback loop, and immediate suppression of every complainer.
Reading all of these is covered in
[troubleshooting.md](troubleshooting.md). List-side prevention — sunset
policies, permission refresh, not mailing the disengaged — is the
`email-lifecycle` skill; it is the cheapest complaint reduction available.

## Consequences and recovery

Enforcement escalates in a recognizable sequence:

1. **Temporary failures** (4xx) on a slice of traffic, with error text
   pointing at the sender guidelines — the warning shot.
2. **Bulking**: compliant-looking delivery, spam-folder placement.
3. **Rejection** (permanent 5xx). Signature codes: Gmail's `550 5.7.26`
   family for authentication/alignment failures (and `5.7.28` for volume
   anomalies); Microsoft's `550 5.7.15` "Access denied, sending domain
   does not meet the required authentication level."

Recovery procedure:

1. Read the rejection text and the Postmaster **Compliance status**
   dashboard — between them they name the failed requirement.
2. Fix that requirement (usually authentication/alignment or the
   unsubscribe headers; occasionally spam rate).
3. Cut volume to the engaged core and run the recovery ramp from
   [warmup-and-volume.md](warmup-and-volume.md).
4. Expect lag: compliance status is computed on multi-day rolling windows,
   so a real fix shows up in days and full recovery in weeks. Recheck
   after 72 hours, not 2.

There is no paid escalation path, no allowlisting product, and no support
channel that overrides these systems for bulk senders. Anyone selling
guaranteed inboxing or expedited un-blocking at a major provider is selling
something they do not have. The requirements are mechanical; meet them.
