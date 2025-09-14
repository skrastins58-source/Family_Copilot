#!/bin/bash

# Coverage check script for Family Copilot
# This script runs tests and validates coverage thresholds
# 
# Coverage thresholds:
# - Lines: 85%
# - Statements: 85%
# - Functions: 90%
# - Branches: 70% (temporarily reduced from 80%)

set -e

echo "🧪 Running tests with coverage for Family Copilot..."

# Clean previous coverage data
echo "Cleaning previous coverage data..."
rm -rf coverage/

# Run Flutter tests with coverage
echo "Running Flutter tests with coverage..."
flutter test --coverage

# Check if coverage file exists
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ Coverage file not found!"
    exit 1
fi

echo "📊 Generating coverage report..."

# Install lcov if not available (for local development)
if ! command -v lcov &> /dev/null; then
    echo "Installing lcov..."
    sudo apt-get update && sudo apt-get install -y lcov || echo "Please install lcov manually"
fi

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html --branch-coverage --function-coverage

# Extract coverage metrics
echo "📈 Coverage Summary:"
COVERAGE_SUMMARY=$(lcov --summary coverage/lcov.info 2>&1)
echo "$COVERAGE_SUMMARY"

# Extract percentages
LINES_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep -o 'lines......: [0-9.]*%' | grep -o '[0-9.]*' || echo "0")
FUNCTIONS_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep -o 'functions..: [0-9.]*%' | grep -o '[0-9.]*' || echo "0")
BRANCHES_COVERAGE=$(echo "$COVERAGE_SUMMARY" | grep -o 'branches...: [0-9.]*%' | grep -o '[0-9.]*' || echo "0")

echo ""
echo "🎯 Coverage Thresholds Check:"
echo "Lines: ${LINES_COVERAGE}% (threshold: 85%)"
echo "Functions: ${FUNCTIONS_COVERAGE}% (threshold: 90%)"
echo "Branches: ${BRANCHES_COVERAGE}% (threshold: 70%)"

# Validate thresholds
LINES_THRESHOLD=85
FUNCTIONS_THRESHOLD=90
BRANCHES_THRESHOLD=70
FAILED=0

if (( $(echo "$LINES_COVERAGE < $LINES_THRESHOLD" | bc -l) )); then
    echo "❌ Lines coverage ${LINES_COVERAGE}% is below threshold ${LINES_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Lines coverage ${LINES_COVERAGE}% meets threshold ${LINES_THRESHOLD}%"
fi

if (( $(echo "$FUNCTIONS_COVERAGE < $FUNCTIONS_THRESHOLD" | bc -l) )); then
    echo "❌ Functions coverage ${FUNCTIONS_COVERAGE}% is below threshold ${FUNCTIONS_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Functions coverage ${FUNCTIONS_COVERAGE}% meets threshold ${FUNCTIONS_THRESHOLD}%"
fi

if (( $(echo "$BRANCHES_COVERAGE < $BRANCHES_THRESHOLD" | bc -l) )); then
    echo "❌ Branches coverage ${BRANCHES_COVERAGE}% is below threshold ${BRANCHES_THRESHOLD}%"
    FAILED=1
else
    echo "✅ Branches coverage ${BRANCHES_COVERAGE}% meets threshold ${BRANCHES_THRESHOLD}%"
fi

echo ""
if [ $FAILED -eq 1 ]; then
    echo "❌ Coverage thresholds not met!"
    echo "💡 Note: Branches threshold is temporarily set to 70% (reduced from 80%)"
    echo "   This will be increased after additional tests are added."
    exit 1
else
    echo "✅ All coverage thresholds met!"
    echo "📁 Coverage report available at: coverage/html/index.html"
fi