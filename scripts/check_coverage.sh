#!/bin/bash

# Coverage Threshold Checker Script
# Validates that code coverage meets minimum requirements
# Part of Family Copilot CI/CD quality assurance

echo "📊 Coverage Threshold Validation"
echo "================================"

# Exit on any error
set -e

# Configuration
COVERAGE_DIR="coverage"
LCOV_FILE="coverage/lcov.info"
COVERAGE_CONFIG="coverage-summary.json"
MIN_COVERAGE=80
EXIT_CODE=0

# Try to read minimum coverage from configuration file
if [ -f "$COVERAGE_CONFIG" ]; then
    # Extract branches threshold from JSON (fallback to lines if branches not found)
    CONFIG_THRESHOLD=$(grep -o '"branches":[[:space:]]*[0-9]*' "$COVERAGE_CONFIG" | head -1 | grep -o '[0-9]*' || echo "")
    if [ -n "$CONFIG_THRESHOLD" ]; then
        MIN_COVERAGE=$CONFIG_THRESHOLD
        echo "📄 Using coverage threshold from $COVERAGE_CONFIG: ${MIN_COVERAGE}%"
    fi
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log errors
log_error() {
    echo -e "${RED}❌ $1${NC}"
    EXIT_CODE=1
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Check if coverage directory exists
if [ ! -d "$COVERAGE_DIR" ]; then
    log_error "Coverage directory '$COVERAGE_DIR' not found. Run 'flutter test --coverage' first."
    exit 1
fi

# Check if lcov.info exists
if [ ! -f "$LCOV_FILE" ]; then
    log_error "Coverage file '$LCOV_FILE' not found. Run 'flutter test --coverage' first."
    exit 1
fi

echo "📁 Coverage files found:"
echo "  - Directory: $COVERAGE_DIR"
echo "  - LCOV file: $LCOV_FILE"

# Extract coverage data using basic text processing
echo ""
echo "🔍 Analyzing coverage data..."

# Count total lines and covered lines
TOTAL_LINES=$(grep -c "^LF:" "$LCOV_FILE" 2>/dev/null || echo "0")
COVERED_LINES=$(grep -c "^LH:" "$LCOV_FILE" 2>/dev/null || echo "0")

if [ "$TOTAL_LINES" -eq 0 ]; then
    log_warning "No coverage data found in $LCOV_FILE"
    echo "This might be expected if there are no testable lines in the codebase."
    exit 0
fi

# Calculate coverage percentage (using basic bash arithmetic)
if [ "$TOTAL_LINES" -gt 0 ]; then
    # Use awk for more accurate percentage calculation
    COVERAGE_PERCENT=$(awk -v covered="$COVERED_LINES" -v total="$TOTAL_LINES" 'BEGIN {printf "%.1f", (covered/total)*100}')
else
    COVERAGE_PERCENT=0
fi

echo "📈 Coverage Statistics:"
echo "  - Total lines: $TOTAL_LINES"
echo "  - Covered lines: $COVERED_LINES"
echo "  - Coverage: ${COVERAGE_PERCENT}%"
echo "  - Minimum required: ${MIN_COVERAGE}%"

# Check if coverage meets threshold
echo ""
echo "✅ Checking coverage threshold..."

# Compare coverage with threshold (using awk for floating point comparison)
MEETS_THRESHOLD=$(awk -v coverage="$COVERAGE_PERCENT" -v min="$MIN_COVERAGE" 'BEGIN {print (coverage >= min) ? "yes" : "no"}')

if [ "$MEETS_THRESHOLD" = "yes" ]; then
    log_success "Coverage ${COVERAGE_PERCENT}% meets minimum requirement of ${MIN_COVERAGE}%"
else
    log_error "Coverage ${COVERAGE_PERCENT}% is below minimum requirement of ${MIN_COVERAGE}%"
fi

# Provide additional insights
echo ""
echo "📋 Coverage Report Summary:"
if [ -f "$COVERAGE_DIR/html/index.html" ]; then
    log_success "HTML coverage report available at: $COVERAGE_DIR/html/index.html"
fi

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="
if [ $EXIT_CODE -eq 0 ]; then
    log_success "Coverage validation passed!"
else
    echo ""
    log_error "Coverage validation failed!"
    echo ""
    echo "💡 To improve coverage:"
    echo "  - Add more unit tests for uncovered code"
    echo "  - Add widget tests for UI components" 
    echo "  - Remove unused or dead code"
    echo "  - Consider integration tests for complex workflows"
fi

exit $EXIT_CODE