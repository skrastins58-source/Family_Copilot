# Golden Test Images Directory

This directory contains golden images for widget tests. These images are used as references to detect visual changes in UI components.

## Golden Files:

- `my_widget.png` - Reference image for MyWidget container test
- `golden_text.png` - Reference image for text widget test  
- `material_container.png` - Reference image for Material Design container test

## Generating Golden Images:

### Automatic Script (Recommended):
```bash
./generate_goldens.sh
```

### Manual Generation:
```bash
flutter test test/widget_test.dart --update-goldens
```

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
4. **Validate**: Run `./scripts/validate_golden_structure.sh` to ensure proper structure
5. **Commit**: Add golden images to version control
6. **CI Validation**: GitHub Actions validates on PR

## Structure Validation:

Use the validation script to ensure proper golden test structure:

```bash
# Validate golden test structure
./scripts/validate_golden_structure.sh
```
✅ Statusa kopsavilkums
Komponents	Statuss	Detalizācija
Direktoriju struktūra	✅ Izveidota	tests/diff/ pievienots, placeholder .png faili izveidoti
Validācijas skripts	✅ Ieviests	validate_golden_structure.sh pārbauda struktūru, failu atbilstību, orphanus
CI integrācija	✅ Aktīva	Exit kods 0/1, PR komentāri, flutter-golden.yml
Dokumentācija	✅ Atjaunināta	goldens/README.md un README.md papildināti ar validācijas instrukcijām
Testu atbilstība	✅ Validēta	Visi 3 golden testi atpazīti, diff faili piesaistīti
Orphan detekcija	✅ Darbojas	Nav atrasti neatbilstoši faili
Kļūdu ziņošana	✅ Iekļauta	Krāsains output + exit kods CI plūsmā
📄 Dokumentācijas fragmenti
README.md papildinājums:
markdown
## 🧪 Golden testu struktūras validācija

Golden testu struktūra tiek validēta ar skriptu `validate_golden_structure.sh`, kas pārbauda:
- Failu atbilstību starp `goldens/` un `tests/diff/`
- Orphan failus bez testiem
- CI exit kodus reproducējamībai

Palaišana:
```bash
./scripts/validate_golden_structure.sh
Kods

### `goldens/README.md` papildinājums:
```markdown
## 📁 Diff failu izmantošana

Katram golden testam jābūt atbilstošam diff failam `tests/diff/`, pat ja tas ir tukšs.  
Šie faili tiek izmantoti CI artefaktu ģenerēšanai un vizuālai salīdzināšanai.
This script validates:
- All required directories exist (goldens/, tests/diff/, test/)
- Each golden test has corresponding files in both directories
- No orphaned files exist
- Proper file structure is maintained

The script provides detailed output with information, warnings, and errors, making it easy to identify and fix structural issues.
coment added
