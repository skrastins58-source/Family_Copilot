#!/bin/bash

# Golden Files Validation Script
# Ensures consistency between golden image files and their references in test files
# Part of Family Copilot CI/CD quality assurance

echo "🖼️ Golden Files Validation"
echo "=========================="

# Exit on any error
set -e

# Configuration
GOLDENS_DIR="goldens"
TEST_DIR="test"
EXIT_CODE=0

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log errors
log_error() {
    echo -e "${RED}❌ $1${NC}"
    EXIT_CODE=1
}

# Function to log warnings
log_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Function to log success
log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Check if directories exist
if [ ! -d "$GOLDENS_DIR" ]; then
    log_error "Golden images directory '$GOLDENS_DIR' not found"
    exit 1
fi

if [ ! -d "$TEST_DIR" ]; then
    log_error "Test directory '$TEST_DIR' not found"
    exit 1
fi

echo "📂 Checking directory structure..."
log_success "Golden images directory: $GOLDENS_DIR"
log_success "Test directory: $TEST_DIR"

# Get list of golden image files (excluding README.md)
echo ""
echo "📋 Analyzing golden image files..."
GOLDEN_FILES=$(find "$GOLDENS_DIR" -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | sort)
GOLDEN_COUNT=$(echo "$GOLDEN_FILES" | wc -l)

if [ -z "$GOLDEN_FILES" ]; then
    log_warning "No golden image files found in $GOLDENS_DIR"
    GOLDEN_COUNT=0
else
    echo "Found $GOLDEN_COUNT golden image files:"
    for file in $GOLDEN_FILES; do
        echo "  - $(basename "$file")"
    done
fi

# Extract golden file references from test files
echo ""
echo "🔍 Scanning test files for golden references..."
TEST_FILES=$(find "$TEST_DIR" -name "*.dart" | sort)

if [ -z "$TEST_FILES" ]; then
    log_error "No Dart test files found in $TEST_DIR"
    exit 1
fi

# Create temporary file to store found references
TEMP_REFS=$(mktemp)
trap "rm -f $TEMP_REFS" EXIT

# Search for matchesGoldenFile calls in test files
for test_file in $TEST_FILES; do
    # Extract golden file paths from matchesGoldenFile() calls
    grep -oP "matchesGoldenFile\(['\"].*?['\"]" "$test_file" 2>/dev/null | \
        sed -E "s/matchesGoldenFile\(['\"](.+?)['\"].*/\1/" >> "$TEMP_REFS" || true
done

# Get unique references and sort them
REFERENCED_FILES=$(sort "$TEMP_REFS" | uniq)
REFERENCED_COUNT=$(echo "$REFERENCED_FILES" | wc -l)

if [ -z "$REFERENCED_FILES" ]; then
    log_warning "No golden file references found in test files"
    REFERENCED_COUNT=0
else
    echo "Found $REFERENCED_COUNT golden file references in tests:"
    for ref in $REFERENCED_FILES; do
        echo "  - $ref"
    done
fi

# Validation checks
echo ""
echo "🔍 Performing validation checks..."

# Check 1: All referenced files should exist
echo ""
echo "Check 1: Verifying all referenced golden files exist..."
if [ "$REFERENCED_COUNT" -eq 0 ]; then
    log_warning "No golden file references to validate"
else
    for ref in $REFERENCED_FILES; do
        if [ -f "$ref" ]; then
            log_success "Referenced file exists: $ref"
        else
            log_error "Referenced file missing: $ref"
        fi
    done
fi

# Check 2: All golden files should be referenced in tests
echo ""
echo "Check 2: Verifying all golden files are referenced in tests..."
if [ "$GOLDEN_COUNT" -eq 0 ]; then
    log_warning "No golden files to validate"
else
    for golden_file in $GOLDEN_FILES; do
        # Get relative path from repository root
        rel_path="$golden_file"
        
        # Check if this file is referenced in tests
        if echo "$REFERENCED_FILES" | grep -q "^$rel_path$"; then
            log_success "Golden file is referenced: $rel_path"
        else
            log_warning "Orphaned golden file (not referenced in tests): $rel_path"
        fi
    done
fi

# Check 3: Verify golden files are not empty
echo ""
echo "Check 3: Verifying golden files are not empty..."
if [ "$GOLDEN_COUNT" -eq 0 ]; then
    log_warning "No golden files to check"
else
    for golden_file in $GOLDEN_FILES; do
        if [ -s "$golden_file" ]; then
            log_success "Golden file not empty: $(basename "$golden_file")"
        else
            log_error "Golden file is empty: $golden_file"
        fi
    done
fi

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="
echo "Golden files found: $GOLDEN_COUNT"
echo "References in tests: $REFERENCED_COUNT"

if [ $EXIT_CODE -eq 0 ]; then
    log_success "All golden file validations passed!"
else
    echo ""
    log_error "Golden file validation failed. Please fix the issues above."
    echo ""
    echo "💡 Common solutions:"
    echo "  - Run 'flutter test --update-goldens' to generate missing golden files"
    echo "  - Remove orphaned golden files that are no longer needed"
    echo "  - Update test files to reference correct golden file paths"
    echo "  - Ensure golden file paths in tests match actual file locations"
fi

exit $EXIT_CODE