#!/usr/bin/env bash
# ============================================================
# 📊 Family Copilot: Coverage badge ģenerēšana
#
# LV: Šis skripts aprēķina pārklājumu no lcov.info un ģenerē
#     shields.io badge URL, ko var izmantot README failā.
#
# EN: This script parses lcov.info and generates a shields.io
#     badge URL for use in the README file.
# ============================================================

LCOV_FILE="coverage/lcov.info"

if [[ ! -f "$LCOV_FILE" ]]; then
  echo "❌ coverage/lcov.info nav atrasts!"
  exit 1
fi

# Aprēķina pārklājumu
COVERAGE=$(grep -Po 'LF:\d+\nLH:\d+' "$LCOV_FILE" | paste -sd '\n' - | awk -F: '{lf+=$2; getline; lh+=$2} END {if (lf>0) printf "%.0f", (lh/lf)*100; else print 0}')

# Krāsa pēc pārklājuma
if (( COVERAGE >= 90 )); then
  COLOR="brightgreen"
elif (( COVERAGE >= 80 )); then
  COLOR="yellow"
else
  COLOR="red"
fi

# Ģenerē badge URL
BADGE_URL="https://img.shields.io/badge/coverage-${COVERAGE}%25-${COLOR}"

echo "✅ Coverage badge URL:"
echo "$BADGE_URL"