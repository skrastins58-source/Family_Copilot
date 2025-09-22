# 🖼️ Golden testu CI/CD validācija / Golden Test CI/CD Validation

Golden testi Family Copilot projektā nodrošina, ka lietotāja interfeisa vizuālais izskats nemainās negaidīti starp izstrādes cikliem. Šī validācijas sistēma ir izstrādāta, domājot par reproducējamību, uzticamību un contributor-first pieredzi.

Golden tests in the Family Copilot project guarantees that the visual appearance of the user interface remains stable and reproducible across development cycles. This validation system is designed with reproducibility, trust, and a contributor-first mindset.

---

## ✅ Golden testu CI/CD validācijas uzdevumi / Golden Test CI/CD Validation Tasks

### 1. **Sagatavot golden testu struktūru / Prepare the golden test structure**
- Izveidot `goldens/expected/`, `goldens/actual/`, `goldens/diff/` direktorijas  
  _Create the `goldens/expected/`, `goldens/actual/`, and `goldens/diff/` directories_
- Nodrošināt, ka visi golden faili ir `.png` formātā  
  _Ensure all golden files are in `.png` format_
- Dokumentēt struktūru `test/ui/README.md`  
  _Document the structure in `test/ui/README.md`_

---

### 2. **Izstrādāt validācijas skriptu / Develop the validation script**
- `validate_golden_structure.sh`: salīdzina failu nosaukumus `expected/` un `diff/`  
  _Compares file names between `expected/` and `diff/`_
- Pārbauda, vai `goldens/` satur tikai `.png` failus  
  _Checks that `goldens/` contains only `.png` files_
- Integrēts `validate.sh` kā viens ieejas punkts  
  _Integrated as a single entry point via `validate.sh`_

---

### 3. **Integrēt CI/CD validāciju / Integrate CI/CD validation**
- Pievienot `flutter-golden.yml` workflow  
  _Add `flutter-golden.yml` workflow_
- Iekļaut golden testu struktūras validāciju kā atsevišķu soli  
  _Include golden structure validation as a separate step_
- Pievienot coverage enforcement (≥ 80%) ar `check_coverage.sh`  
  _Add coverage enforcement (≥ 80%) using `check_coverage.sh`_
- Augšupielādēt artefaktus (diff attēli, coverage report)  
  _Upload artifacts (diff images, coverage report)_

---

### 4. **Automatizēt PR komentārus / Automate PR comments**
- Pievienot `actions-comment-pull-request@v2`  
  _Add `actions-comment-pull-request@v2`_
- Komentārs divās valodās (LV + EN), ja golden testi vai coverage neiztur  
  _Comment in both Latvian and English if golden tests or coverage fail_
- Iekļaut saiti uz artefaktiem un kļūdu kopsavilkumu  
  _Include link to artifacts and error summary_

---

### 5. **Dokumentēt validācijas loģiku / Document validation logic**
- `copilot-instructions.md`: aprakstīt golden testu CI validāciju  
  _Describe golden test CI validation in `copilot-instructions.md`_
- `test/ui/README.md`: paskaidrot golden testu palaišanu, atjaunošanu un diff interpretāciju  
  _Explain golden test running, updating, and diff interpretation in `test/ui/README.md`_
- Pievienot `validate.sh` kā galveno validācijas komandu  
  _Add `validate.sh` as the main validation command_

---

### 6. **Paplašināt reproducējamību / Expand reproducibility**
- Pievienot golden testus ar `golden_toolkit`  
  _Add golden tests with `golden_toolkit`_
- Nodrošināt platformu-agnostisku renderēšanu  
  _Ensure platform-agnostic rendering_
- Pievienot badge preview loģiku README failā  
  _Add badge preview logic in the README file_

---

## ℹ️ Uzticama vizuālā validācija katram contributoram
Šī validācijas sistēma ne tikai sargā vizuālo kvalitāti, bet arī stiprina uzticību contributoru darbam. Visi soļi ir dokumentēti un reproducējami, padarot golden testu uzturēšanu caurspīdīgu un draudzīgu jebkuram komandas dalībniekam.

This validation system not only protects visual quality, but also builds trust in every contributor’s work. All steps are documented and reproducible, making golden test maintenance transparent and contributor-friendly.