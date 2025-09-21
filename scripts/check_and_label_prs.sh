#!/usr/bin/env bash

# =============================================================================
# 🔍 PR Pārbaudes un Iezīmēšanas Skripts / PR Check and Label Script
# =============================================================================
# 
# Latviešu: Pārbauda PR statusu un pievieno etiķetes "ready-to-merge"
# English: Checks PR status and adds "ready-to-merge" labels
#
# Lietošana / Usage:
#   ./check_and_label_prs.sh
#
# Prasības / Requirements:
#   - GitHub CLI (gh) instalēts un autentificēts
#   - jq instalēts JSON apstrādei
#
# Autors / Author: Family Copilot Team
# =============================================================================

REPO="skrastins58-source/Family_Copilot"
TABLE="| PR | Title | Mergeable | Reviews | CI |\n|----|-------|------------|---------|----|"

gh pr list --repo "$REPO" --limit 100 --json number,title,draft | jq -c '.[]' | while read pr; do
  pr_number=$(echo "$pr" | jq -r '.number')
  pr_title=$(echo "$pr" | jq -r '.title')
  pr_draft=$(echo "$pr" | jq -r '.draft')
  mergeable=$(gh pr view $pr_number --repo "$REPO" --json mergeable -q '.mergeable')
  reviews_required=$(gh pr view $pr_number --repo "$REPO" --json reviewRequests -q '.reviewRequests | length')
  checks=$(gh pr checks $pr_number --repo "$REPO")
  all_passed=$(echo "$checks" | grep -c "✓")
  total_checks=$(echo "$checks" | grep -E "✓|✗" | wc -l)
  ci_status="$all_passed/$total_checks"

  # Label management
  if [[ "$mergeable" == "MERGEABLE" && "$pr_draft" == "false" && "$reviews_required" -eq 0 && "$all_passed" -eq "$total_checks" && "$total_checks" -gt 0 ]]; then
    gh pr edit $pr_number --repo "$REPO" --add-label "ready-to-merge"
  else
    gh pr edit $pr_number --repo "$REPO" --remove-label "ready-to-merge" || true
  fi

  # Add row to Markdown table
  TABLE+="\n| #$pr_number | $pr_title | $mergeable | $reviews_required | $ci_status |"
done

echo -e "$TABLE" > pr-status-table.md
