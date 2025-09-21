#!/usr/bin/env bash
# Dependency audit script for Family Copilot
# Helps identify outdated packages and potential conflicts

set -e

echo "🔍 Family Copilot Dependency Audit"
echo "=================================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Show current Flutter version
echo "📱 Flutter version:"
flutter --version | head -n 1

echo ""
echo "📋 Current dependency tree:"
flutter pub deps --style=compact

echo ""
echo "🔍 Checking for outdated packages:"
flutter pub outdated --no-dev-dependencies || {
    echo "ℹ️  All packages are up to date or pub outdated encountered issues"
}

echo ""
echo "🧪 Dry run dependency upgrade (no changes made):"
flutter pub upgrade --dry-run || {
    echo "ℹ️  No upgrades available or dependency resolution issues detected"
}

echo ""
echo "📊 Dependency analysis complete!"
echo ""
echo "🔧 To update dependencies:"
echo "  flutter pub upgrade --major-versions"
echo ""
echo "🎨 To regenerate golden files after dependency updates:"
echo "  ./generate_goldens.sh"