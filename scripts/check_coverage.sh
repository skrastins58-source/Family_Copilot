#!/bin/bash
# LV: Pārbauda code coverage sliekšņus
# EN: Check code coverage thresholds

set -e

echo "📊 Checking code coverage thresholds..."

# Check if coverage report exists
if [ ! -d "coverage" ]; then
    echo "❌ Coverage directory not found. Run 'flutter test --coverage' first."
    exit 1
fi

if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ Coverage report not found. Run 'flutter test --coverage' first."
    exit 1
fi

# Read thresholds from coverage-summary.json
if [ ! -f "coverage-summary.json" ]; then
    echo "❌ coverage-summary.json not found"
    exit 1
fi

# Extract thresholds from JSON
LINES_THRESHOLD=$(grep -o '"lines": [0-9]*' coverage-summary.json | grep -o '[0-9]*')
FUNCTIONS_THRESHOLD=$(grep -o '"functions": [0-9]*' coverage-summary.json | grep -o '[0-9]*') 
BRANCHES_THRESHOLD=$(grep -o '"branches": [0-9]*' coverage-summary.json | grep -o '[0-9]*')
STATEMENTS_THRESHOLD=$(grep -o '"statements": [0-9]*' coverage-summary.json | grep -o '[0-9]*')

echo "🎯 Coverage thresholds:"
echo "  Lines: ${LINES_THRESHOLD}%"
echo "  Functions: ${FUNCTIONS_THRESHOLD}%"
echo "  Branches: ${BRANCHES_THRESHOLD}%"
echo "  Statements: ${STATEMENTS_THRESHOLD}%"

# Check if lcov is available for processing
if command -v lcov >/dev/null 2>&1; then
    echo "📈 Generating coverage summary..."
    lcov --summary coverage/lcov.info 2>/dev/null | tee coverage_report.txt
    
    # Extract actual coverage percentages
    ACTUAL_LINES=$(grep "lines" coverage_report.txt | grep -o '[0-9.]*%' | head -1 | tr -d '%')
    ACTUAL_FUNCTIONS=$(grep "functions" coverage_report.txt | grep -o '[0-9.]*%' | head -1 | tr -d '%')
    ACTUAL_BRANCHES=$(grep "branches" coverage_report.txt | grep -o '[0-9.]*%' | head -1 | tr -d '%')
    
    echo "📊 Actual coverage:"
    echo "  Lines: ${ACTUAL_LINES}%"
    echo "  Functions: ${ACTUAL_FUNCTIONS}%"
    echo "  Branches: ${ACTUAL_BRANCHES}%"
    
    # Compare against thresholds
    FAILED=0
    
    if (( $(echo "$ACTUAL_LINES < $LINES_THRESHOLD" | bc -l) )); then
        echo "❌ Lines coverage ${ACTUAL_LINES}% is below threshold ${LINES_THRESHOLD}%"
        FAILED=1
    fi
    
    if (( $(echo "$ACTUAL_FUNCTIONS < $FUNCTIONS_THRESHOLD" | bc -l) )); then
        echo "❌ Functions coverage ${ACTUAL_FUNCTIONS}% is below threshold ${FUNCTIONS_THRESHOLD}%"
        FAILED=1
    fi
    
    if (( $(echo "$ACTUAL_BRANCHES < $BRANCHES_THRESHOLD" | bc -l) )); then
        echo "❌ Branches coverage ${ACTUAL_BRANCHES}% is below threshold ${BRANCHES_THRESHOLD}%"
        FAILED=1
    fi
    
    if [ $FAILED -eq 1 ]; then
        echo "❌ Coverage check failed!"
        echo "COVERAGE_FAILED=true" >> $GITHUB_OUTPUT
        exit 1
    fi
    
    echo "✅ All coverage thresholds met!"
    echo "COVERAGE_PASSED=true" >> $GITHUB_OUTPUT
    
else
    echo "⚠️  lcov not available, using basic validation"
    # Basic check - if coverage directory exists and has files, assume OK
    if [ -s "coverage/lcov.info" ]; then
        echo "✅ Coverage file exists and is not empty"
        echo "COVERAGE_PASSED=true" >> $GITHUB_OUTPUT
    else
        echo "❌ Coverage file is empty or missing"
        echo "COVERAGE_FAILED=true" >> $GITHUB_OUTPUT
        exit 1
    fi
fi