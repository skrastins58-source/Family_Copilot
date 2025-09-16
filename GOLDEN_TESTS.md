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
# Generate golden images
./generate_goldens.sh

# Or manually:
flutter test test/widget_test.dart --update-goldens

# Run tests without updating:
flutter test test/widget_test.dart
```

### CI/CD:
- Golden tests run automatically on PR creation/updates
- Failed tests provide artifacts and PR comments
- Validates both new and existing golden images

## Benefits:

1. **Visual Regression Prevention**: Automatically detects unintended UI changes
2. **Reproducible Quality**: Consistent Flutter version ensures reliable results
3. **Developer Friendly**: Clear documentation and helper scripts
4. **CI Integration**: Automated validation in pull requests
5. **Best Practices**: Follows Flutter golden test recommendations

This implementation provides a solid foundation for maintaining visual consistency in the Family Copilot application.