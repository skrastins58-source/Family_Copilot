#!/usr/bin/env bash

set -e

DEFAULT_BRANCH=$1

if [ -z "$DEFAULT_BRANCH" ]; then
  echo "Usage: $0 <default_branch>"
  exit 1
fi

# Pārbauda, vai goldens ir mainījies salīdzinot ar origin/<default_branch>
git diff --exit-code origin/$DEFAULT_BRANCH -- goldens/ \
  || (echo "❌ Golden attēli atšķiras no origin/${DEFAULT_BRANCH} versijas!" && exit 1)

echo "✅ Golden attēli sakrīt ar origin/${DEFAULT_BRANCH}!"
