#!/bin/bash
# PR Comment Automation Script for Family Copilot
# Aggregates LHCI, Bundle size, and Golden diff results
# Publishes automated comment with emoji status and artifact links

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🚀 Family Copilot PR Quality Report Generator"
echo "============================================="

# Initialize variables
LHCI_SCORE=""
LHCI_STATUS=""
BUNDLE_SIZE=""
BUNDLE_DELTA=""
GOLDEN_DIFF=""
COVERAGE_DELTA=""
ARTIFACTS_BASE_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"

# Function to get emoji status based on score
get_status_emoji() {
    local score=$1
    local threshold=$2
    local comparison=${3:-"ge"} # ge = greater or equal, le = less or equal
    
    if [[ "$comparison" == "ge" ]]; then
        if (( $(echo "$score >= $threshold" | bc -l) )); then
            echo "✅"
        else
            echo "❌"
        fi
    else
        if (( $(echo "$score <= $threshold" | bc -l) )); then
            echo "✅"
        else
            echo "❌"
        fi
    fi
}

# Function to parse LHCI results
parse_lhci_results() {
    echo "📊 Parsing LHCI results..."
    
    if [[ -f "lhci_report.json" ]]; then
        # Extract key metrics from LHCI report
        local fcp=$(jq -r '.audits["first-contentful-paint"].numericValue // 0' lhci_report.json)
        local tti=$(jq -r '.audits["interactive"].numericValue // 0' lhci_report.json)
        local accessibility=$(jq -r '.categories.accessibility.score // 0' lhci_report.json)
        local seo=$(jq -r '.categories.seo.score // 0' lhci_report.json)
        
        # Convert scores and get status
        local fcp_ms=$(echo "$fcp" | awk '{print int($1)}')
        local tti_ms=$(echo "$tti" | awk '{print int($1)}')
        local acc_score=$(echo "$accessibility * 100" | bc)
        local seo_score=$(echo "$seo * 100" | bc)
        
        # Get status emojis
        local fcp_emoji=$(get_status_emoji $fcp_ms 2000 "le")
        local tti_emoji=$(get_status_emoji $tti_ms 3000 "le")
        local acc_emoji=$(get_status_emoji $acc_score 90 "ge")
        local seo_emoji=$(get_status_emoji $seo_score 90 "ge")
        
        LHCI_STATUS="| 🏎️ FCP | ${fcp_ms}ms | $fcp_emoji |
| ⚡ TTI | ${tti_ms}ms | $tti_emoji |
| ♿ Accessibility | ${acc_score}% | $acc_emoji |
| 🔍 SEO | ${seo_score}% | $seo_emoji |"
    else
        LHCI_STATUS="| ⚠️ LHCI | No report found | ❌ |"
    fi
}

# Function to analyze bundle size
analyze_bundle_size() {
    echo "📦 Analyzing bundle size..."
    
    if [[ -f "build/web/main.dart.js" ]]; then
        local current_size=$(stat -f%z "build/web/main.dart.js" 2>/dev/null || stat -c%s "build/web/main.dart.js")
        local size_mb=$(echo "scale=2; $current_size / 1024 / 1024" | bc)
        
        # Compare with previous size if available
        if [[ -f "previous_bundle_size.txt" ]]; then
            local previous_size=$(cat previous_bundle_size.txt)
            local delta=$(echo "scale=2; $current_size - $previous_size" | bc)
            local delta_mb=$(echo "scale=2; $delta / 1024 / 1024" | bc)
            
            if (( $(echo "$delta > 0" | bc -l) )); then
                BUNDLE_DELTA="📈 +${delta_mb}MB"
            elif (( $(echo "$delta < 0" | bc -l) )); then
                BUNDLE_DELTA="📉 ${delta_mb}MB"
            else
                BUNDLE_DELTA="➡️ No change"
            fi
        else
            BUNDLE_DELTA="🆕 First measurement"
        fi
        
        local size_emoji=$(get_status_emoji $size_mb 5 "le")
        BUNDLE_SIZE="| 📦 Bundle Size | ${size_mb}MB | $size_emoji | $BUNDLE_DELTA |"
        
        # Save current size for future comparisons
        echo "$current_size" > previous_bundle_size.txt
    else
        BUNDLE_SIZE="| ⚠️ Bundle | Build not found | ❌ | - |"
    fi
}

# Function to check golden test differences
check_golden_diffs() {
    echo "🖼️ Checking Golden test differences..."
    
    local diff_count=0
    if [[ -d "test/golden_failures" ]]; then
        diff_count=$(find test/golden_failures -name "*.png" | wc -l)
    fi
    
    if [[ $diff_count -eq 0 ]]; then
        GOLDEN_DIFF="| 🖼️ Golden Tests | No differences | ✅ | All UI consistent |"
    else
        GOLDEN_DIFF="| 🖼️ Golden Tests | ${diff_count} differences | ❌ | UI changes detected |"
    fi
}

