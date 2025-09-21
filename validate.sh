#!/usr/bin/env bash
set -e

echo "🔍 Family Copilot Validation Script"
echo "==================================="

# 1. Run Flutter tests with coverage
echo "🧪 Running Flutter tests..."
flutter test --coverage || { echo "❌ Tests failed"; exit 1; }

# 2. Enforce coverage threshold
echo "📊 Checking coverage thresholds..."
bash ./scripts/check_coverage.sh || { echo "❌ Coverage check failed"; exit 1; }

# 3. Validate golden test structure
echo "🖼️ Validating golden test structure..."
bash ./scripts/validate_golden_structure.sh || { echo "❌ Golden test structure validation failed"; exit 1; }

# 4. Preview badge update (optional)
echo "🔍 Verifying badge update..."
BADGE_LINE=$(grep "coverage badge" README.md || echo "⚠️ No badge line found")
echo "📎 Badge line in README: $BADGE_LINE"

# 5. Summary
echo "✅ Validation complete — all checks passed!"
