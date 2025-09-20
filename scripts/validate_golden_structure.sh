#!/bin/bash
# Script to validate correspondence between goldens/ and docs/diff/ directory structures
# Ensures that golden test images have corresponding diff documentation

set -e

echo "🔍 Validating Golden Tests Structure"
echo "===================================="

GOLDEN_DIR="goldens"
DIFF_DIR="docs/diff"
EXIT_CODE=0

# Check if directories exist
if [ ! -d "$GOLDEN_DIR" ]; then
    echo "❌ Golden directory '$GOLDEN_DIR' does not exist"
    exit 1
fi

if [ ! -d "$DIFF_DIR" ]; then
    echo "❌ Diff directory '$DIFF_DIR' does not exist"
    exit 1
fi

echo "📁 Checking directory structure..."

# Get list of golden files (excluding README.md)
GOLDEN_FILES=($(find "$GOLDEN_DIR" -name "*.png" -exec basename {} \;))
DIFF_FILES=($(find "$DIFF_DIR" -name "*_diff.png" -exec basename {} \;))

echo "📊 Found ${#GOLDEN_FILES[@]} golden files and ${#DIFF_FILES[@]} diff files"

# Check if each golden file has a corresponding diff file structure
echo ""
echo "🔍 Validating file correspondence:"

for golden_file in "${GOLDEN_FILES[@]}"; do
    # Extract base name (remove .png extension)
    base_name="${golden_file%.png}"
    expected_diff="${base_name}_diff.png"
    
    echo -n "  $golden_file -> $expected_diff: "
    
    if [ -f "$DIFF_DIR/$expected_diff" ]; then
        echo "✅ OK"
    else
        echo "❌ MISSING"
        echo "    Expected diff file: $DIFF_DIR/$expected_diff"
        EXIT_CODE=1
    fi
done

# Check for orphaned diff files (diff files without corresponding golden files)
echo ""
echo "🔍 Checking for orphaned diff files:"

for diff_file in "${DIFF_FILES[@]}"; do
    # Extract base name (remove _diff.png suffix)
    base_name="${diff_file%_diff.png}"
    expected_golden="${base_name}.png"
    
    echo -n "  $diff_file -> $expected_golden: "
    
    if [ -f "$GOLDEN_DIR/$expected_golden" ]; then
        echo "✅ OK"
    else
        echo "⚠️  ORPHANED"
        echo "    Missing golden file: $GOLDEN_DIR/$expected_golden"
        # Don't fail for orphaned diff files, just warn
    fi
done

# Validate README files exist
echo ""
echo "📚 Checking documentation:"

if [ -f "$GOLDEN_DIR/README.md" ]; then
    echo "  goldens/README.md: ✅ OK"
else
    echo "  goldens/README.md: ❌ MISSING"
    EXIT_CODE=1
fi

if [ -f "$DIFF_DIR/README.md" ]; then
    echo "  docs/diff/README.md: ✅ OK"
else
    echo "  docs/diff/README.md: ❌ MISSING"
    EXIT_CODE=1
fi

# Summary
echo ""
echo "📈 Validation Summary:"
echo "  Golden files: ${#GOLDEN_FILES[@]}"
echo "  Diff files: ${#DIFF_FILES[@]}"

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All validations passed!"
    echo ""
    echo "📝 Usage reminder:"
    echo "  - To generate golden images: flutter test --update-goldens"
    echo "  - To run golden tests: flutter test test/widget_test.dart"
    echo "  - Diff images are created in test/failures/ on test failure"
    echo "  - Copy significant diffs to docs/diff/ for documentation"
else
    echo "❌ Validation failed with $EXIT_CODE error(s)"
    echo ""
    echo "🔧 To fix issues:"
    echo "  1. Ensure all golden files have corresponding _diff.png files in docs/diff/"
    echo "  2. Create missing diff documentation files"
    echo "  3. Update README files if missing"
fi

exit $EXIT_CODE