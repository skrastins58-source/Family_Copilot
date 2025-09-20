#!/bin/bash

# PR Coverage Comment Generator
# Generates a comment with coverage information for PRs

LCOV_FILE="coverage/lcov.info"
BADGE_FILE="coverage/coverage-badge.json"

if [ ! -f "$LCOV_FILE" ]; then
    echo "⚠️ Coverage data not available"
    exit 0
fi

# Extract coverage data
LINES_FOUND=$(grep -E '^LF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
LINES_HIT=$(grep -E '^LH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
FUNCTIONS_FOUND=$(grep -E '^FNF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
FUNCTIONS_HIT=$(grep -E '^FNH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
BRANCHES_FOUND=$(grep -E '^BRF:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')
BRANCHES_HIT=$(grep -E '^BRH:' "$LCOV_FILE" | cut -d: -f2 | awk '{sum += $1} END {print sum}')

# Calculate percentages
LINE_COVERAGE=$(echo "scale=1; ($LINES_HIT * 100) / $LINES_FOUND" | bc 2>/dev/null || echo "0")
FUNCTION_COVERAGE=$(echo "scale=1; ($FUNCTIONS_HIT * 100) / $FUNCTIONS_FOUND" | bc 2>/dev/null || echo "0")
BRANCH_COVERAGE=$(echo "scale=1; ($BRANCHES_HIT * 100) / $BRANCHES_FOUND" | bc 2>/dev/null || echo "0")

# Generate emoji based on coverage
get_emoji() {
    local coverage=$1
    if (( $(echo "$coverage >= 90" | bc -l) )); then
        echo "🟢"
    elif (( $(echo "$coverage >= 80" | bc -l) )); then
        echo "🟡"
    else
        echo "🔴"
    fi
}

LINE_EMOJI=$(get_emoji "$LINE_COVERAGE")
FUNCTION_EMOJI=$(get_emoji "$FUNCTION_COVERAGE")
BRANCH_EMOJI=$(get_emoji "$BRANCH_COVERAGE")

# Create PR comment
cat << EOF
## 📊 Coverage Report

| Type | Coverage | Status |
|------|----------|--------|
| **Lines** | ${LINE_COVERAGE}% | ${LINE_EMOJI} |
| **Functions** | ${FUNCTION_COVERAGE}% | ${FUNCTION_EMOJI} |
| **Branches** | ${BRANCH_COVERAGE}% | ${BRANCH_EMOJI} |

### Coverage Details
- **Total Lines**: ${LINES_HIT}/${LINES_FOUND}
- **Total Functions**: ${FUNCTIONS_HIT}/${FUNCTIONS_FOUND}
- **Total Branches**: ${BRANCHES_HIT}/${BRANCHES_FOUND}

---
*Coverage badge will be automatically updated when merged to main branch.*
EOF