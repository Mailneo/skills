# Authentication: SPF, DKIM, DMARC, and what "aligned" actually means

Authentication answers one question for the receiving server: *is the entity
named in the From header actually the entity that sent this?* Three DNS-based
mechanisms answer it from different angles, and a fourth (DMARC) ties them to
the address the human sees. All are plain DNS records; all can be verified
before a single message is sent.

All examples below use invented domains (`yourdomain.com`,
`mailer.example.net`) and documentation IP ranges (`203.0.113.0/24`).

## SPF — which servers may send for a domain

SPF is a TXT record listing the IP addresses and hosts authorized to send
mail whose **return-path** (the invisible bounce address, also called
RFC5321.MailFrom) uses your domain. A receiver looks up the record and checks
whether the connecting IP is on the list.

```
yourdomain.com.  TXT  "v=spf1 ip4:203.0.113.25 include:spf.mailer.example.net -all"
```

- `ip4:` / `ip6:` — literal addresses or CIDR ranges you send from.
- `include:` — splice in a sending platform's published ranges.
- `-all` — hard fail for everything else; `~all` (softfail) is the cautious
  choice while you are still inventorying senders.

Two sharp edges:

1. **The 10-lookup limit.** Every `include:`, `a`, `mx`, and `redirect`
   costs a DNS lookup, recursively. Past ten, receivers return `permerror`
   and your SPF silently stops working. Platforms that "flatten" records
   exist because of this; audit your includes before adding another service.
