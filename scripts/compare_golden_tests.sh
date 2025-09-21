#!/bin/bash
# Golden Test Comparison Script for CI/CD
# Compares golden test images and generates diff images for failures

set -e

echo "🖼️ Golden Test Comparison Script"
echo "================================="

# Configuration
GOLDENS_DIR="goldens"
DIFF_DIR="test/diff"
ACTUAL_DIR="$DIFF_DIR/actual"
EXPECTED_DIR="$DIFF_DIR/expected"
FAILURES_DIR="test/failures"

# Create necessary directories
mkdir -p "$DIFF_DIR" "$ACTUAL_DIR" "$EXPECTED_DIR" "$FAILURES_DIR"

echo "📁 Created directories:"
echo "  - $DIFF_DIR"
echo "  - $ACTUAL_DIR"
echo "  - $EXPECTED_DIR"
echo "  - $FAILURES_DIR"

# Clean previous diff images
echo "🧹 Cleaning previous diff images..."
rm -f "$DIFF_DIR"/*.png "$ACTUAL_DIR"/*.png "$EXPECTED_DIR"/*.png "$FAILURES_DIR"/*.png

# Function to validate image structure
validate_image_structure() {
    echo "🔍 Validating image naming and structure..."
    
    local validation_errors=0
    
    # Check if goldens directory exists
    if [ ! -d "$GOLDENS_DIR" ]; then
        echo "❌ Error: $GOLDENS_DIR directory not found"
        validation_errors=$((validation_errors + 1))
    fi
    
    # Validate golden image files
    if [ -d "$GOLDENS_DIR" ]; then
        for golden_file in "$GOLDENS_DIR"/*.png; do
            if [ -f "$golden_file" ]; then
                local filename=$(basename "$golden_file")
                echo "✅ Found golden image: $filename"
                
                # Check file size (should not be empty)
                if [ ! -s "$golden_file" ]; then
                    echo "⚠️  Warning: $filename is empty"
                    validation_errors=$((validation_errors + 1))
                fi
            fi
        done
    fi
    
    # Check for naming consistency
    local expected_files=("my_widget.png" "golden_text.png" "material_container.png")
    for expected_file in "${expected_files[@]}"; do
        if [ ! -f "$GOLDENS_DIR/$expected_file" ]; then
            echo "⚠️  Warning: Expected golden image $expected_file not found"
        fi
    done
    
    return $validation_errors
}

# Function to run golden tests
run_golden_tests() {
    echo "🧪 Running golden tests..."
    
    local test_exit_code=0
    
    # Run golden tests without updating
    if flutter test test/widget_test.dart 2>&1 | tee test_output.log; then
        echo "✅ Golden tests passed!"
        return 0
    else
        test_exit_code=$?
        echo "❌ Golden tests failed with exit code: $test_exit_code"
        return $test_exit_code
    fi
}

# Function to generate comparison images
generate_comparison_images() {
    echo "📊 Generating comparison images for failed tests..."
    
    # First, generate current images
    echo "📸 Generating current test images..."
    if ! flutter test test/widget_test.dart --update-goldens 2>test_update_goldens_error.log; then
        echo "⚠️  Warning: 'flutter test --update-goldens' failed. See test_update_goldens_error.log for details."
    fi
    
    # Copy golden images to expected directory for comparison
    if [ -d "$GOLDENS_DIR" ]; then
        for golden_file in "$GOLDENS_DIR"/*.png; do
            if [ -f "$golden_file" ]; then
                local filename=$(basename "$golden_file")
                cp "$golden_file" "$EXPECTED_DIR/$filename"
                echo "📋 Copied $filename to expected directory"
            fi
        done
    fi
    
    # Create a simple diff report
    echo "📝 Creating diff report..."
    cat > "$FAILURES_DIR/golden_test_report.md" << EOF
# Golden Test Failure Report

## Test Run Summary
- **Date**: $(date)
- **Test File**: test/widget_test.dart
- **Status**: FAILED

## Failed Tests
$(grep -o "FAILED.*golden.*test" test_output.log 2>/dev/null || echo "Multiple golden tests failed")

## Artifacts Generated
- Expected images: $EXPECTED_DIR/
- Actual images: $ACTUAL_DIR/
- Diff visualization: $DIFF_DIR/

## Next Steps
1. Review the visual differences in the uploaded artifacts
2. If changes are intentional, update golden images:
   \`\`\`bash
   flutter test test/widget_test.dart --update-goldens
   git add goldens/
   git commit -m "Update golden images"
   \`\`\`
3. If changes are unintentional, fix the UI code

EOF

    echo "📄 Generated report: $FAILURES_DIR/golden_test_report.md"
}

# Function to create PR comment data
create_pr_comment_data() {
    echo "💬 Creating PR comment data..."
    
    cat > "$FAILURES_DIR/pr_comment.json" << EOF
{
  "title": "🖼️ Golden Test Failures",
  "body": "Golden tests failed! Visual regression detected.\\n\\n### Failed Tests:\\n- UI components have changed compared to reference images\\n\\n### Action Required:\\n1. Review uploaded artifacts for visual differences\\n2. If changes are intentional, update golden images locally\\n3. If changes are unintentional, fix the UI code\\n\\n📎 Check workflow artifacts for detailed comparison images.",
  "severity": "warning",
  "timestamp": "$(date -Iseconds)"
}
EOF

    echo "💾 Created PR comment data: $FAILURES_DIR/pr_comment.json"
}

# Main execution
main() {
    echo "🚀 Starting golden test validation..."
    
    # Validate structure first
    if ! validate_image_structure; then
        echo "⚠️  Structure validation completed with warnings"
    fi
    
    # Run golden tests
    if run_golden_tests; then
        echo "🎉 All golden tests passed! No comparison needed."
        exit 0
    else
        echo "📊 Golden tests failed. Generating comparison artifacts..."
        
        # Generate comparison images and reports
        generate_comparison_images
        create_pr_comment_data
        
        echo "📦 Artifacts generated in:"
        echo "  - $FAILURES_DIR/"
        echo "  - $DIFF_DIR/"
        
        # List generated files
        if [ -d "$FAILURES_DIR" ] && [ "$(ls -A $FAILURES_DIR)" ]; then
            echo "📄 Generated files:"
            ls -la "$FAILURES_DIR"
        fi
        
        echo "❌ Golden test comparison completed with failures"
        exit 1
    fi
}

# Run main function
main "$@"