#  Copilot Instructions for Family_Copilot

## Mērķis

Šis fails definē norādījumus un sadarbības principus, kas palīdz GitHub Copilot un komandas locekļiem ģenerēt, pārskatīt un uzturēt kodu saskaņā ar projekta kvalitātes standartiem. Tas attiecas tikai uz repozitoriju `skrastins58-source/Family_Copilot`.

---

## Vadlīnijas Copilot lietošanai

- Izmanto Copilot, lai ģenerētu sākotnējo kodu, bet vienmēr pārskati un pielāgo to projekta stilam.
- Komentāriem jābūt skaidriem, kontekstuāliem un atbilstošiem funkcionalitātei.
- Izvairies no “magic numbers” — Copilot ģenerētos skaitļus aizvieto ar nosaukumiem vai konfigurācijām.
- Saglabā konsekventu nosaukšanas stilistiku:
  - `_buildWidget()` → UI komponenti
  - `_handleAction()` → notikumu apstrāde
  - `_formatData()` → datu formatēšana
- Komentāri rakstāmi latviešu un angļu valodā, ar skaidru uzdevuma aprakstu.

---

## Kvalitātes validācija

Copilot ģenerētais kods tiek pārbaudīts ar:

- LHCI konfigurāciju (`lighthouserc.json`)
- Golden testiem (`tests/golden`)
- Bundle size validāciju (`check-bundle-size.js`)
- Slack paziņojumiem par statusu

---

##  Artefakti un pārskati

- LHCI HTML reporti: `.lighthouseci/*.html`
- Golden diff attēli: `tests/diff/*.png`
- Bundle size analīze: `build/size-analysis.json`

---

##  PR komentāru automatizācija

Pēc testiem tiek ģenerēts PR komentārs ar kvalitātes kopsavilkumu, izmantojot `pr-comment.js`.

---

##  Ierobežojumi

Copilot nedrīkst ģenerēt kodu no šādiem ceļiem:

- `/goldens/`
- `/coverage/`
- `/firebase/`
- `/.dart_tool/`
- `/generated/`

Copilot nedrīkst ieteikt ārējas API integrācijas vai atkarības, ja tās nav definētas `pubspec.yaml` vai dokumentācijā (`README.md`).

---

## Tehniskā stilistika

- Izmanto `Provider` stāvokļa pārvaldībai
- Navigācijai izmanto `GoRouter` ar deep-link atbalstu
- UI komponentiem izmanto `Material Design 3`
- Ievēro clean architecture principus: Presentation → Logic → Data

- ### Validācija

Lai pārbaudītu testu pārklājumu, golden struktūru un CI statusu, palaidiet:

```bash
./validate.sh


---

## Konteksts

Šie norādījumi attiecas tikai uz `Family_Copilot` repozitoriju organizācijā `skrastins58-source`. Copilot nedrīkst izmantot ārēju repozitoriju kodu vai ieteikumus, kas nav saistīti ar šo projektu.

---

## Izņēmuma mehānisms

Ja Copilot divreiz pārprasa un lietotājs (Janis) apstiprina ar “jā”, Copilot drīkst pārkāpt kādu no iepriekš minētajiem ierobežojumiem konkrētajā kontekstā. Šis izņēmums attiecas tikai uz interaktīvu sesiju ar Janis, un tas nedrīkst tikt izmantots automātiski vai bez skaidras apstiprināšanas.

---## CI/CD Tokeni

Šie tokeni tiek izmantoti Family Copilot CI/CD plūsmās, golden testu validācijā un GitHub Container Registry (GHCR) autentifikācijā.

| Token                | Apraksts                                                                 | Pēdējā lietošana       |
|----------------------|--------------------------------------------------------------------------|------------------------|
| `DOCKER`             | Docker build/push autentifikācija un workflow konfigurācija              | last week              |
| `GHCR_SKRASTINS58SOURCE` | GHCR repozitorija identifikators skrastins58-source organizācijā     | 7 hours ago            |
| `GHCR_TOKEN`         | Autentifikācijas token GHCR push operācijām                              | 3 days ago             |
| `GH_PAT`             | GitHub Personal Access Token CI komentāriem un repo piekļuvei            | 4 days ago             |
| `GOLDEN`             | Golden testu aktivizēšanas token — izmanto, kad tiek norādīts            | 1 hour ago             |
| `PAT_TOKEN`          | CI/CD piekļuve PR komentāriem, artefaktiem un validācijas skriptiem      | pievienots README      |

> Visi tokeni tiek glabāti GitHub Secrets sadaļā un tiek izmantoti tikai CI/CD kontekstā.  
> Šī dokumentācija palīdz contributoram saprast, kā tokeni tiek izmantoti reproducējamības un drošības nodrošināšanai.



## Autori

Family Copilot Team — demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.
