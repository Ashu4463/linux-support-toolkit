# linux-support-toolkit

Daily Linux support checks I actually use at work — DNS, SSL, website status, server health and WordPress health. All scripts are **read-only**: they check things, they change nothing.

Built by a Linux Technical Support Engineer (cPanel / WHM, Plesk, DNS, SSL, WordPress) for faster first-response triage on hosting tickets.

## Quick start

```bash
git clone https://github.com/Ashu4463/linux-support-toolkit.git
cd linux-support-toolkit
chmod +x scripts/*.sh

./scripts/check-dns.sh example.com
./scripts/check-ssl.sh example.com
./scripts/check-website.sh https://example.com
./scripts/server-health.sh
./scripts/wordpress-check.sh /home/username/public_html
```

No dependencies beyond standard Linux tools: `dig`, `curl`, `openssl`, `df`, `free`, `systemctl`.

## Scripts

| Script | What it checks |
| --- | --- |
| `check-dns.sh <domain>` | A, AAAA, MX, NS, TXT records + SPF / DMARC presence |
| `check-ssl.sh <domain> [port]` | Certificate expiry date, days left, issuer, TLS version |
| `check-website.sh <url>` | HTTP status, redirect chain, response time, server header |
| `server-health.sh` | Load, memory, disk + inodes, top disk users, failed services |
| `wordpress-check.sh <path>` | `wp-config.php` present, WP version, debug log, uploads writable, `.htaccess` present — runs WP-CLI as the site user, never as root |

## Guides

- [`guides/dns-troubleshooting.md`](guides/dns-troubleshooting.md) — site not resolving / wrong IP / propagation
- [`guides/ssl-troubleshooting.md`](guides/ssl-troubleshooting.md) — expired, mismatch, mixed content, AutoSSL
- [`guides/email-deliverability.md`](guides/email-deliverability.md) — SPF, DKIM, DMARC, mail going to spam
- [`guides/hacked-site-check.md`](guides/hacked-site-check.md) — check dates, not names; files, users, posts & DB

## My triage order (domain issue)

1. Check the **A record** — does the domain point at the right server IP?
2. Check the plan / account status in the billing portal.
3. Then SSL, then the application (WordPress / PHP / database).

Most "site down" tickets end at step 1.

## Notes

- Scripts never write, delete or restart anything.
- WordPress checks run as the site's cPanel account user — never with `--allow-root`.
- Replace `example.com` with the real domain; never paste client passwords into a ticket or a script.
