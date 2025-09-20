#!/bin/bash
# Helper script for golden test workflow management
# Provides common golden test operations with validation

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

show_help() {
    echo "🖼️ Golden Test Helper Script"
    echo "============================"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  generate    Generate/update golden images"
    echo "  test        Run golden tests without updating"
    echo "  validate    Validate golden/diff structure"
    echo "  clean       Clean test artifacts"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 generate     # Update golden images"
    echo "  $0 test         # Run tests to check for regressions"
    echo "  $0 validate     # Check structure consistency"
    echo ""
}

generate_goldens() {
    echo "🎨 Generating golden test images..."
    
    # Validate structure first
    echo "📋 Validating structure..."
    ./scripts/validate_golden_structure.sh
    
    # Clean previous builds
    echo "🧹 Cleaning previous builds..."
    flutter clean > /dev/null 2>&1 || true
    
    # Get dependencies
    echo "📦 Installing dependencies..."
    flutter pub get
    
    # Generate golden images
    echo "🖼️ Generating golden images..."
    flutter test test/widget_test.dart --update-goldens
    
    echo "✅ Golden images generated successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "  1. Review generated images in goldens/"
    echo "  2. Run '$0 test' to verify"
    echo "  3. Commit changes: git add goldens/ && git commit"
}

run_tests() {
    echo "🧪 Running golden tests..."
    
    # Validate structure first
    echo "📋 Validating structure..."
    ./scripts/validate_golden_structure.sh
    
    # Run golden tests without updating
    echo "🔍 Running golden tests..."
    flutter test test/widget_test.dart
    
    echo "✅ Golden tests completed!"
}

validate_structure() {
    echo "🔍 Validating golden test structure..."
    ./scripts/validate_golden_structure.sh
}

clean_artifacts() {
    echo "🧹 Cleaning test artifacts..."
    
    # Remove test failures directory
    if [ -d "test/failures" ]; then
        rm -rf test/failures
        echo "  Removed test/failures/"
    fi
    
    # Remove coverage files
    if [ -f "coverage/lcov.info" ]; then
        rm -rf coverage/
        echo "  Removed coverage/"
    fi
    
    # Flutter clean
    flutter clean > /dev/null 2>&1 || true
    echo "  Flutter clean completed"
    
    echo "✅ Cleanup completed!"
}

# Main command processing
case "${1:-help}" in
    "generate"|"gen")
        generate_goldens
        ;;
    "test"|"t")
        run_tests
        ;;
    "validate"|"val")
        validate_structure
        ;;
    "clean"|"c")
        clean_artifacts
        ;;
    "help"|"h"|"")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac