#!/bin/bash

# Basic accessibility and SEO validation script
echo "🔍 Running SEO and Accessibility validation for landing.html"
echo "=================================================="

echo "✅ HTML Structure Validation"
npx html-validate docs/landing.html

echo ""
echo "📱 Checking basic accessibility requirements..."

# Check if file has essential meta tags
echo "🏷️  Checking meta tags:"
grep -q 'name="viewport"' docs/landing.html && echo "✅ Viewport meta tag found" || echo "❌ Viewport meta tag missing"
grep -q 'name="description"' docs/landing.html && echo "✅ Description meta tag found" || echo "❌ Description meta tag missing"
grep -q 'alt=' docs/landing.html && echo "✅ Alt attributes found on images" || echo "❌ No alt attributes found"

echo ""
echo "🎯 Checking semantic HTML:"
grep -q '<main' docs/landing.html && echo "✅ Main element found" || echo "❌ Main element missing"
grep -q '<header' docs/landing.html && echo "✅ Header element found" || echo "❌ Header element missing"
grep -q '<footer' docs/landing.html && echo "✅ Footer element found" || echo "❌ Footer element missing"
grep -q '<nav' docs/landing.html && echo "✅ Nav element found" || echo "❌ Nav element missing"

echo ""
echo "♿ Checking ARIA attributes:"
grep -q 'aria-label' docs/landing.html && echo "✅ ARIA labels found" || echo "❌ No ARIA labels found"
grep -q 'aria-labelledby' docs/landing.html && echo "✅ ARIA labelledby found" || echo "❌ No ARIA labelledby found"

echo ""
echo "🔗 Checking skip links:"
grep -q 'skip-link' docs/landing.html && echo "✅ Skip link found" || echo "❌ Skip link missing"

echo ""
echo "📊 Summary:"
echo "Landing page validation completed. Check for any ❌ items above."