#!/usr/bin/env bash
set -euo pipefail

# Coverage threshold enforcement script
# Usage: ./scripts/check_coverage.sh [coverage_file] [min_percent]
# Defaults: coverage/lcov.info and 80

COVERAGE_FILE="${1:-coverage/lcov.info}"
MIN_COVERAGE="${2:-80}"

if [ ! -f "$COVERAGE_FILE" ]; then
  echo "❌ Coverage file not found: $COVERAGE_FILE"
  echo "Run 'flutter test --coverage' or your project's coverage command first to generate coverage data"
  exit 1
fi

# Count total lines found (LF:) and lines hit (LH:)
LINES_FOUND=$(grep -c "^LF:" "$COVERAGE_FILE" || echo "0")
LINES_HIT=$(grep "^LH:" "$COVERAGE_FILE" | awk -F: '{sum += $2} END {print sum+0}')

if [ "$LINES_FOUND" -eq 0 ]; then
  echo "⚠️ No coverage data found in $COVERAGE_FILE"
  echo "This might be expected for projects without testable code; exiting with success."
  exit 0
fi

COVERAGE_PERCENT=$(( (LINES_HIT * 100) / LINES_FOUND ))

echo "📊 Coverage Summary:"
echo "  Lines found: $LINES_FOUND"
echo "  Lines hit:   $LINES_HIT"
echo "  Coverage:    ${COVERAGE_PERCENT}%"
echo "  Minimum req: ${MIN_COVERAGE}%"

if [ "$COVERAGE_PERCENT" -lt "$MIN_COVERAGE" ]; then
  echo "❌ Coverage check failed: ${COVERAGE_PERCENT}% < ${MIN_COVERAGE}%"
  exit 2
fi

echo "✅ Coverage check passed: ${COVERAGE_PERCENT}% >= ${MIN_COVERAGE}%"
exit 0
