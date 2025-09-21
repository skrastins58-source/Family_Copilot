# Golden Tests Setup Documentation

## Overview

This PR implements a complete golden test infrastructure for the Family Copilot Flutter application to ensure UI consistency and prevent visual regressions.

## Files Added:

### 1. `test/widget_test.dart`
- Contains golden tests for UI components
- Tests a static container with "Golden!" text
- Includes multiple test variations for comprehensive coverage
- Uses Material Design 3 theming for consistent styling

### 2. `goldens/` directory
- Contains placeholder files for golden images: `my_widget.png`, `golden_text.png`, `material_container.png`
- Includes comprehensive README with usage instructions
- Images will be generated when running `flutter test --update-goldens`

### 3. `.github/workflows/flutter-golden.yml`
- GitHub Actions workflow for CI/CD integration
- Uses Flutter 3.22.0 for consistency
- Runs golden tests on every PR and push
- Includes artifact upload for test results and golden images
- Provides automatic PR comments on golden test failures
- Has separate validation job for PRs with golden file changes

### 4. `generate_goldens.sh`
- Helper script for local golden image generation
- Includes Flutter version checking and dependency management
- Provides clear instructions for developers

### 5. Updated `README.md`
- Added comprehensive golden tests section
- Includes examples, workflow description, and best practices
- Explains CI integration and local usage
- Documents the complete golden test process

### 6. `FLUTTER_VERSION` file
- Specifies Flutter 3.22.0 for consistency across environments
- Used by CI and local development for version alignment

## Usage:

### Local Development:
```bash
# Generate golden images with enhanced script
./generate_goldens.sh

# Generate with dependency audit
./generate_goldens.sh --audit-deps

# Audit dependencies separately
./scripts/audit_dependencies.sh

# Or manually:
flutter test test/widget_test.dart --update-goldens

# Run tests without updating:
flutter test test/widget_test.dart
```

### CI/CD Automation:

#### Automatic Triggers:
- Golden tests run automatically on PR creation/updates
- Dependency audit runs when `dependencies` label is added to PR
- Failed tests provide artifacts and PR comments with actionable feedback

#### Manual Workflow Dispatch:
1. Go to Actions → Flutter Golden Tests
2. Click "Run workflow"
3. Choose options:
   - ✅ **Regenerate golden files**: Updates golden images and commits them
   - ✅ **Update dependencies**: Upgrades to latest compatible versions

#### PR Label Triggers:
- Add `regenerate-goldens` label: Automatically regenerates golden files
- Add `dependencies` label: Runs dependency audit and upgrade

#### Automated Features:
- **Dependency Management**: Automatic auditing and upgrading with workflow dispatch
- **Golden Regeneration**: Automated update and commit of golden files
- **PR Commenting**: Intelligent status updates with actionable recommendations
- **Version Consistency**: Enforces Flutter 3.22.0 across all environments
- **Artifact Retention**: Saves test results and golden files for debugging

## Benefits:

1. **Visual Regression Prevention**: Automatically detects unintended UI changes
2. **Reproducible Quality**: Consistent Flutter version ensures reliable results
3. **Developer Friendly**: Enhanced scripts with validation and guidance
4. **Advanced CI Integration**: Automated PR feedback and golden file management
5. **Dependency Management**: Automated auditing and safe upgrading
6. **Best Practices**: Follows Flutter golden test recommendations with enterprise-grade automation

This enhanced implementation provides enterprise-level golden test automation with intelligent dependency management for the Family Copilot application.