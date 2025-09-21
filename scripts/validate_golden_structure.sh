#!/usr/bin/env bash

# =============================================================================
# 📁 Golden Direktorijas Struktūras Validācijas Skripts / Golden Structure Validation Script  
# =============================================================================
# 
# Latviešu: Pārbauda vai goldens/ direktorijā ir tikai .png faili
# English: Validates that goldens/ directory contains only .png files
#
# Lietošana / Usage:
#   ./validate_golden_structure.sh
#
# Prasības / Requirements:
#   - find komanda (standarta Unix utilīta)
#   - goldens/ direktorija eksistē
#
# Autors / Author: Family Copilot Team
# =============================================================================

if find goldens/ -type f ! -name "*.png" 2>/dev/null | grep .; then
  echo "❌ goldens/ direktorijā drīkst būt tikai .png faili!"
  echo "❌ Only .png files are allowed in goldens/ directory!"
  exit 1
fi

echo "✅ goldens/ struktūra ir korekta."
echo "✅ goldens/ structure is correct."
