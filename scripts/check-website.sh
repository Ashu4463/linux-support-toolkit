#!/usr/bin/env bash
# check-website.sh — HTTP status, redirects & response time (read-only)
# Usage: ./check-website.sh https://example.com
set -u
URL="${1:-}"
if [ -z "$URL" ]; then
  echo "Usage: $0 <url>"
  echo "Example: $0 https://example.com"
  exit 1
fi

echo "== Website check: $URL =="
echo
echo "-- Final status & timing --"
curl -s -o /dev/null -w "HTTP code : %{http_code}\nTotal time: %{time_total}s\nSize      : %{size_download} bytes\n" -L --max-time 20 "$URL"
echo
echo "-- Redirect chain --"
curl -s -o /dev/null -w "%{http_code} %{url_effective}\n" -L --max-time 20 "$URL"
curl -s -I --max-time 20 "$URL" | grep -iE "^(HTTP|location|server|content-type|cache-control):" || true
echo
echo "-- Without www vs with www (quick A-record sanity) --"
HOST=$(echo "$URL" | sed -E 's#^https?://(www\.)?##; s#/.*##')
echo "Host: $HOST"
getent hosts "$HOST" || echo "  (host does not resolve — check DNS first)"
