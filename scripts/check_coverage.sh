#!/usr/bin/env bash

# Coverage threshold enforcement script
# Checks that code coverage meets minimum requirements

set -e

COVERAGE_FILE="coverage/lcov.info"
MIN_COVERAGE=80

if [ ! -f "$COVERAGE_FILE" ]; then
  echo "❌ Coverage file not found: $COVERAGE_FILE"
  echo "Run 'flutter test --coverage' first to generate coverage data"
  exit 1
fi

# Extract coverage percentage from lcov.info
# This is a simple approach - in production you might want to use lcov tools
LINES_FOUND=$(grep -c "^LF:" "$COVERAGE_FILE" || echo "0")
LINES_HIT=$(grep "^LH:" "$COVERAGE_FILE" | awk -F: '{sum += $2} END {print sum+0}')

if [ "$LINES_FOUND" -eq 0 ]; then
  echo "⚠️ No coverage data found in $COVERAGE_FILE"
  echo "This might be expected for projects without testable code"
  exit 0
fi

COVERAGE_PERCENT=$(( (LINES_HIT * 100) / LINES_FOUND ))

echo "📊 Coverage Summary:"
echo "   Lines found: $LINES_FOUND"
echo "   Lines hit: $LINES_HIT"
echo "   Coverage: ${COVERAGE_PERCENT}%"
echo "   Minimum required: ${MIN_COVERAGE}%"

if [ "$COVERAGE_PERCENT" -ge "$MIN_COVERAGE" ]; then
  echo "✅ Coverage check passed (${COVERAGE_PERCENT}% >= ${MIN_COVERAGE}%)"
  
  # Update coverage summary file if it exists
  if [ -f "coverage-summary.json" ]; then
    echo "{\"coverage\": ${COVERAGE_PERCENT}, \"threshold\": ${MIN_COVERAGE}, \"status\": \"passed\"}" > coverage-summary.json
  fi
  
  exit 0
else
  echo "❌ Coverage check failed (${COVERAGE_PERCENT}% < ${MIN_COVERAGE}%)"
  echo "Please add more tests to improve coverage"
  
  # Update coverage summary file if it exists
  if [ -f "coverage-summary.json" ]; then
    echo "{\"coverage\": ${COVERAGE_PERCENT}, \"threshold\": ${MIN_COVERAGE}, \"status\": \"failed\"}" > coverage-summary.json
  fi
  
  exit 1
fi