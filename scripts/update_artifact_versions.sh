#!/bin/bash

echo "🔄 Migrating artifact actions to v4..."

# Find and update all workflow files
for file in $(find .github/workflows -type f -name "*.yml"); do
  echo "📄 Updating $file"
  sed -i \
    -e 's|actions/upload-artifact@v1|actions/upload-artifact@v4|g' \
    -e 's|actions/upload-artifact@v2|actions/upload-artifact@v4|g' \
    -e 's|actions/upload-artifact@v3|actions/upload-artifact@v4|g' \
    -e 's|actions/download-artifact@v1|actions/download-artifact@v4|g' \
    -e 's|actions/download-artifact@v2|actions/download-artifact@v4|g' \
    -e 's|actions/download-artifact@v3|actions/download-artifact@v4|g' "$file"
done

echo "✅ Migration complete. All workflow files now use artifact actions v4."
