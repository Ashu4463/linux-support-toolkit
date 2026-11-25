#!/usr/bin/env bash
# server-health.sh — load, memory, disk, inodes & failed services (read-only)
# Usage: ./server-health.sh
set -u
echo "== Server health: $(hostname) — $(date) =="
echo
echo "-- Load & uptime --"
uptime
echo
echo "-- Memory --"
free -h
echo
echo "-- Disk usage --"
df -hT | grep -vE "tmpfs|loop"
echo
echo "-- Inodes (a full disk can hide here) --"
df -i | grep -vE "tmpfs|loop"
echo
echo "-- Top 5 disk users under /home --"
du -sh /home/* 2>/dev/null | sort -rh | head -n 5 || echo "  (no /home access)"
echo
echo "-- Failed services --"
systemctl --failed --no-pager 2>/dev/null || echo "  (systemctl not available)"
echo
echo "-- Top processes by memory --"
ps aux --sort=-%mem | head -n 6
