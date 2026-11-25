#!/usr/bin/env bash
# check-ssl.sh — SSL certificate expiry & TLS check (read-only)
# Usage: ./check-ssl.sh example.com [443]
set -u
DOMAIN="${1:-}"
PORT="${2:-443}"
if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <domain> [port]"
  echo "Example: $0 example.com 443"
  exit 1
fi

echo "== SSL check: $DOMAIN:$PORT =="
EXPIRY=$(echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:$PORT" 2>/dev/null | openssl x509 -noout -dates -issuer -subject 2>/dev/null)
if [ -z "$EXPIRY" ]; then
  echo "Could not fetch a certificate for $DOMAIN:$PORT — site may be down, port closed, or no SSL installed."
  exit 1
fi
echo "$EXPIRY"
echo
ENDDATE=$(echo "$EXPIRY" | grep notAfter | cut -d= -f2)
if [ -n "$ENDDATE" ]; then
  END_EPOCH=$(date -d "$ENDDATE" +%s 2>/dev/null)
  NOW_EPOCH=$(date +%s)
  DAYS_LEFT=$(( (END_EPOCH - NOW_EPOCH) / 86400 ))
  echo "Days left: $DAYS_LEFT"
  if [ "$DAYS_LEFT" -lt 0 ]; then
    echo "STATUS: EXPIRED — renew / run AutoSSL in cPanel."
  elif [ "$DAYS_LEFT" -le 7 ]; then
    echo "STATUS: EXPIRING SOON — renew within a week."
  else
    echo "STATUS: OK"
  fi
fi
echo
echo "-- TLS version negotiated --"
echo | openssl s_client -servername "$DOMAIN" -connect "$DOMAIN:$PORT" 2>/dev/null | grep -i "Protocol" | head -n 1
