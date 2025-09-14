# 🤖 Copilot Instructions for Family_Copilot

## 🧠 Mērķis
Šis fails definē norādījumus un sadarbības principus, kas palīdz GitHub Copilot un komandas locekļiem ģenerēt, pārskatīt un uzturēt kodu saskaņā ar projekta kvalitātes standartiem.

## ✅ Vadlīnijas Copilot lietošanai
- Izmanto Copilot, lai ģenerētu sākotnējo kodu, bet **vienmēr pārskati un pielāgo** to projekta stilam.
- Komentāriem jābūt skaidriem, kontekstuāliem un atbilstošiem funkcionalitātei.
- Izvairies no “magic numbers” — Copilot ģenerētos skaitļus aizvieto ar nosaukumiem vai konfigurācijām.

## 🔍 Kvalitātes validācija
Copilot ģenerētais kods tiek pārbaudīts ar:
- LHCI konfigurāciju (`lighthouserc.json`)
- Golden testiem (`tests/golden`)
- Bundle size validāciju (`check-bundle-size.js`)
- Slack paziņojumiem par statusu

## 📎 Artefakti un pārskati
- LHCI HTML reporti: `.lighthouseci/*.html`
- Golden diff attēli: `tests/diff/*.png`
- Bundle size analīze: `build/size-analysis.json`

## 💬 PR komentāru automatizācija
Pēc testiem tiek ģenerēts PR komentārs ar kvalitātes kopsavilkumu, izmantojot `pr-comment.js`.

---

> Šis fails tiek automātiski ielādēts un interpretēts kā sadarbības vadlīnijas Copilot un komandas locekļiem.
