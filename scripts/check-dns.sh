#!/usr/bin/env bash
# check-dns.sh — DNS triage for a domain (read-only)
# Usage: ./check-dns.sh example.com
set -u
DOMAIN="${1:-}"
if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <domain>"
  echo "Example: $0 example.com"
  exit 1
fi

echo "== DNS check: $DOMAIN =="
echo
echo "-- A records --"
dig +short A "$DOMAIN" || echo "  (no A record)"
echo
echo "-- AAAA records --"
dig +short AAAA "$DOMAIN" || echo "  (no AAAA record)"
echo
echo "-- MX records --"
dig +short MX "$DOMAIN" || echo "  (no MX record)"
echo
echo "-- NS records --"
dig +short NS "$DOMAIN" || echo "  (no NS record)"
echo
echo "-- TXT records --"
dig +short TXT "$DOMAIN"
echo
echo "-- SPF --"
dig +short TXT "$DOMAIN" | grep -i "v=spf1" || echo "  No SPF record found"
echo
echo "-- DMARC (_dmarc) --"
dig +short TXT "_dmarc.$DOMAIN" | grep -i "v=DMARC1" || echo "  No DMARC record found"
echo
echo "-- DKIM (default selector — check the real selector if this is empty) --"
dig +short TXT "default._domainkey.$DOMAIN" || echo "  (no default._domainkey record)"
echo
echo "Done. Compare the A record with the server IP in WHM / the billing portal first."
