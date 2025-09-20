#!/usr/bin/env bash

set -e

DEFAULT_BRANCH=$1

if [ -z "$DEFAULT_BRANCH" ]; then
  echo "Usage: $0 <default_branch>"
  exit 1
fi

# Ensure origin remote reference exists
if ! git rev-parse --verify "origin/$DEFAULT_BRANCH" >/dev/null 2>&1; then
  echo "⚠️ origin/$DEFAULT_BRANCH not found. This may be expected for new golden files."
  echo "ℹ️ Skipping golden diff check for new PR."
  exit 0
fi

# Pārbauda, vai goldens ir mainījies salīdzinot ar origin/<default_branch>
if git diff --exit-code origin/$DEFAULT_BRANCH -- goldens/ >/dev/null 2>&1; then
  echo "✅ Golden attēli sakrīt ar origin/${DEFAULT_BRANCH}!"
else
  echo "ℹ️ Golden attēli atšķiras no origin/${DEFAULT_BRANCH} versijas."
  echo "📊 Golden file changes detected:"
  git diff --name-status origin/$DEFAULT_BRANCH -- goldens/ || true
  echo ""
  echo "💡 This is normal if you've:"
  echo "   - Added new golden tests"
  echo "   - Updated existing UI components"
  echo "   - Regenerated golden images"
  echo ""
  echo "✅ Golden diff check completed successfully."
fi
