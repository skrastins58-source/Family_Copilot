#!/bin/bash
# Script to generate golden test images locally
# This ensures consistent golden image generation
# Enhanced with dependency audit and validation

echo "🖼️ Generating Golden Test Images for Family Copilot"
echo "=================================================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter and add it to your PATH"
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
echo "📱 Using: $FLUTTER_VERSION"

# Check if we're using the expected Flutter version
EXPECTED_VERSION=$(cat FLUTTER_VERSION 2>/dev/null || echo "3.22.0")
if ! echo "$FLUTTER_VERSION" | grep -q "$EXPECTED_VERSION"; then
    echo "⚠️  Warning: Expected Flutter $EXPECTED_VERSION, but found different version"
    echo "   This may cause golden file differences in CI"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Audit dependencies if requested
if [[ "$1" == "--audit-deps" ]]; then
    echo "🔍 Auditing dependencies..."
    flutter pub outdated --no-dev-dependencies || true
    echo ""
    echo "🧪 Dry run dependency upgrade:"
    flutter pub upgrade --dry-run
    echo ""
    read -p "Update dependencies? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔄 Updating dependencies..."
        flutter pub upgrade --major-versions
    fi
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Verify dependencies
echo "🔍 Verifying dependencies..."
flutter pub deps

# Analyze code before running tests
echo "🔍 Analyzing code..."
if ! flutter analyze; then
    echo "❌ Code analysis failed! Please fix issues before generating golden files."
    exit 1
fi

# Check code formatting
echo "📐 Checking code formatting..."
if ! dart format --output=none --set-exit-if-changed .; then
    echo "❌ Code formatting issues found! Please run 'dart format .' first."
    exit 1
fi

# Generate golden images
echo "🎨 Generating golden test images..."
flutter test test/widget_test.dart --update-goldens

# Check if golden files were created
if [ -f "goldens/my_widget.png" ] && [ -s "goldens/my_widget.png" ]; then
    echo "✅ Golden images generated successfully!"
    echo "📂 Generated files:"
    ls -la goldens/*.png
    
    echo ""
    echo "📝 Next steps:"
    echo "  1. Review the generated golden images"
    echo "  2. Run 'git add goldens/' to stage the images"
    echo "  3. Commit the golden images with your changes"
    echo "  4. Push to your branch"
    echo ""
    echo "🔍 To verify golden tests without updating:"
    echo "  flutter test test/widget_test.dart"
    echo ""
    echo "🤖 To validate structure:"
    echo "  bash scripts/validate_golden_structure.sh --strict"
else
    echo "❌ Golden image generation failed!"
    echo "Please check for errors above and ensure your tests are working."
    exit 1
fi