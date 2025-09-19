# www - Family Copilot mājaslapas UI

Šis folderis satur Family_Copilot projekta saskarni (UI) – HTML, CSS un grafiku failus, kas veido digitālu ģimenes platformu.

## Struktūra

```
www/
├── index.html               # Galvenā lapa
├── kapec.html               # Kāpēc tas ir svarīgi
├── family-ui.html           # Ģimenes UI sadaļa
├── parents_corner.html      # Vecāku stūrītis
├── style.css                # Kopējie stili visām lapām
├── assets/                  # SVG un attēlu folderis
│   ├── logo.svg
│   ├── animated-avatar.svg
│   ├── animated-message.svg
│   └── calendar-mockup.jpg
```

## Lietošana

1. **Atver index.html** – tā ir mājaslapas sākumlapa.
2. **Navigē caur lapām** izmantojot galvenes izvēlni (`nav`), lai apskatītu katru sadaļu.
3. **Stili** tiek lietoti no `style.css` automātiski visām lapām.
4. **Attēlus un SVG** izmanto no `assets/` foldera.
5. **Lapas vari skatīt lokāli** – atver ar Chrome/Edge/Firefox vai izmanto VS Code Live Server.

## Kā pievienot jaunu sadaļu

1. Izveido jaunu HTML failu šajā folderī (piem. `jauna_sadala.html`)
2. Pievieno vajadzīgo saturu, iekļauj `<link rel="stylesheet" href="style.css">` galvā.
3. Papildini navigāciju (`nav` blokā) visās lapās ar jauno sadaļu.

## Kā pievienot attēlus/SVG

- Saglabā failu `assets/` folderī.
- Atsaucies uz to HTML failos ar ceļu `assets/fails.svg` vai `assets/fails.jpg`.

## Priekšskatīšana

- Visas lapas ir statiskas HTML/CSS – nav nepieciešama backend vai datubāze.
- Lokāli vari atvērt failus ar pārlūkprogrammu.
- Ja repo ir GitHub Pages, vari publicēt www folderi kā mājaslapu.

## Autors

Projekts un dizains: [skrastins58-source](https://github.com/skrastins58-source)

---
