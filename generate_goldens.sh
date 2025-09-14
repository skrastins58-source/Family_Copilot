#!/bin/bash
# Script to generate golden test images locally
# This ensures consistent golden image generation

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

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

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
else
    echo "❌ Golden image generation failed!"
    echo "Please check for errors above and ensure your tests are working."
    exit 1
fi