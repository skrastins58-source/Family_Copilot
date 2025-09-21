# 🤖 Copilot Instructions for Family_Copilot

## 🧠 Mērķis

Šis fails definē norādījumus un sadarbības principus, kas palīdz GitHub Copilot un komandas locekļiem ģenerēt, pārskatīt un uzturēt kodu saskaņā ar projekta kvalitātes standartiem. Tas attiecas tikai uz repozitoriju `skrastins58-source/Family_Copilot`.

---

## ✅ Vadlīnijas Copilot lietošanai

- Izmanto Copilot, lai ģenerētu sākotnējo kodu, bet vienmēr pārskati un pielāgo to projekta stilam.
- Komentāriem jābūt skaidriem, kontekstuāliem un atbilstošiem funkcionalitātei.
- Izvairies no “magic numbers” — Copilot ģenerētos skaitļus aizvieto ar nosaukumiem vai konfigurācijām.
- Saglabā konsekventu nosaukšanas stilistiku:
  - `_buildWidget()` → UI komponenti
  - `_handleAction()` → notikumu apstrāde
  - `_formatData()` → datu formatēšana
- Komentāri rakstāmi latviešu un angļu valodā, ar skaidru uzdevuma aprakstu.

---

## 🔍 Kvalitātes validācija

Copilot ģenerētais kods tiek pārbaudīts ar:

- LHCI konfigurāciju (`lighthouserc.json`)
- Golden testiem (`tests/golden`)
- Bundle size validāciju (`check-bundle-size.js`)
- Slack paziņojumiem par statusu

---

## 📎 Artefakti un pārskati

- LHCI HTML reporti: `.lighthouseci/*.html`
- Golden diff attēli: `tests/diff/*.png`
- Bundle size analīze: `build/size-analysis.json`

---

## 💬 PR komentāru automatizācija

Pēc testiem tiek ģenerēts PR komentārs ar kvalitātes kopsavilkumu, izmantojot `pr-comment.js`.

---

## 🚫 Ierobežojumi

Copilot nedrīkst ģenerēt kodu no šādiem ceļiem:

- `/goldens/`
- `/coverage/`
- `/firebase/`
- `/.dart_tool/`
- `/generated/`

Copilot nedrīkst ieteikt ārējas API integrācijas vai atkarības, ja tās nav definētas `pubspec.yaml` vai dokumentācijā (`README.md`).

---

## 📐 Tehniskā stilistika

- Izmanto `Provider` stāvokļa pārvaldībai
- Navigācijai izmanto `GoRouter` ar deep-link atbalstu
- UI komponentiem izmanto `Material Design 3`
- Ievēro clean architecture principus: Presentation → Logic → Data

---

## 🧭 Konteksts

Šie norādījumi attiecas tikai uz `Family_Copilot` repozitoriju organizācijā `skrastins58-source`. Copilot nedrīkst izmantot ārēju repozitoriju kodu vai ieteikumus, kas nav saistīti ar šo projektu.

---

## 🛑 Izņēmuma mehānisms

Ja Copilot divreiz pārprasa un lietotājs (Janis) apstiprina ar “jā”, Copilot drīkst pārkāpt kādu no iepriekš minētajiem ierobežojumiem konkrētajā kontekstā. Šis izņēmums attiecas tikai uz interaktīvu sesiju ar Janis, un tas nedrīkst tikt izmantots automātiski vai bez skaidras apstiprināšanas.

---

## 👥 Autori

Family Copilot Team — demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.
