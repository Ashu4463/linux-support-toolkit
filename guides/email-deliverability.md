# Email deliverability — SPF, DKIM, DMARC

## Symptoms
- Mail goes to spam (Gmail / Outlook)
- "550 SPF check failed" / "DMARC policy" bounces
- Mail works one way only

## Check in this order

1. **SPF** — `./scripts/check-dns.sh example.com` → look for `v=spf1`.
   SPF must list every server that sends mail for the domain (web server + Google Workspace / Outlook if used).
   Only **one** SPF record is allowed — two SPF records break SPF.
2. **DKIM** — the mail provider signs outgoing mail; the public key lives in DNS as `<selector>._domainkey`.
   Ask the provider for the correct selector — `default` is only a guess.
3. **DMARC** — `_dmarc.example.com` should exist (`v=DMARC1; p=none/quarantine/reject`).
   Start with `p=none` + a reporting address, move to `quarantine` only after the reports are clean.
4. **Blacklists** — check the sending IP at `mxtoolbox.com/blacklists.aspx`.

## Common mistakes
- SPF missing the web server, so contact-form mail fails SPF.
- Two SPF records after adding Google Workspace to a cPanel SPF.
- DMARC `p=reject` set on day one, before checking the reports.
