# Golden Test Diff Images Directory

This directory contains comparison images showing differences when golden tests fail.

## Structure:

- `my_widget_diff.png` - Diff image for MyWidget container test
- `golden_text_diff.png` - Diff image for text widget test  
- `material_container_diff.png` - Diff image for Material Design container test

## How Diff Images Work:

When golden tests fail due to visual changes, Flutter can generate diff images that highlight the differences between:
- **Expected**: The reference golden image
- **Actual**: The current test output
- **Diff**: Visual comparison highlighting changes

## Usage:

### During Test Failures:
```bash
# Run tests to see failures
flutter test test/widget_test.dart

# Check for generated diff images in test/failures/
ls test/failures/
```

### Copying Diffs to Documentation:
```bash
# Copy failure diffs to docs for documentation
cp test/failures/*_diff.png docs/diff/
```

## Workflow Integration:

1. **Test Failure**: Golden test detects visual regression
2. **Diff Generation**: Flutter creates diff images in `test/failures/`
3. **CI Upload**: GitHub Actions uploads failure artifacts
4. **Documentation**: Copy significant diffs to `docs/diff/` for reference

## Important Notes:

- **Version Control**: Diff images in `docs/diff/` should be committed for documentation
- **Temporary Files**: Diff images in `test/failures/` are temporary and not committed
- **Review Process**: Use diff images to understand visual changes before updating golden images
- **File Naming**: Diff images should match golden file names with `_diff` suffix

## Example Diff Image Interpretation:

- **Red areas**: Removed content
- **Green areas**: Added content  
- **Yellow areas**: Modified content
- **White areas**: Unchanged content

This helps developers quickly identify what changed in the UI and decide whether to accept or reject the changes.