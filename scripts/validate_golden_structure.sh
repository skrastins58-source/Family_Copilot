#!/bin/bash
# Image Structure Validation Script
# Validates naming consistency and structure between goldens/ and diff/ directories

set -e

echo "🔍 Golden Test Image Structure Validation"
echo "========================================="

# Configuration
GOLDENS_DIR="goldens"
DIFF_DIR="test/diff"
TEST_DIR="test"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0

# Function to log error
log_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ERRORS=$((ERRORS + 1))
}

# Function to log warning
log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    WARNINGS=$((WARNINGS + 1))
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to validate directory structure
validate_directory_structure() {
    echo "📂 Validating directory structure..."
    
    # Check required directories
    local required_dirs=("$GOLDENS_DIR" "$TEST_DIR")
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_success "Directory exists: $dir"
        else
            log_error "Required directory missing: $dir"
        fi
    done
    
    # Check optional directories
    if [ -d "$DIFF_DIR" ]; then
        log_success "Diff directory exists: $DIFF_DIR"
    else
        echo "ℹ️  Info: Diff directory not found (will be created during test failures)"
    fi
}

# Function to validate golden images
validate_golden_images() {
    echo "🖼️  Validating golden images..."
    
    if [ ! -d "$GOLDENS_DIR" ]; then
        log_error "Goldens directory not found: $GOLDENS_DIR"
        return
    fi
    
    # Expected golden files based on test/widget_test.dart
    local expected_goldens=("my_widget.png" "golden_text.png" "material_container.png")
    
    # Check expected files exist
    for expected_file in "${expected_goldens[@]}"; do
        local file_path="$GOLDENS_DIR/$expected_file"
        if [ -f "$file_path" ]; then
            # Check file size
            # Cross-platform: 'stat -c%s' works on Linux, 'stat -f%z' works on macOS/BSD.
            # This fallback ensures compatibility for both systems.
            local file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null || echo "0")
            if [ "$file_size" -gt 0 ]; then
                log_success "Golden image valid: $expected_file (${file_size} bytes)"
            else
                log_error "Golden image is empty: $expected_file"
            fi
        else
            log_error "Expected golden image missing: $expected_file"
        fi
    done
    
    # Check for unexpected files
    for file in "$GOLDENS_DIR"/*.png; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local expected=false
            for expected_file in "${expected_goldens[@]}"; do
                if [ "$filename" = "$expected_file" ]; then
                    expected=true
                    break
                fi
            done
            
            if [ "$expected" = false ]; then
                log_warning "Unexpected golden image found: $filename"
            fi
        fi
    done
}

# Function to validate test file consistency
validate_test_consistency() {
    echo "🧪 Validating test file consistency..."
    
    local test_file="$TEST_DIR/widget_test.dart"
    
    if [ ! -f "$test_file" ]; then
        log_error "Test file not found: $test_file"
        return
    fi
    
    # Extract golden file references from test file
    local golden_refs=$(grep -o "goldens/[^'\"]*\.png" "$test_file" 2>/dev/null || true)
    
    if [ -z "$golden_refs" ]; then
        log_warning "No golden file references found in test file"
        return
    fi
    
    echo "📋 Found golden file references in tests:"
    while IFS= read -r ref; do
        if [ -n "$ref" ]; then
            local file_path="$ref"
            echo "  - $ref"
            
            if [ -f "$file_path" ]; then
                log_success "Referenced golden file exists: $ref"
            else
                log_error "Referenced golden file missing: $ref"
            fi
        fi
    done <<< "$golden_refs"
}

# Function to validate naming conventions
validate_naming_conventions() {
    echo "📝 Validating naming conventions..."
    
    if [ ! -d "$GOLDENS_DIR" ]; then
        return
    fi
    
    for file in "$GOLDENS_DIR"/*.png; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            
            # Check naming pattern (should be lowercase with underscores)
            if [[ "$filename" =~ ^[a-z][a-z0-9_]*\.png$ ]]; then
                log_success "Naming convention correct: $filename"
            else
                log_warning "Naming convention issue: $filename (should use lowercase with underscores)"
            fi
            
            # Check for spaces or special characters
            if [[ "$filename" =~ [[:space:]] ]]; then
                log_error "Filename contains spaces: $filename"
            fi
            
            if [[ "$filename" =~ [^a-zA-Z0-9_.-] ]]; then
                log_warning "Filename contains special characters: $filename"
            fi
        fi
    done
}

# Function to validate diff directory structure
validate_diff_structure() {
    echo "📊 Validating diff directory structure..."
    
    if [ ! -d "$DIFF_DIR" ]; then
        echo "ℹ️  Info: Diff directory not found (normal for successful tests)"
        return
    fi
    
    local expected_subdirs=("actual" "expected")
    
    for subdir in "${expected_subdirs[@]}"; do
        local dir_path="$DIFF_DIR/$subdir"
        if [ -d "$dir_path" ]; then
            log_success "Diff subdirectory exists: $subdir"
        else
            echo "ℹ️  Info: Diff subdirectory not found: $subdir (normal if no test failures)"
        fi
    done
}

# Function to check README files
validate_documentation() {
    echo "📚 Validating documentation..."
    
    # Check goldens README
    if [ -f "$GOLDENS_DIR/README.md" ]; then
        log_success "Goldens README exists"
    else
        log_warning "Goldens README missing: $GOLDENS_DIR/README.md"
    fi
    
    # Check diff README
    if [ -f "$DIFF_DIR/README.md" ]; then
        log_success "Diff README exists"
    else
        echo "ℹ️  Info: Diff README not found (created during failures)"
    fi
}

# Function to generate validation report
generate_validation_report() {
    echo "📄 Generating validation report..."
    
    local report_file="validation_report.md"
    
    cat > "$report_file" << EOF
# Golden Test Image Structure Validation Report

**Date**: $(date)
**Validator**: validate_golden_structure.sh

## Summary
- **Errors**: $ERRORS
- **Warnings**: $WARNINGS
- **Status**: $([ $ERRORS -eq 0 ] && echo "✅ PASSED" || echo "❌ FAILED")

## Validation Checks Performed
1. ✅ Directory structure validation
2. ✅ Golden image validation
3. ✅ Test file consistency check
4. ✅ Naming convention validation
5. ✅ Diff structure validation
6. ✅ Documentation validation

## Expected Files Structure
\`\`\`
goldens/
├── README.md
├── my_widget.png
├── golden_text.png
└── material_container.png

test/
├── widget_test.dart
└── diff/
    ├── README.md
    ├── actual/
    └── expected/
\`\`\`

## Recommendations
$([ $ERRORS -gt 0 ] && echo "- Fix $ERRORS error(s) before proceeding" || echo "- No critical issues found")
$([ $WARNINGS -gt 0 ] && echo "- Consider addressing $WARNINGS warning(s)" || echo "- No warnings found")

EOF

    log_success "Validation report generated: $report_file"
}

# Main validation function
main() {
    echo "🚀 Starting image structure validation..."
    echo
    
    validate_directory_structure
    echo
    
    validate_golden_images
    echo
    
    validate_test_consistency
    echo
    
    validate_naming_conventions
    echo
    
    validate_diff_structure
    echo
    
    validate_documentation
    echo
    
    generate_validation_report
    echo
    
    echo "📊 Validation Summary:"
    echo "  - Errors: $ERRORS"
    echo "  - Warnings: $WARNINGS"
    
    if [ $ERRORS -eq 0 ]; then
        log_success "Image structure validation completed successfully!"
        exit 0
    else
        log_error "Image structure validation failed with $ERRORS error(s)"
        exit 1
    fi
}

# Run main function
main "$@"