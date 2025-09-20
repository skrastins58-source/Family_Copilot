#!/bin/bash

echo "🔄 Starting validation..."

# 1. Clean previous coverage data
echo "🧹 Cleaning coverage artifacts..."
rm -rf coverage/ lcov.info

# 2. Run tests with coverage
echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage || { echo "❌ Tests failed"; exit 1; }

# 3. Enforce coverage thresholds
echo "📊 Checking coverage thresholds..."
bash ./scripts/check_coverage.sh || { echo "❌ Coverage check failed"; exit 1; }

# 4. Validate golden test structure
echo "🖼️ Validating golden test structure..."
bash ./scripts/validate_golden_structure.sh || { echo "❌ Golden test structure validation failed"; exit 1; }

# 5. Preview badge update (optional)
echo "🔍 Verifying badge update..."
BADGE_LINE=$(grep "coverage badge" README.md)
echo "📎 Badge line in README: $BADGE_LINE"

# 6. Summary
echo "✅ Validation complete — all checks passed!"
