#!/usr/bin/env bash

# =============================================================================
# 🖼️ Golden Attēlu Salīdzināšanas Skripts / Golden Image Diff Check Script
# =============================================================================
# 
# Latviešu: Pārbauda vai golden attēli atšķiras no galvenās zara versijas
# English: Checks if golden images differ from main branch version
#
# Lietošana / Usage:
#   ./check_golden_diff.sh <default_branch>
#   ./check_golden_diff.sh main
#
# Prasības / Requirements:
#   - git instalēts un konfigurēts
#   - Piekļuve galvenajam zaram
#
# Autors / Author: Family Copilot Team
# =============================================================================

set -e

DEFAULT_BRANCH=$1

if [ -z "$DEFAULT_BRANCH" ]; then
  echo "Lietošana / Usage: $0 <default_branch>"
  echo "Piemērs / Example: $0 main"
  exit 1
fi

# Pārbauda, vai goldens ir mainījies salīdzinot ar origin/<default_branch>
git diff --exit-code origin/$DEFAULT_BRANCH -- goldens/ \
  || (echo "❌ Golden attēli atšķiras no origin/${DEFAULT_BRANCH} versijas!" && exit 1)

echo "✅ Golden attēli sakrīt ar origin/${DEFAULT_BRANCH}!"
