#!/bin/bash

# Coverage badge generator script
# Generates a coverage badge endpoint JSON file

LCOV_FILE="coverage/lcov.info"
BADGE_FILE="coverage/coverage-badge.json"

echo "🏷️ Generating coverage badge..."

# Ensure coverage directory exists
mkdir -p coverage

# Check if lcov.info exists
if [ ! -f "$LCOV_FILE" ]; then
    echo "⚠️ Warning: $LCOV_FILE not found. Creating default badge."
    # Create default badge
    echo '{"schemaVersion": 1, "label": "coverage", "message": "unknown", "color": "lightgrey"}' > "$BADGE_FILE"
    exit 0
fi

# Extract line coverage
LINES_FOUND=$(grep -E '^LF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
LINES_HIT=$(grep -E '^LH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

# Calculate percentage
if [ "$LINES_FOUND" -gt 0 ]; then
    LINE_COVERAGE=$(echo "scale=1; ($LINES_HIT * 100) / $LINES_FOUND" | bc)
else
    LINE_COVERAGE=0
fi

# Determine badge color based on coverage percentage
BADGE_COLOR="red"
if (( $(echo "$LINE_COVERAGE >= 90" | bc -l) )); then
    BADGE_COLOR="brightgreen"
elif (( $(echo "$LINE_COVERAGE >= 80" | bc -l) )); then
    BADGE_COLOR="green" 
elif (( $(echo "$LINE_COVERAGE >= 70" | bc -l) )); then
    BADGE_COLOR="yellowgreen"
elif (( $(echo "$LINE_COVERAGE >= 60" | bc -l) )); then
    BADGE_COLOR="yellow"
elif (( $(echo "$LINE_COVERAGE >= 40" | bc -l) )); then
    BADGE_COLOR="orange"
fi

# Generate badge JSON
cat > "$BADGE_FILE" << EOF
{
  "schemaVersion": 1,
  "label": "coverage",
  "message": "${LINE_COVERAGE}%",
  "color": "${BADGE_COLOR}"
}
EOF

echo "✅ Coverage badge generated: ${LINE_COVERAGE}% (${BADGE_COLOR})"
echo "📋 Badge file: $BADGE_FILE"