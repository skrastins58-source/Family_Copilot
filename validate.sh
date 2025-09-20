#!/bin/bash

echo "🔄 Starting validation..."

# 1. Clean previous coverage data
echo "🧹 Cleaning coverage artifacts..."
rm -rf coverage/ lcov.info

# 2. Run tests with coverage
echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage || { echo "❌ Tests failed"; exit 1; }

# 3. Generate coverage badge
echo "🏷️ Generating coverage badge..."
bash ./scripts/generate_coverage_badge.sh || { echo "❌ Badge generation failed"; exit 1; }

# 4. Enforce coverage thresholds
echo "📊 Checking coverage thresholds..."
bash ./scripts/check_coverage.sh || { echo "❌ Coverage check failed"; exit 1; }

# 5. Preview badge update (optional)
echo "🔍 Verifying badge update..."
if [ -f "coverage/coverage-badge.json" ]; then
    BADGE_MESSAGE=$(grep -o '"message": "[^"]*"' coverage/coverage-badge.json | cut -d'"' -f4)
    echo "📎 Coverage badge: $BADGE_MESSAGE"
else
    echo "⚠️ Coverage badge file not found"
fi

# 6. Summary
echo "✅ Validation complete — all checks passed!"
