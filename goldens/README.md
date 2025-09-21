# Golden Test Images Directory

This directory contains golden images for widget tests. These images are used as references to detect visual changes in UI components.

## Golden Files:

- `my_widget.png` - Reference image for MyWidget container test
- `golden_text.png` - Reference image for text widget test  
- `material_container.png` - Reference image for Material Design container test

## Generating Golden Images:

### Automatic Script (Recommended):
```bash
# Enhanced script with validation and dependency audit
./generate_goldens.sh

# With dependency audit
./generate_goldens.sh --audit-deps
```

### Manual Generation:
```bash
flutter test test/widget_test.dart --update-goldens
```

### Automated CI Generation:
- **Workflow Dispatch**: Actions → Flutter Golden Tests → "Regenerate golden files"
- **PR Labels**: Add `regenerate-goldens` label to any PR
- **Dependency Updates**: Add `dependencies` label for automated dependency audit

This will create/update the PNG files in this directory with the current appearance of the tested widgets.

## Running Golden Tests:

To run golden tests without updating images:
```bash
flutter test test/widget_test.dart
```

## Important Notes:

- **Version Control**: Golden images should be committed to version control
- **CI Integration**: Golden tests run in CI to prevent accidental visual regressions
- **Platform Consistency**: CI uses Ubuntu with Flutter 3.22.0 for consistent results
- **Font Rendering**: May vary between systems - use consistent Flutter version in CI
- **Test Environment**: Tests should use deterministic content (no time-dependent data)

## Troubleshooting:

### Golden Test Failures:
1. Check if UI changes are intentional
2. If changes are expected, regenerate golden images
3. Commit updated golden images to your branch

### Different Results Locally vs CI:
- Ensure using same Flutter version as CI (3.22.0)
- Check for platform-specific rendering differences
- Verify test uses consistent fonts and themes

## Workflow:

1. **Development**: Make UI changes
2. **Generate**: Run `./generate_goldens.sh` or `flutter test --update-goldens`
3. **Review**: Check generated images match expectations
4. **Commit**: Add golden images to version control
5. **CI Validation**: GitHub Actions validates on PR
coment added
### 🧪 `golden_accessibility_test.dart`

Tests the visual rendering of accessibility markup using Flutter’s `Semantics` widget.

- ✅ Validates screen reader labels and hints
- ✅ Ensures layout consistency with accessibility overlays
- ✅ Matches against `accessibility_screen_reader.png` golden snapshot

Lai palaistu testu / To run the test:
```bash
flutter test test/golden/golden_accessibility_test.dart
