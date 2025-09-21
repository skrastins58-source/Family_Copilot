## 🧪 CLI rīks: `copilot validate`

Šis rīks apvieno visas Family Copilot kvalitātes pārbaudes vienā komandā:

- Golden testu struktūra (`goldens/` vs `diff/`)
- Coverage aprēķins (`lcov.info`)
- HTML pieejamības validācija (`landing.html`)
- Badge preview reproducējamībai

Palaišana:
```bash
bash scripts/copilot_validate.sh
