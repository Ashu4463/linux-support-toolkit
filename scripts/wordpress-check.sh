#!/usr/bin/env bash
# wordpress-check.sh — WordPress health check (read-only)
# Run as the site's cPanel account user. NEVER as root, never with --allow-root.
# Usage: ./wordpress-check.sh /home/username/public_html
set -u
PATH_DIR="${1:-}"
if [ -z "$PATH_DIR" ]; then
  echo "Usage: $0 <path-to-wordpress>"
  echo "Example: $0 /home/username/public_html"
  exit 1
fi
if [ "$(id -u)" -eq 0 ]; then
  echo "Do NOT run this as root. Switch to the site owner first, e.g.: su - username -c \"$0 $PATH_DIR\""
  exit 1
fi

echo "== WordPress check: $PATH_DIR =="
cd "$PATH_DIR" || { echo "Cannot enter $PATH_DIR"; exit 1; }
echo
for f in wp-config.php index.php .htaccess wp-content/debug.log; do
  if [ -e "$f" ]; then echo "  [OK] $f exists"; else echo "  [--] $f missing"; fi
done
echo
if command -v wp >/dev/null 2>&1; then
  echo "-- WP-CLI core --"
  wp core version 2>&1 | head -n 2
  echo
  echo "-- Plugins (update available?) --"
  wp plugin list --update=available 2>&1 | head -n 10
  echo
  echo "-- Database check --"
  wp db check 2>&1 | tail -n 5
else
  echo "wp-cli not found in PATH — install it for the site user, or check plugins via wp-admin."
fi
echo
echo "-- Uploads writable? --"
[ -w wp-content/uploads ] && echo "  [OK] wp-content/uploads writable" || echo "  [--] wp-content/uploads NOT writable"
echo
echo "-- debug.log tail (last 10 lines, if present) --"
tail -n 10 wp-content/debug.log 2>/dev/null || echo "  (no debug.log)"
