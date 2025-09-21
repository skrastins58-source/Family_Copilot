#!/usr/bin/env bash

# =============================================================================
# 📦 Artefaktu Versiju Atjaunināšanas Skripts / Artifact Version Update Script
# =============================================================================
# 
# Latviešu: Atjaunina GitHub Actions artifact darbības uz v4 versiju
# English: Updates GitHub Actions artifact actions to v4 version
#
# Lietošana / Usage:
#   ./update_artifact_versions.sh
#
# Prasības / Requirements:
#   - sed komanda (standarta Unix utilīta)
#   - .github/workflows/ direktorija eksistē
#   - find komanda
#
# Autors / Author: Family Copilot Team
# =============================================================================

echo "🔄 Migrē artifact darbības uz v4 / Migrating artifact actions to v4..."

# Atrast un atjaunināt visus workflow failus / Find and update all workflow files
for file in $(find .github/workflows -type f -name "*.yml" 2>/dev/null); do
  echo "📄 Atjaunina / Updating $file"
  sed -i \
    -e 's|actions/upload-artifact@v1|actions/upload-artifact@v4|g' \
    -e 's|actions/upload-artifact@v2|actions/upload-artifact@v4|g' \
    -e 's|actions/upload-artifact@v3|actions/upload-artifact@v4|g' \
    -e 's|actions/download-artifact@v1|actions/download-artifact@v4|g' \
    -e 's|actions/download-artifact@v2|actions/download-artifact@v4|g' \
    -e 's|actions/download-artifact@v3|actions/download-artifact@v4|g' "$file"
done

echo "✅ Migrācija pabeigta. Visi workflow faili tagad izmanto artifact actions v4."
echo "✅ Migration complete. All workflow files now use artifact actions v4."