# Function to get coverage delta
get_coverage_delta() {
    echo "🧪 Analyzing coverage delta..."
    
    if [[ -f "coverage-summary.json" ]]; then
        # Try to extract from both possible formats in the file
        local current_coverage=$(jq -r '.coverageThresholds.global.branches // empty' coverage-summary.json 2>/dev/null)
        if [[ -z "$current_coverage" || "$current_coverage" == "null" ]]; then
            # Fallback to extract from the second format
            current_coverage=$(grep -o '"branches": [0-9]*' coverage-summary.json | grep -o '[0-9]*' | tail -1)
        fi
        
        if [[ -n "$current_coverage" && "$current_coverage" != "null" ]]; then
            local coverage_emoji=$(get_status_emoji $current_coverage 80 "ge")
            COVERAGE_DELTA="| 🧪 Branch Coverage | ${current_coverage}% | $coverage_emoji | Target: 80% |"
        else
            COVERAGE_DELTA="| ⚠️ Coverage | Parse error | ❌ | Check format |"
        fi
    else
        COVERAGE_DELTA="| ⚠️ Coverage | No report | ❌ | - |"
    fi
}

# Function to generate PR comment
generate_pr_comment() {
    echo "💬 Generating PR comment..."
    
    local comment_body="## 🔍 Family Copilot Quality Report

### 📊 Lighthouse CI Results
| Metric | Value | Status |
|--------|-------|--------|
$LHCI_STATUS

### 📈 Bundle & Coverage Analysis
| Type | Value | Status | Change |
|------|-------|--------|---------|
$BUNDLE_SIZE
$GOLDEN_DIFF
$COVERAGE_DELTA

### 🔗 Artifacts & Reports
- 📊 [Lighthouse Report]($ARTIFACTS_BASE_URL/artifacts/lighthouse-report)
- 📦 [Bundle Analysis]($ARTIFACTS_BASE_URL/artifacts/bundle-analysis) 
- 🖼️ [Golden Test Diffs]($ARTIFACTS_BASE_URL/artifacts/golden-diffs)
- 🧪 [Coverage Report]($ARTIFACTS_BASE_URL/artifacts/coverage-report)

### 🎯 Quality Gate Status
$(determine_overall_status)

---
*🤖 Automated by Family Copilot CI/CD • Generated at $(date -u '+%Y-%m-%d %H:%M:%S UTC')*"

    echo "$comment_body" > pr_comment.md
    echo "📝 PR comment saved to pr_comment.md"
}

# Function to determine overall status
determine_overall_status() {
    local overall_emoji="✅"
    local status_message="All quality checks passed!"
    
    # Check for any failures in the results
    if [[ "$LHCI_STATUS" == *"❌"* ]] || [[ "$BUNDLE_SIZE" == *"❌"* ]] || [[ "$GOLDEN_DIFF" == *"❌"* ]] || [[ "$COVERAGE_DELTA" == *"❌"* ]]; then
        overall_emoji="❌"
        status_message="Some quality checks failed. Please review and fix issues before merging."
    elif [[ "$LHCI_STATUS" == *"⚠️"* ]] || [[ "$BUNDLE_SIZE" == *"⚠️"* ]] || [[ "$GOLDEN_DIFF" == *"⚠️"* ]] || [[ "$COVERAGE_DELTA" == *"⚠️"* ]]; then
        overall_emoji="⚠️"
        status_message="Quality checks passed with warnings. Consider addressing issues for optimal performance."
    fi
    
    echo "$overall_emoji **$status_message**"
}

# Function to publish comment to PR (requires GitHub CLI or API)
publish_pr_comment() {
    echo "🚀 Publishing PR comment..."
    
    if command -v gh &> /dev/null && [[ -n "$GITHUB_TOKEN" ]]; then
        # Use GitHub CLI if available
        if [[ -n "$PR_NUMBER" ]]; then
            gh pr comment "$PR_NUMBER" --body-file pr_comment.md
            echo "✅ Comment published to PR #$PR_NUMBER"
        else
            echo "⚠️ PR_NUMBER not set, skipping comment publication"
        fi
    else
        echo "ℹ️ GitHub CLI not available or GITHUB_TOKEN not set"
        echo "📄 Comment content available in pr_comment.md"
    fi
}

# Main execution flow
main() {
    echo "🔄 Starting quality analysis..."
    
    # Parse all results
    parse_lhci_results
    analyze_bundle_size
    check_golden_diffs
    get_coverage_delta
    
    # Generate and publish comment
    generate_pr_comment
    publish_pr_comment
    
    echo "✅ Quality report generation completed!"
}

# Execute main function
main "$@"