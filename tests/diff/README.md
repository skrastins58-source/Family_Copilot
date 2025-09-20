# Golden Test Diff Directory

This directory contains diff images generated during golden test failures to help developers visualize differences between expected and actual widget rendering.

## Structure

For each golden test file `goldens/{test_name}.png`, there should be a corresponding:
- `tests/diff/{test_name}.png` - Diff image showing visual differences (empty file if no differences)

## Current Diff Files

- `my_widget.png` - Diff for MyWidget container test
- `golden_text.png` - Diff for text widget test  
- `material_container.png` - Diff for Material Design container test

## Usage

These files are:
- Generated automatically during golden test failures
- Used by CI/CD to provide visual feedback in PR comments
- Should be empty (0 bytes) when tests pass
- Updated when golden images are regenerated

## Notes

- Empty diff files indicate no visual changes detected
- Non-empty diff files contain visual comparison data
- Files are managed automatically by the golden test validation system