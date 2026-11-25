# SSL troubleshooting

## Symptoms
- "Your connection is not private" / NET::ERR_CERT_DATE_INVALID
- Site loads on HTTP but not HTTPS
- Padlock missing on some pages only

## Check in this order

1. **Expiry** — `./scripts/check-ssl.sh example.com`
   Expired = renew. In cPanel: SSL/TLS Status → Run AutoSSL.
2. **Domain mismatch** — does the certificate cover `example.com` *and* `www.example.com`?
   A cert for the root domain alone will warn on `www`.
3. **Mixed content** — the page is HTTPS but loads an image / script over HTTP.
   Fix the URLs in the page, or use a Really Simple SSL-style rewrite — don't disable HTTPS.
4. **DNS first** — if the A record is wrong, AutoSSL / Let's Encrypt validation fails too.
   Fix DNS, then re-run AutoSSL.

## Notes
- Free AutoSSL / Let's Encrypt renews every 90 days — a failed renewal is usually a DNS or `.htaccess` redirect problem, not a certificate problem.
- Never tell a visitor to "click Advanced → Proceed anyway" as a fix.
