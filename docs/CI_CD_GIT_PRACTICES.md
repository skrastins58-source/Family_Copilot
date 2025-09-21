# CI/CD Git Labākās Prakses / CI/CD Git Best Practices

## Latviešu valodā

### Git Fetch Drošas Komandas CI/CD Vidē

Šis dokuments skaidro drošas git fetch prakses GitHub Actions un citās CI/CD vidēs, lai novērstu biežas kļūdas.

#### ❌ Problēma
Šāda komanda rada kļūdu CI vidē:
```bash
git fetch origin main:main
```

**Kļūdas ziņojums:**
```
fatal: refusing to fetch into branch 'refs/heads/main' checked out at '/path/to/repo'
```

#### ✅ Risinājums
Izmantojiet šīs drošās alternatīvas:

**1. Vienkārša fetch komanda:**
```bash
git fetch origin main
```

**2. Fetch ar remote reference:**
```bash
git fetch origin main:refs/remotes/origin/main
```

**3. Fetch ar papildu parametriem:**
```bash
git fetch --no-tags --prune --depth=1 origin main
```

#### Kāpēc rodas šī problēma?

- CI/CD runners bieži vien jau ir izvilkuši (`checkout`) galveno zaru (`main`)
- Git atsakās atjaunināt zaru, kas pašlaik ir aktīvs darba direktorijā
- Komanda `origin main:main` mēģina izveidot vai atjaunināt lokālo `main` zaru

#### Mūsu projekta piemēri

**Pareizi izmantots `.github/workflows/docker-ci.yml`:**
```yaml
- name: 🔄 Fetch origin/main safely
  run: |
    echo "Fetching origin/main for diff and validation"
    git fetch origin main
```

**Labots `.github/workflows/ci.yml`:**
```yaml
- name: Fetch main branch safely
  run: |
    # Fetch remote main branch without trying to update checked-out branch
    # This prevents "fatal: refusing to fetch into branch" error in CI
    git fetch origin main
```

---

## English

### Safe Git Fetch Commands in CI/CD Environment

This document explains safe git fetch practices in GitHub Actions and other CI/CD environments to prevent common errors.

#### ❌ Problem
This command causes errors in CI environment:
```bash
git fetch origin main:main
```

**Error message:**
```
fatal: refusing to fetch into branch 'refs/heads/main' checked out at '/path/to/repo'
```

#### ✅ Solution
Use these safe alternatives:

**1. Simple fetch command:**
```bash
git fetch origin main
```

**2. Fetch with remote reference:**
```bash
git fetch origin main:refs/remotes/origin/main
```

**3. Fetch with additional parameters:**
```bash
git fetch --no-tags --prune --depth=1 origin main
```

#### Why does this problem occur?

- CI/CD runners often already have the main branch checked out
- Git refuses to update a branch that is currently active in the working directory
- The command `origin main:main` tries to create or update the local `main` branch

#### Examples from our project

**Correctly used in `.github/workflows/docker-ci.yml`:**
```yaml
- name: 🔄 Fetch origin/main safely
  run: |
    echo "Fetching origin/main for diff and validation"
    git fetch origin main
```

**Fixed in `.github/workflows/ci.yml`:**
```yaml
- name: Fetch main branch safely
  run: |
    # Fetch remote main branch without trying to update checked-out branch
    # This prevents "fatal: refusing to fetch into branch" error in CI
    git fetch origin main
```

### Best Practices for Contributors

1. **Always test git commands locally** before adding them to CI workflows
2. **Use `git fetch origin <branch>`** instead of `git fetch origin <branch>:<branch>` in CI
3. **Add explanatory comments** to git commands in workflows
4. **Consider using `fetch-depth: 0`** in `actions/checkout` if you need full history
5. **Use appropriate fetch depth** (`--depth=1`) for performance when full history is not needed

### Troubleshooting

If you encounter git fetch issues in CI:

1. Check if the target branch is currently checked out
2. Use `git status` and `git branch -a` to debug the current state
3. Replace problematic fetch commands with safe alternatives from this guide
4. Test locally by switching to the target branch and running the fetch command

---

**Autori / Authors:** Family Copilot Team  
**Atjaunots / Updated:** 2024