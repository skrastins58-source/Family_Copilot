#!/bin/bash
# Golden Test Structure Validation Script
# Validates that goldens/ and diff/ directories are properly structured

set -e

echo "🔍 Golden Test Structure Validation"
echo "===================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📂 Project root: $PROJECT_ROOT${NC}"

# Check directories
echo -e "\n${BLUE}📁 Checking directory structure...${NC}"

if [ ! -d "goldens" ]; then
    echo -e "${RED}❌ goldens/ directory does not exist${NC}"
    exit 1
else
    echo -e "${GREEN}✅ goldens/ directory exists${NC}"
fi

if [ ! -d "diff" ]; then
    echo -e "${YELLOW}⚠️  diff/ directory does not exist - creating it${NC}"
    mkdir -p diff
else
    echo -e "${GREEN}✅ diff/ directory exists${NC}"
fi

# Check if there are any test files with golden references
TEST_FILES=$(find test/ -name "*.dart" -exec grep -l "matchesGoldenFile" {} \; 2>/dev/null || true)

if [ -z "$TEST_FILES" ]; then
    echo -e "${YELLOW}⚠️  No test files with golden references found${NC}"
    exit 0
else
    echo -e "${GREEN}📋 Found test files with golden references:${NC}"
    echo "$TEST_FILES" | while read -r file; do
        echo -e "   📝 $file"
    done
fi

# Extract golden file paths from test files
echo -e "\n${BLUE}🧪 Extracting golden file references...${NC}"

GOLDEN_FILES=$(grep -o "goldens/[^'\"]*\.png" $TEST_FILES | sort | uniq)
TOTAL_TESTS=$(echo "$GOLDEN_FILES" | wc -l)

if [ -z "$GOLDEN_FILES" ]; then
    echo -e "${YELLOW}⚠️  No golden file references found in test files${NC}"
    exit 0
fi

echo -e "${BLUE}Found golden file references:${NC}"
echo "$GOLDEN_FILES" | while read -r file; do
    echo -e "   🖼️  $file"
done

# Create temporary files for tracking results
TEMP_DIR=$(mktemp -d)
MISSING_GOLDEN_FILE="$TEMP_DIR/missing_golden"
MISSING_DIFF_FILE="$TEMP_DIR/missing_diff"
EMPTY_GOLDEN_FILE="$TEMP_DIR/empty_golden"
ERRORS_FILE="$TEMP_DIR/errors"
WARNINGS_FILE="$TEMP_DIR/warnings"

touch "$MISSING_GOLDEN_FILE" "$MISSING_DIFF_FILE" "$EMPTY_GOLDEN_FILE" "$ERRORS_FILE" "$WARNINGS_FILE"

# Validate each golden file
echo -e "\n${BLUE}📊 Validation Results:${NC}"
echo "===================="

echo "$GOLDEN_FILES" | while read -r golden_file; do
    if [ -n "$golden_file" ]; then
        echo -e "\n${BLUE}🧪 Validating: $golden_file${NC}"
        
        # Check if golden file exists
        if [ -f "$golden_file" ]; then
            if [ -s "$golden_file" ]; then
                echo -e "   ${GREEN}✅ Golden file exists and has content${NC}"
            else
                echo -e "   ${YELLOW}⚠️  Golden file exists but is empty${NC}"
                echo "$golden_file" >> "$EMPTY_GOLDEN_FILE"
                echo "1" >> "$WARNINGS_FILE"
            fi
        else
            echo -e "   ${RED}❌ Golden file missing: $golden_file${NC}"
            echo "$golden_file" >> "$MISSING_GOLDEN_FILE"
            echo "1" >> "$ERRORS_FILE"
        fi
        
        # Check corresponding diff file
        diff_file="${golden_file/goldens\//diff/}"
        if [ -f "$diff_file" ]; then
            echo -e "   ${GREEN}✅ Diff file exists: $diff_file${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Diff file missing: $diff_file - creating empty file${NC}"
            touch "$diff_file"
            echo "$diff_file" >> "$MISSING_DIFF_FILE"
            echo "1" >> "$WARNINGS_FILE"
        fi
    fi
done

# Count results
MISSING_GOLDEN_COUNT=$(wc -l < "$MISSING_GOLDEN_FILE")
MISSING_DIFF_COUNT=$(wc -l < "$MISSING_DIFF_FILE")
EMPTY_GOLDEN_COUNT=$(wc -l < "$EMPTY_GOLDEN_FILE")
ERROR_COUNT=$(wc -l < "$ERRORS_FILE")
WARNING_COUNT=$(wc -l < "$WARNINGS_FILE")

# Check for orphaned files
echo -e "\n${BLUE}🔍 Checking for orphaned files...${NC}"

ORPHANED_COUNT=0
if [ -d "goldens" ]; then
    for file in goldens/*.png; do
        if [ -f "$file" ] && [ "$file" != "goldens/*.png" ]; then
            filename=$(basename "$file")
            full_path="goldens/$filename"
            if ! echo "$GOLDEN_FILES" | grep -q "$full_path"; then
                echo -e "   ${YELLOW}🗂️  Orphaned file: $file${NC}"
                ((ORPHANED_COUNT++))
            fi
        fi
    done
    
    if [ "$ORPHANED_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  Found $ORPHANED_COUNT orphaned file(s) in goldens/${NC}"
        ((WARNING_COUNT++))
    else
        echo -e "${GREEN}✅ No orphaned files in goldens/${NC}"
    fi
fi

# Show directory contents
echo -e "\n${BLUE}📂 Directory contents:${NC}"
echo -e "${BLUE}goldens/:${NC}"
if [ "$(ls -A goldens/ 2>/dev/null)" ]; then
    ls -la goldens/ | grep -v "^total" | while read -r line; do
        echo -e "   📄 $line"
    done
else
    echo -e "   ${YELLOW}(empty)${NC}"
fi

echo -e "\n${BLUE}diff/:${NC}"
if [ "$(ls -A diff/ 2>/dev/null)" ]; then
    ls -la diff/ | grep -v "^total" | while read -r line; do
        echo -e "   📄 $line"
    done
else
    echo -e "   ${YELLOW}(empty)${NC}"
fi

# Summary
echo -e "\n${BLUE}📈 Summary:${NC}"
echo "=========="
echo -e "Total golden tests found: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "Missing golden files: ${RED}$MISSING_GOLDEN_COUNT${NC}"
echo -e "Empty golden files: ${YELLOW}$EMPTY_GOLDEN_COUNT${NC}"
echo -e "Missing diff files (created): ${YELLOW}$MISSING_DIFF_COUNT${NC}"
echo -e "Orphaned files: ${YELLOW}$ORPHANED_COUNT${NC}"
echo -e "Total errors: ${RED}$ERROR_COUNT${NC}"
echo -e "Total warnings: ${YELLOW}$WARNING_COUNT${NC}"

# Cleanup
rm -rf "$TEMP_DIR"

# Exit with appropriate code
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo -e "\n${RED}❌ Validation failed with $ERROR_COUNT error(s)${NC}"
    echo -e "${RED}Please fix the missing golden files before proceeding${NC}"
    exit 1
elif [ "$WARNING_COUNT" -gt 0 ]; then
    echo -e "\n${YELLOW}⚠️  Validation completed with $WARNING_COUNT warning(s)${NC}"
    echo -e "${YELLOW}Consider addressing the warnings for optimal structure${NC}"
    exit 0
else
    echo -e "\n${GREEN}✅ Golden test structure validation passed!${NC}"
    exit 0
fi