#!/usr/bin/env bash
set -euo pipefail

REPO="skrastins58-source/Family_Copilot"
LABEL="ready-to-merge"

# Header for Markdown table
TABLE="| PR | Title | Mergeable | Reviews | CI |\n|----|-------|----------:|:-------:|:--:|"

# Ensure gh and jq are available
command -v gh >/dev/null 2>&1 || { echo "gh CLI not found"; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq not found"; exit 1; }

# Iterate PRs
gh pr list --repo "$REPO" --limit 100 --json number,title,draft | jq -c '.[]' | while read -r pr; do
  pr_number=$(echo "$pr" | jq -r '.number')
  pr_title=$(echo "$pr" | jq -r '.title' | sed 's/|/-/g')
  pr_draft=$(echo "$pr" | jq -r '.draft')

  # Get mergeable info and review request count
  mergeable=$(gh pr view "$pr_number" --repo "$REPO" --json mergeable -q '.mergeable' 2>/dev/null || echo "UNKNOWN")
  reviews_required=$(gh pr view "$pr_number" --repo "$REPO" --json reviewRequests -q '(.reviewRequests | length)' 2>/dev/null || echo "0")

  # Get checks summary: count passed vs total
  checks_raw=$(gh pr checks "$pr_number" --repo "$REPO" --quiet 2>/dev/null || true)
  # Count ticks and total check lines containing either ✓ or ✖ or "success"/"failure"
  passed_count=$(echo "$checks_raw" | grep -c "✓" || true)
  total_checks=$(echo "$checks_raw" | grep -E "✓|✖" | wc -l || true)
  # Fallback to 0 if empty
  passed_count=${passed_count:-0}
  total_checks=${total_checks:-0}

  ci_status="${passed_count}/${total_checks}"

  # Decide whether PR is ready
  is_ready=false
  if [[ "$mergeable" == "MERGEABLE" && "$pr_draft" == "false" && "$reviews_required" -eq 0 && "$total_checks" -gt 0 && "$passed_count" -eq "$total_checks" ]]; then
    is_ready=true
  fi

  # Manage label: add if ready, remove if not
  if $is_ready; then
    gh pr edit "$pr_number" --repo "$REPO" --add-label "$LABEL" >/dev/null 2>&1 || true
  else
    gh pr edit "$pr_number" --repo "$REPO" --remove-label "$LABEL" >/dev/null 2>&1 || true
  fi

  # Append row to table (escape pipes in title)
  TABLE+="\n| #$pr_number | $pr_title | $mergeable | $reviews_required | $ci_status |"
done

# Write table to file
echo -e "$TABLE" > pr-status-table.md
echo "Wrote pr-status-table.md"
