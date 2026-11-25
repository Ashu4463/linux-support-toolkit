# DNS troubleshooting

## Symptoms
- Site not loading / "server not found"
- Site opens on mobile data but not on office Wi-Fi (or vice versa)
- Mail works, website doesn't (or the reverse)

## Check in this order

1. **A record** — `./scripts/check-dns.sh example.com`
   Does the A record point at the server IP in WHM / the billing portal?
   Wrong IP = the whole problem. Fix the A record, don't reinstall anything.
2. **Nameservers** — are they the host's nameservers, or Cloudflare / the registrar's?
   If the domain uses Cloudflare, DNS edits must be made in Cloudflare, not in cPanel.
3. **Propagation** — a recent change takes time. Check from two networks / `whatsmydns.net`.
   Don't keep re-saving the same record; wait and re-check.
4. **Local cache** — `ipconfig /flushdns` (Windows) or restart the browser, then re-test.

## Common mistakes
- Editing DNS in cPanel while the domain points at Cloudflare nameservers.
- A record pointing at the old server after a migration.
- MX pointing at Google / Outlook while expecting mail in cPanel (or the reverse).
