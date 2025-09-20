#!/bin/bash

# Coverage threshold check script for Flutter project
# This script reads lcov.info and enforces coverage thresholds

LCOV_FILE="coverage/lcov.info"
COVERAGE_SUMMARY_FILE="coverage-summary.json"

echo "📊 Checking coverage thresholds..."

# Check if lcov.info exists
if [ ! -f "$LCOV_FILE" ]; then
    echo "❌ Error: Coverage file $LCOV_FILE not found."
    echo "   Please run 'flutter test --coverage' first."
    exit 1
fi

# Parse lcov.info to extract coverage data
echo "📈 Parsing coverage data from $LCOV_FILE..."

# Extract line coverage
LINES_FOUND=$(grep -E '^LF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
LINES_HIT=$(grep -E '^LH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

# Extract function coverage  
FUNCTIONS_FOUND=$(grep -E '^FNF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
FUNCTIONS_HIT=$(grep -E '^FNH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

# Extract branch coverage
BRANCHES_FOUND=$(grep -E '^BRF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
BRANCHES_HIT=$(grep -E '^BRH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

# Calculate percentages
if [ "$LINES_FOUND" -gt 0 ]; then
    LINE_COVERAGE=$(echo "scale=2; ($LINES_HIT * 100) / $LINES_FOUND" | bc)
else
    LINE_COVERAGE=0
fi

if [ "$FUNCTIONS_FOUND" -gt 0 ]; then
    FUNCTION_COVERAGE=$(echo "scale=2; ($FUNCTIONS_HIT * 100) / $FUNCTIONS_FOUND" | bc)
else
    FUNCTION_COVERAGE=0
fi

if [ "$BRANCHES_FOUND" -gt 0 ]; then
    BRANCH_COVERAGE=$(echo "scale=2; ($BRANCHES_HIT * 100) / $BRANCHES_FOUND" | bc)
else
    BRANCH_COVERAGE=0
fi

# Read thresholds from coverage-summary.json
LINE_THRESHOLD=$(grep -o '"lines": [0-9]*' "$COVERAGE_SUMMARY_FILE" | grep -o '[0-9]*' | tail -1)
FUNCTION_THRESHOLD=$(grep -o '"functions": [0-9]*' "$COVERAGE_SUMMARY_FILE" | grep -o '[0-9]*' | tail -1)
BRANCH_THRESHOLD=$(grep -o '"branches": [0-9]*' "$COVERAGE_SUMMARY_FILE" | grep -o '[0-9]*' | tail -1)

echo "📊 Coverage Results:"
echo "-------------------"
echo "Lines:     ${LINE_COVERAGE}% (threshold: ${LINE_THRESHOLD}%)"
echo "Functions: ${FUNCTION_COVERAGE}% (threshold: ${FUNCTION_THRESHOLD}%)"
echo "Branches:  ${BRANCH_COVERAGE}% (threshold: ${BRANCH_THRESHOLD}%)"

# Check thresholds
FAILED=0

if (( $(echo "$LINE_COVERAGE < $LINE_THRESHOLD" | bc -l) )); then
    echo "❌ Line coverage ${LINE_COVERAGE}% is below threshold ${LINE_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Line coverage ${LINE_COVERAGE}% meets threshold ${LINE_THRESHOLD}%"
fi

if (( $(echo "$FUNCTION_COVERAGE < $FUNCTION_THRESHOLD" | bc -l) )); then
    echo "❌ Function coverage ${FUNCTION_COVERAGE}% is below threshold ${FUNCTION_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Function coverage ${FUNCTION_COVERAGE}% meets threshold ${FUNCTION_THRESHOLD}%"
fi

if (( $(echo "$BRANCH_COVERAGE < $BRANCH_THRESHOLD" | bc -l) )); then
    echo "❌ Branch coverage ${BRANCH_COVERAGE}% is below threshold ${BRANCH_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Branch coverage ${BRANCH_COVERAGE}% meets threshold ${BRANCH_THRESHOLD}%"
fi

# Generate coverage badge data
BADGE_COLOR="red"
if (( $(echo "$LINE_COVERAGE >= 80" | bc -l) )); then
    BADGE_COLOR="green"
elif (( $(echo "$LINE_COVERAGE >= 60" | bc -l) )); then
    BADGE_COLOR="yellow"
fi

# Create coverage badge info file
echo "{\"schemaVersion\": 1, \"label\": \"coverage\", \"message\": \"${LINE_COVERAGE}%\", \"color\": \"${BADGE_COLOR}\"}" > coverage/coverage-badge.json

echo ""
if [ $FAILED -eq 1 ]; then
    echo "❌ Coverage checks failed!"
    exit 1
else
    echo "✅ All coverage thresholds met!"
    echo "📋 Coverage badge data generated: coverage/coverage-badge.json"
fi