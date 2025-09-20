#!/bin/bash
# Golden Test Structure Validation Script
# Validates that goldens/ and tests/diff/ directories are properly structured
# and that each golden test has corresponding files

GOLDENS_DIR="goldens"
DIFF_DIR="tests/diff"
TEST_DIR="test"

ERRORS=0
WARNINGS=0
INFO=0

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_error() {
    echo -e "${RED}❌ ERROR: $1${NC}"
    ((ERRORS++))
}

log_warning() {
    echo -e "${YELLOW}⚠️  WARNING: $1${NC}"
    ((WARNINGS++))
}

log_info() {
    echo -e "${GREEN}✓ INFO: $1${NC}"
    ((INFO++))
}

log_blue() {
    echo -e "${BLUE}$1${NC}"
}

# Check directory structure
validate_directory_structure() {
    log_blue "🔍 Checking directory structure..."
    
    for dir in "$GOLDENS_DIR" "$DIFF_DIR" "$TEST_DIR"; do
        if [ -d "$dir" ]; then
            log_info "Directory exists: $dir"
        else
            log_error "Required directory missing: $dir"
        fi
    done
}

# Extract golden file references from test files
extract_golden_references() {
    local references=()
    
    log_blue "🔍 Extracting golden file references from test files..."
    
    if [ ! -d "$TEST_DIR" ]; then
        log_error "Test directory not found: $TEST_DIR"
        return 1
    fi
    
    # Find all .dart files in test directory
    while IFS= read -r -d '' test_file; do
        # Extract matchesGoldenFile references using grep and sed
        while IFS= read -r golden_ref; do
            references+=("$golden_ref")
            log_info "Found golden reference: $golden_ref in $test_file"
        done < <(grep -o "matchesGoldenFile(['\"][^'\"]*['\"])" "$test_file" | sed -E "s/matchesGoldenFile\\(['\"]([^'\"]*)['\"]\\)/\\1/g")
    done < <(find "$TEST_DIR" -name "*.dart" -type f -print0)
    
    if [ ${#references[@]} -eq 0 ]; then
        log_warning "No golden test references found in test files"
    fi
    
    # Return references via global variable (bash limitation)
    GOLDEN_REFERENCES=("${references[@]}")
}

# Validate that all referenced golden files exist
validate_golden_files() {
    log_blue "🔍 Validating golden files..."
    
    for golden_ref in "${GOLDEN_REFERENCES[@]}"; do
        if [ -f "$golden_ref" ]; then
            size=$(stat -c%s "$golden_ref" 2>/dev/null || echo "0")
            if [ "$size" -eq 0 ]; then
                log_warning "Golden file is empty: $golden_ref"
            else
                log_info "Golden file exists: $golden_ref ($size bytes)"
            fi
        else
            log_error "Golden file does not exist: $golden_ref"
        fi
    done
}

# Validate that diff files exist for each golden test
validate_diff_files() {
    log_blue "🔍 Validating diff files..."
    
    for golden_ref in "${GOLDEN_REFERENCES[@]}"; do
        # Convert goldens/filename.png to tests/diff/filename.png
        filename=$(basename "$golden_ref")
        diff_path="$DIFF_DIR/$filename"
        
        if [ -f "$diff_path" ]; then
            size=$(stat -c%s "$diff_path" 2>/dev/null || echo "0")
            if [ "$size" -eq 0 ]; then
                log_info "Diff file exists (empty): $diff_path"
            else
                log_info "Diff file exists: $diff_path ($size bytes)"
            fi
        else
            log_error "Diff file missing for golden test: $diff_path"
        fi
    done
}

# Check for orphaned files (files without corresponding tests)
validate_orphaned_files() {
    log_blue "🔍 Checking for orphaned files..."
    
    # Check orphaned golden files
    if [ -d "$GOLDENS_DIR" ]; then
        # Get list of referenced filenames
        local referenced_files=()
        for golden_ref in "${GOLDEN_REFERENCES[@]}"; do
            referenced_files+=("$(basename "$golden_ref")")
        done
        
        # Check each golden file
        for golden_file in "$GOLDENS_DIR"/*.png; do
            if [ -f "$golden_file" ]; then
                filename=$(basename "$golden_file")
                found=false
                for ref_file in "${referenced_files[@]}"; do
                    if [ "$filename" = "$ref_file" ]; then
                        found=true
                        break
                    fi
                done
                if [ "$found" = false ]; then
                    log_warning "Orphaned golden file (no test reference): $golden_file"
                fi
            fi
        done
    fi
    
    # Check orphaned diff files
    if [ -d "$DIFF_DIR" ]; then
        # Get list of expected diff filenames
        local expected_diff_files=()
        for golden_ref in "${GOLDEN_REFERENCES[@]}"; do
            expected_diff_files+=("$(basename "$golden_ref")")
        done
        
        # Check each diff file
        for diff_file in "$DIFF_DIR"/*.png; do
            if [ -f "$diff_file" ]; then
                filename=$(basename "$diff_file")
                found=false
                for exp_file in "${expected_diff_files[@]}"; do
                    if [ "$filename" = "$exp_file" ]; then
                        found=true
                        break
                    fi
                done
                if [ "$found" = false ]; then
                    log_warning "Orphaned diff file (no golden test): $diff_file"
                fi
            fi
        done
    fi
}

# Print validation results
print_results() {
    echo
    log_blue "📊 Validation Results:"
    echo "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "="
    
    echo
    log_blue "📈 Summary:"
    echo "   Info: $INFO"
    echo "   Warnings: $WARNINGS"
    echo "   Errors: $ERRORS"
    
    echo
    if [ $ERRORS -eq 0 ]; then
        log_info "Golden test structure validation PASSED!"
    else
        log_error "Golden test structure validation FAILED!"
        echo "   Please fix the errors above before proceeding."
    fi
}

# Main validation function
main() {
    echo "🔍 Validating Golden Test Structure..."
    echo "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "=" "="
    
    # Global array to store golden references
    declare -a GOLDEN_REFERENCES
    
    # Run validation steps
    validate_directory_structure
    extract_golden_references
    validate_golden_files
    validate_diff_files
    validate_orphaned_files
    
    # Print results
    print_results
    
    # Exit with error code if validation failed
    if [ $ERRORS -gt 0 ]; then
        exit 1
    fi
}

# Run main function
main "$@"