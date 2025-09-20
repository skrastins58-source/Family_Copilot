# Scripts Directory

This directory contains automation and validation scripts for the Family Copilot project.

## Available Scripts

### 🖼️ `validate_golden_files.sh`
**Purpose**: Validates consistency between golden image files and test references

**Features**:
- Checks that all golden files referenced in tests exist
- Identifies orphaned golden files not used in tests
- Validates that golden files are not empty (have content)
- Provides clear error messages and resolution suggestions

**Usage**:
```bash
./scripts/validate_golden_files.sh
```

**CI Integration**: Runs automatically in `ci.yml` and `flutter-golden.yml` workflows

### 📊 `check_coverage.sh`
**Purpose**: Validates code coverage meets minimum thresholds

**Features**:
- Reads coverage thresholds from `coverage-summary.json`
- Validates LCOV coverage data
- Provides detailed coverage statistics
- Supports configurable minimum coverage requirements

**Usage**:
```bash
# First generate coverage data
flutter test --coverage

# Then check thresholds
./scripts/check_coverage.sh
```

**CI Integration**: Runs automatically in `ci.yml` workflow after test execution

### 🧪 `test_validations.sh`
**Purpose**: Test runner for validation scripts

**Features**:
- Tests both golden file and coverage validation scripts
- Provides comprehensive validation of validation logic
- Useful for local development and CI debugging

**Usage**:
```bash
./scripts/test_validations.sh
```

### 🏷️ `check_and_label_prs.sh`
**Purpose**: Automated PR labeling and status checking

**Features**:
- Checks PR merge readiness
- Manages PR labels automatically
- Generates PR status tables

**Usage**:
```bash
./scripts/check_and_label_prs.sh
```

## CI/CD Integration

These scripts are integrated into the GitHub Actions workflows:

- **`ci.yml`**: Includes coverage validation and golden file validation
- **`flutter-golden.yml`**: Focuses on golden test validation
- **Automated execution**: All validations run on every PR and push

## Error Handling

All scripts provide:
- Clear error messages with context
- Suggested solutions for common issues
- Proper exit codes for CI integration
- Colorized output for better readability

## Contributing

When adding new validation scripts:
1. Follow the established patterns for error handling and output formatting
2. Add the script to `test_validations.sh` 
3. Integrate into appropriate CI workflows
4. Update this README with documentation
5. Ensure scripts are executable (`chmod +x`)