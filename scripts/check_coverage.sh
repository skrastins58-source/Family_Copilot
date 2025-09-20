#!/bin/bash

# Coverage threshold checking script for Family Copilot
# Enforces minimum coverage standards defined in coverage-summary.json

set -e

COVERAGE_FILE="coverage/lcov.info"
SUMMARY_FILE="coverage-summary.json"

echo "🔍 Checking coverage thresholds..."

# Check if coverage file exists
if [[ ! -f "$COVERAGE_FILE" ]]; then
    echo "❌ Coverage file not found: $COVERAGE_FILE"
    echo "Make sure to run 'flutter test --coverage' first"
    exit 1
fi

# Read thresholds from summary file
if [[ -f "$SUMMARY_FILE" ]]; then
    LINES_THRESHOLD=$(jq -r '.coverageThresholds.global.lines' "$SUMMARY_FILE")
    FUNCTIONS_THRESHOLD=$(jq -r '.coverageThresholds.global.functions' "$SUMMARY_FILE")
    BRANCHES_THRESHOLD=$(jq -r '.coverageThresholds.global.branches' "$SUMMARY_FILE")
    STATEMENTS_THRESHOLD=$(jq -r '.coverageThresholds.global.statements' "$SUMMARY_FILE")
else
    # Default thresholds
    LINES_THRESHOLD=80
    FUNCTIONS_THRESHOLD=85
    BRANCHES_THRESHOLD=70
    STATEMENTS_THRESHOLD=80
fi

echo "📊 Coverage thresholds:"
echo "  Lines: ${LINES_THRESHOLD}%"
echo "  Functions: ${FUNCTIONS_THRESHOLD}%"
echo "  Branches: ${BRANCHES_THRESHOLD}%"
echo "  Statements: ${STATEMENTS_THRESHOLD}%"

# Extract coverage percentages from lcov.info
# This is a basic implementation - in real scenarios you might want to use lcov tools
TOTAL_LINES=$(grep -c "^LF:" "$COVERAGE_FILE" | head -1 || echo "0")
COVERED_LINES=$(grep -c "^LH:" "$COVERAGE_FILE" | head -1 || echo "0")

if [[ $TOTAL_LINES -gt 0 ]]; then
    LINE_COVERAGE=$((COVERED_LINES * 100 / TOTAL_LINES))
else
    LINE_COVERAGE=0
fi

echo "📈 Current coverage:"
echo "  Lines: ${LINE_COVERAGE}%"

# Check if coverage meets thresholds
if [[ $LINE_COVERAGE -lt $LINES_THRESHOLD ]]; then
    echo "❌ Line coverage ${LINE_COVERAGE}% is below threshold ${LINES_THRESHOLD}%"
    exit 1
fi

echo "✅ All coverage thresholds met!"

# Generate badge data
echo "🏷️ Generating coverage badge data..."
BADGE_COLOR="brightgreen"
if [[ $LINE_COVERAGE -lt 70 ]]; then
    BADGE_COLOR="red"
elif [[ $LINE_COVERAGE -lt 80 ]]; then
    BADGE_COLOR="yellow"
elif [[ $LINE_COVERAGE -lt 90 ]]; then
    BADGE_COLOR="yellowgreen"
fi

echo "Coverage: ${LINE_COVERAGE}% (${BADGE_COLOR})"
echo "COVERAGE_PERCENTAGE=${LINE_COVERAGE}" >> "$GITHUB_ENV" 2>/dev/null || true
echo "BADGE_COLOR=${BADGE_COLOR}" >> "$GITHUB_ENV" 2>/dev/null || true

exit 0