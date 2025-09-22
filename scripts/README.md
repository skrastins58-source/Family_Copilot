# 🧪 CI/CD Automatizācijas Skripti / CI/CD Automation Scripts

*Latviešu* | *English*

Šī direktorija satur automatizācijas skriptus Family_Copilot projekta CI/CD procesiem. Visi skripti ir izstrādāti, lai ievērotu skrastins58-source standartus un nodrošinātu efektīvu izstrādes plūsmu.

This directory contains automation scripts for Family_Copilot project's CI/CD processes. All scripts are developed to follow skrastins58-source standards and ensure efficient development workflow.

## 📋 Skriptu Apraksts / Scripts Overview

| Skripts / Script | Apraksts / Description | Lietošana / Usage |
|------------------|------------------------|-------------------|
| `check_and_label_prs.sh` | **LV:** Pārbauda PR statusu un pievieno etiķetes "ready-to-merge"<br>**EN:** Checks PR status and adds "ready-to-merge" labels | `./check_and_label_prs.sh` |
| `check_golden_diff.sh` | **LV:** Pārbauda vai golden attēli atšķiras no galvenās zara versijas<br>**EN:** Checks if golden images differ from main branch version | `./check_golden_diff.sh main` |
| `validate_golden_structure.sh` | **LV:** Validē ka goldens/ direktorijā ir tikai .png faili<br>**EN:** Validates that goldens/ directory contains only .png files | `./validate_golden_structure.sh` |
| `update_artifact_versions.sh` | **LV:** Atjaunina GitHub Actions artifact darbības uz v4<br>**EN:** Updates GitHub Actions artifact actions to v4 | `./update_artifact_versions.sh` |
| `post-pr-summary.js` | **LV:** Publicē PR kopsavilkumu ar validācijas rezultātiem<br>**EN:** Posts PR summary with validation results | `./post-pr-summary.js` |

## 🛠️ Prasības / Requirements

### Vispārīgas prasības / General Requirements:
- **bash** - standarta Unix čaula / standard Unix shell
- **git** - versiju kontroles sistēma / version control system
- **find, sed, grep** - standarta Unix utilītas / standard Unix utilities

### Specifiskas prasības / Specific Requirements:

#### check_and_label_prs.sh
- **GitHub CLI (gh)** - instalēts un autentificēts / installed and authenticated
- **jq** - JSON procesors / JSON processor
- Piekļuve repozitorija PR / Repository PR access

#### post-pr-summary.js  
- **Node.js** - JavaScript izpildvide / JavaScript runtime
- **GitHub CLI (gh)** - konfigurēts PR komentāriem / configured for PR comments

## 📖 Detalizēta lietošana / Detailed Usage

### 1. PR Statusa Pārbaude / PR Status Check
```bash
# Pārbauda visus PR un pievieno etiķetes
# Checks all PRs and adds labels
./scripts/check_and_label_prs.sh
```

**Funkcionalitāte / Functionality:**
- Izgūst visu PR sarakstu / Retrieves all PR list
- Pārbauda CI statusu / Checks CI status  
- Analizē review statusu / Analyzes review status
- Pievieno/noņem "ready-to-merge" etiķetes / Adds/removes "ready-to-merge" labels
- Ģenerē Markdown tabulu / Generates Markdown table

### 2. Golden Attēlu Validācija / Golden Image Validation
```bash
# Pārbauda atšķirības no galvenā zara
# Checks differences from main branch
./scripts/check_golden_diff.sh main

# Pārbauda attēlu struktūru
# Checks image structure
./scripts/validate_golden_structure.sh
```

**Golden testu workflow / Golden test workflow:**
1. **Izstrāde / Development:** UI komponenšu izmaiņas / UI component changes
2. **Validācija / Validation:** Skriptu palaišana / Running scripts
3. **CI/CD:** Automātiska pārbaude / Automatic validation

### 3. Artefaktu Versiju Atjaunināšana / Artifact Version Updates
```bash
# Atjaunina workflow failus
# Updates workflow files
./scripts/update_artifact_versions.sh
```

**Rezultāts / Result:**
- Visi `actions/upload-artifact@v1-v3` → `@v4`
- Visi `actions/download-artifact@v1-v3` → `@v4`
- Automātiska failu rediģēšana / Automatic file editing

### 4. PR Kopsavilkuma Publicēšana / PR Summary Publishing
```bash
# Publicē kvalitātes reportu
# Publishes quality report
./scripts/post-pr-summary.js
```

## 🔧 Konfigurācija / Configuration

### GitHub CLI autentifikācija / GitHub CLI Authentication:
```bash
# Autentificēties ar GitHub
# Authenticate with GitHub
gh auth login

# Pārbaudīt statusu
# Check status
gh auth status
```

### Node.js un atkarības / Node.js and Dependencies:
```bash
# Pārbaudīt Node.js versiju
# Check Node.js version
node --version

# Uzstādīt jq (Ubuntu/Debian)
# Install jq (Ubuntu/Debian)
sudo apt-get install jq
```

## 🚫 Ierobežojumi / Limitations

**Atbilstoši Family_Copilot noteikumiem / According to Family_Copilot guidelines:**

- ❌ Nav atļautas ārējas API integrācijas / No external API integrations allowed
- ❌ Nav atļautas jaunas atkarības / No new dependencies allowed  
- ✅ Tikai bash, Node.js, GitHub CLI (gh) / Only bash, Node.js, GitHub CLI (gh)
- ✅ Ievēro Family_Copilot nosaukšanas standartus / Follow Family_Copilot naming standards

## 🔍 Problēmu novēršana / Troubleshooting

### Biežākie jautājumi / Common Issues:

#### "gh: command not found"
```bash
# Ubuntu/Debian
sudo apt-get install gh

# macOS
brew install gh

# Windows
winget install GitHub.cli
```

#### "jq: command not found"  
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS  
brew install jq
```

#### "Permission denied"
```bash
# Padarīt skriptu izpildāmu
# Make script executable
chmod +x scripts/script_name.sh
```

#### Golden testi neizdodas / Golden tests failing
```bash
# Atjaunināt golden attēlus lokāli
# Update golden images locally
flutter test --update-goldens

# Pārbaudīt izmaiņas
# Check changes
git status goldens/
```

## 📚 Papildus resursi / Additional Resources

- [GitHub CLI dokumentācija / GitHub CLI documentation](https://cli.github.com/manual/)
- [jq dokumentācija / jq documentation](https://stedolan.github.io/jq/manual/)
- [Family_Copilot Golden testi / Family_Copilot Golden tests](../GOLDEN_TESTS.md)
- [GitHub Actions Artifact v4](https://github.com/actions/upload-artifact/releases/tag/v4.0.0)

## 👥 Autori / Authors

Family Copilot Team - demonstrējot GitHub Copilot labākās prakses CI/CD automatizācijā.

Family Copilot Team - demonstrating GitHub Copilot best practices in CI/CD automation.

---

*Pēdējais atjauninājums / Last updated: $(date '+%Y-%m-%d')*