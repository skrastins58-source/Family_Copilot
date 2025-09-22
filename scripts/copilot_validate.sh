#!/usr/bin/env bash
# ============================================================
# 🧪 Family Copilot: Validācijas CLI rīks
#
# LV: Apvieno golden testu, coverage, struktūras un SEO validāciju
# EN: Combines golden test, coverage, structure and SEO validation
# ============================================================

set -e

echo "🔍 Validating golden test structure..."
bash scripts/validate_golden_structure.sh

echo "📊 Calculating coverage badge..."
bash scripts/coverage_badge.sh

echo "🌐 Validating landing.html accessibility..."
npx htmlhint landing.html

echo "✅ All validations completed successfully."
