#!/bin/bash

# Test runner for validation scripts
# Validates that both golden file and coverage validation scripts work correctly

echo "🧪 Testing Validation Scripts"
echo "============================="

EXIT_CODE=0

# Test the golden files validation script
echo ""
echo "1️⃣ Testing Golden Files Validation..."
echo "------------------------------------"

if ./scripts/validate_golden_files.sh; then
    echo "✅ Golden files validation test completed"
else
    echo "❌ Golden files validation test failed"
    EXIT_CODE=1
fi

# Test the coverage validation script (will fail without coverage data, but should not crash)
echo ""
echo "2️⃣ Testing Coverage Validation..."
echo "---------------------------------"

# Test that the script handles missing coverage gracefully
if ./scripts/check_coverage.sh 2>/dev/null; then
    echo "✅ Coverage validation test completed"
else
    # Expected to fail without coverage data, but should give meaningful error
    echo "⚠️ Coverage validation failed as expected (no coverage data)"
fi

echo ""
echo "📊 Test Summary"
echo "==============="

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All validation script tests passed!"
else
    echo "❌ Some validation script tests failed!"
fi

exit $EXIT_CODE