2. **SPF checks the return-path, not the From header.** A message can pass
   SPF while displaying any From address at all. It also breaks when mail is
   forwarded (the forwarder's IP is not in your record). Both gaps are why
   SPF alone proves very little — DKIM and DMARC exist to close them.

## DKIM — a signature that travels with the message

DKIM publishes a public key in DNS and signs each outgoing message with the
private half. The signature covers selected headers and the body, so the
receiver can verify both *authorization* (the key lives in your DNS) and
*integrity* (nothing was altered in transit).

The public key sits at `<selector>._domainkey.<domain>`:

```
s1._domainkey.yourdomain.com.  TXT  "v=DKIM1; k=rsa; p=MIIBIjANBgkq...IDAQAB"
```

The message carries the matching signature header:

```
DKIM-Signature: v=1; a=rsa-sha256; d=yourdomain.com; s=s1;
    h=from:to:subject:date; bh=<body-hash>; b=<signature>
```

Practical rules:

- Use **2048-bit keys**; 1024-bit is legacy and some receivers penalize it.
- Selectors (`s=`) let multiple keys coexist — one per platform, and spares
  for rotation. Rotate keys periodically; a leaked private key lets anyone
  sign as you.
- **Sign with your own domain.** Sending platforms will happily sign with
  *their* domain by default (`d=mailer.example.net`). That mail passes DKIM
  but does nothing for you, because of alignment — see below. Setting up the
  platform's "custom DKIM" / "sending domain" feature is usually the single
  highest-value authentication task.
- DKIM usually survives forwarding (unlike SPF) but breaks when
  intermediaries modify the message — mailing lists that add footers are the
  classic case.

## DMARC — binding both to the From header, plus a policy

DMARC is a TXT record at `_dmarc.<domain>` that does three things: it tells
receivers your mail should authenticate, tells them what to do when it does
not, and gets you reporting on who is sending as you.

```
_dmarc.yourdomain.com.  TXT  "v=DMARC1; p=none; rua=mailto:dmarc-reports@yourdomain.com; adkim=r; aspf=r"
```

A message passes DMARC when **at least one** of these holds:

- SPF passes **and** the return-path domain aligns with the From domain, or
- DKIM verifies **and** the `d=` domain aligns with the From domain.

**Alignment** is the load-bearing word. *Relaxed* alignment (`adkim=r`,
`aspf=r`, the default) accepts any subdomain of the same organizational
domain — `mail.yourdomain.com` aligns with `yourdomain.com`. *Strict* (`s`)
requires an exact match.

This is why platform-default setups fail DMARC despite "passing" SPF and
DKIM: the return-path is the platform's bounce domain and the DKIM `d=` is
the platform's domain, so nothing aligns with *your* From address. Custom
DKIM (your domain in `d=`) is typically what makes DMARC pass, because the
custom return-path may still be the platform's on some services.

### Policy progression: none → quarantine → reject

- **`p=none`** — monitor only. Deploy this first, with `rua=` aggregate
  reporting, and read the reports for several weeks. Expect surprises: the
  billing system, the helpdesk, the CRM, an old marketing tool — every
  legitimate source must authenticate and align before you tighten policy,
  or you will junk your own invoices.
- **`p=quarantine`** — failing mail goes to spam. Ramp with `pct=` if you
  want a staged rollout (`p=quarantine; pct=25`), though `pct` is applied
  unevenly by receivers; treat it as a rough dial.
- **`p=reject`** — failing mail is refused outright. The end state for any
  domain that matters; also a prerequisite for BIMI.
- `sp=` sets a separate policy for subdomains; attackers love forgotten
  subdomains, so once the organizational domain is at enforcement, cover
  subdomains too. Domains that send no mail at all should carry
  `v=spf1 -all`, an empty DKIM story, and `p=reject`.

Note the distinction between what bulk-sender rules demand (`p=none`
minimum — a published record, any policy) and what security demands
(enforcement). `p=none` satisfies the mailbox providers; it does not stop
anyone from spoofing you.

## Custom tracking and bounce domains

Click/open tracking rewrites links through a tracking hostname, and bounces
route through a return-path domain. On a platform's shared defaults, both are
*shared* hostnames: you inherit the reputation of every other customer using
them, and one bad actor taints the pool. There is also an alignment cost —
links pointing at a third-party domain unrelated to your From domain look,
to a filter, like exactly what phishing looks like.

The fix is two CNAMEs on your own domain, delegated to the platform:

```
links.yourdomain.com.    CNAME  track.mailer.example.net.
bounces.yourdomain.com.  CNAME  rp.mailer.example.net.
```

One tracking domain per sending domain, served over HTTPS. While you are at
it: the sending domain itself should resolve to a real site identifying the
sender, and any secondary sending domains should 301-redirect to the primary
site so a curious recipient lands somewhere legitimate.

## BIMI — the logo, briefly

BIMI displays your logo next to authenticated mail in supporting inboxes. It
is a brand and anti-phishing feature, not a placement lever — its main
deliverability value is that it forces DMARC hygiene.

Requirements: DMARC at enforcement (`p=quarantine` at `pct=100`, or
`p=reject`) on the organizational domain; a logo in SVG Tiny P/S format; and
a record like:

```
default._bimi.yourdomain.com.  TXT  "v=BIMI1; l=https://yourdomain.com/brand/logo.svg; a=https://yourdomain.com/brand/mark-cert.pem"
```

The catch is the certificate. Gmail and Apple Mail only display logos backed
by a mark certificate from an authorized certification authority:

- **VMC (Verified Mark Certificate)** — requires a registered trademark on
  the logo; list prices run roughly $1,100–1,750 per year. Gets the blue
  verified checkmark in Gmail.
- **CMC (Common Mark Certificate)** — accepted by Gmail since late 2024 for
  logos with 12+ months of demonstrated prior use, no trademark needed, at
  roughly half the VMC price — but without the verified checkmark.

Some providers display self-asserted BIMI (record only, no certificate), but
not the ones that matter most. Verdict: worthwhile for established consumer
brands at volume; skip it until DMARC enforcement is done, because that part
is required anyway and free.

## Verifying all of it

Do not trust the DNS records; trust received mail. Send to a mailbox you
control at a major provider and read the raw headers ("Show original" in
Gmail gives a one-glance SPF / DKIM / DMARC pass-fail summary plus the
authenticating domains). Confirm all three pass **and** that the passing
domain is yours, not your platform's. Then confirm the same in aggregate via
provider dashboards — see the Postmaster section of
[troubleshooting.md](troubleshooting.md).
