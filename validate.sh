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

# 4. Preview badge update (optional)
echo "🔍 Verifying badge update..."
BADGE_LINE=$(grep "coverage badge" README.md)
echo "📎 Badge line in README: $BADGE_LINE"

# 5. Summary
echo "✅ Validation complete — all checks passed!"
