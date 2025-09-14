
# Family Copilot

Flutter projekts, kas demonstrē GitHub Copilot labākās prakses un uzlabo ziņu sistēmu ar deep-link navigāciju, vizuāliem paziņojumiem, CI/CD automatizāciju un personalizētu filtrēšanu. Lietotāji saņem tikai sev aktuālas ziņas, un izstrādātāji iegūst efektīvu darba plūsmu ar Firebase Functions un GitHub Actions.

## Testēšana un Code Coverage

📈 **Zarojumu slieksnis atjaunots uz 80%** - pēc visaptverošas UI testu sistēmas pievienošanas `test/main_test.dart` failā, kas nodrošina:

- **App inicializācijas testus** ar Provider un MaterialApp (main.dart)
- **Iestatījumu izvēles loģiku** un UI reakcijas (settings_screen.dart) 
- **Tumšā režīma pārbaudi** ar pilnu funkcionalitāti (settings_screen.dart)
- **Kļūdu apstrādes piemērus** ar dialogi un validāciju (settings_screen.dart)
- **Edge case un integrācijas testus** stāvokļa pārvaldībai

Zarojumu sliekšņa paaugstināšana uz 80% atspoguļo stabilo testu infrastruktūru, kas nodrošina augstu koda kvalitāti un mazina bugs risku production vidē.

### Kvalitātes Kritēriji un Validācijas Sliekšņi

| **Validācijas veids** | **Kritērijs** | **Slieksnis** | **Statuss** | **Darbība** |
|----------------------|---------------|---------------|-------------|-------------|
| 🏎️ **LHCI Performance** | First Contentful Paint (FCP) | ≤ 2000ms | ⚠️ Warn | Optimizēt resursu ielādi |
| ⚡ **LHCI Interactive** | Time to Interactive (TTI) | ≤ 3000ms | ⚠️ Warn | Samazināt JavaScript izmēru |
| ♿ **LHCI Accessibility** | Accessibility Score | ≥ 0.9 (90%) | ❌ Error | Obligāta labošana |
| 🔍 **LHCI SEO** | SEO Score | ≥ 0.9 (90%) | ⚠️ Warn | Meta tagu optimizācija |
| 🧪 **Golden Tests** | Visual Regression | 0 izmaiņas | ❌ Error | UI konsistences pārbaude |
| 📦 **Bundle Size** | Build izmērs | < 5MB | ⚠️ Warn | Dependencies audits |
| 🧹 **Code Coverage** | Zaru segums | ≥ 80% | ❌ Error | Testu paplašināšana |

**Automatizētas pārbaudes PR procesos:**
- ✅ LHCI rezultāti ar emoji statusiem un artefaktu saitēm
- ✅ Bundle size salīdzinājums ar iepriekšējām versijām
- ✅ Golden test diff vizualizācija
- ✅ Coverage delta atskaites

## GitHub Copilot Labākās Prakses

Šis projekts demonstrē, kā rakstīt kodu, lai GitHub Copilot sniegtu vislabākos ieteikumus:

### 1. Skaidri Komentāri ar Mērķiem

```dart
// Izveido widgetu, kas parāda paziņojumu ar attēlu
// Demonstrates how to create notifications with images
class NotificationWithImageWidget extends StatelessWidget {
  // Widget implementation...
}
```

**Labās prakses:**
- Komentāri latviešu un angļu valodā, lai Copilot saprastu kontekstu
- Skaidri definēti uzdevumi un mērķi
- Funkciju un klašu nolūku apraksti

### 2. Konsekventas Importu Struktūras

```dart
// Consistent import grouping for better Copilot suggestions
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// Project imports grouped separately
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'models/notification_model.dart';
```

**Labās prakses:**
- Flutter SDK imports pirmie
- Trešo pušu pakotnes grupētas
- Projekta faili atsevišķi
- Konsekventas pakotnes izmantošanas (`flutter_local_notifications`, `provider`, `go_router`)

### 3. Precīzi Definēti Uzdevumi

```dart
/// Builds notification header with image and type indicator
/// Visual header with notification branding
Widget _buildNotificationHeader(BuildContext context, NotificationModel notification) {
  // Clear purpose helps Copilot understand context
}

/// Formats timestamp to human-readable relative time
/// Helper method for better user experience
String _formatTimestamp(DateTime timestamp) {
  // Specific utility function with clear documentation
}
```

### 4. Strukturēta Koda Organizācija

```
lib/
├── main.dart                 # App entry point with provider setup
├── models/                   # Data models with clear structure
│   └── notification_model.dart
├── screens/                  # Screen widgets with consistent patterns
│   ├── home_screen.dart
│   ├── notifications_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable UI components
│   └── notification_with_image_widget.dart
├── services/                 # Business logic and API services
│   └── notification_service.dart
├── providers/                # State management
│   └── app_state_provider.dart
└── utils/                    # Helper functions and utilities
    └── app_router.dart
```

### 5. Paredzama Kodēšanas Stilistika

**Nosaukšanas konvencijas:**
- `_buildWidget()` - UI komponenšu veidošanai
- `_handleAction()` - notikumu apstrādei
- `_showDialog()` - dialoga parādīšanai
- `_formatData()` - datu formatēšanai

**Komentāru stils:**
```dart
/// Public method documentation with triple slashes
/// Clear description of method purpose and behavior
void publicMethod() {}

// Private method comments with double slashes
// Internal implementation details
void _privateMethod() {}
```

## Projekta Funkcionalitāte

### Paziņojumu Sistēma
- **Vizuālie paziņojumi ar attēliem** - NotificationWithImageWidget
- **Lokālie un push paziņojumi** - Flutter Local Notifications + Firebase
- **Personalizēta filtrēšana** - lietotāju preferences ar Provider
- **Deep-link navigācija** - GoRouter konfigurācija

### Lietotāja Pieredze
- **Material Design 3** - mūsdienīgs UI dizains
- **Tumšais režīms** - tema pārslēgšana
- **Vairākvalodu atbalsts** - LV/EN/RU
- **Accessibility** - screen reader atbalsts

### Tehniskie Risinājumi
- **State Management** - Provider pattern
- **Persistance** - SharedPreferences
- **Routing** - GoRouter ar deep-links
- **Error Handling** - comprehensive error states

## Instalācija un Pokretanje

```bash
# Klonēt repozitoriju
git clone https://github.com/skrastins58-source/Family_Copilot.git
cd Family_Copilot

# Instalēt dependencies
flutter pub get

# Pokreniti aplikāciju
flutter run
```

## Copilot Lietošanas Ieteikumi

1. **Rakstiet skaidrus komentārus** pirms koda rakstīšanas
2. **Izmantojiet konsekventas importu struktūras**
3. **Definējiet precīzus uzdevumus** metožu nosaukumos
4. **Saglabājiet paredzamu koda stilu** visā projektā
5. **Dokumentējiet sarežģītas loģikas daļas** ar detalizētiem komentāriem

## Arhitektūra

Projekts izmanto **clean architecture** principus:

- **Presentation Layer**: Screens un Widgets
- **Business Logic Layer**: Providers un Services  
- **Data Layer**: Models un persistence

Katrs slānis ir skaidri atdalīts un dokumentēts, ļaujot GitHub Copilot labāk saprast koda struktūru un sniegt precīzākus ieteikumus.

## Autori

Family Copilot Team - demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.
=======
# Family_Copilot

# 🎵 Flutter Funkcionalitātes Uzlabojumi

Šī ir Flutter aplikācija ar uzlabotu ziņu sistēmu, CI/CD automatizāciju un personalizētu lietotāja pieredzi. Projekts ir veidots ar mērķi padarīt paziņojumus interaktīvus, vizuāli pievilcīgus un lietotājam nozīmīgus.

## 🚀 Funkcionalitātes

- **Deep-link uz konkrētu ziņu** — lietotājs, pieskaroties paziņojumam, tiek novirzīts uz attiecīgo ziņu ekrānu.
- **Vizuāli īpaši paziņojumi** — paziņojumi ar attēliem, ikonām un tēmas stilu.
- **CI/CD ar Firebase Functions** — automātiska funkciju izvietošana ar GitHub Actions.
- **Personalizēta ziņu filtrēšana** — ziņas tiek rādītas un sūtītas atbilstoši lietotāja interesēm.

📌 **Zarojumu slieksnis atjaunots uz 80%** pēc visaptverošas UI testu sistēmas pievienošanas, kas nodrošina augstu koda kvalitāti un coverage metrikas.

## 🧰 Tehnoloģijas

- Flutter 3.x
- Firebase (Messaging, Firestore, Functions)
- GitHub Actions
- flutter_local_notifications

## 📦 Instalācija

```bash
git clone https://github.com/tavs-lietotajvards/flutter-funkcionalitates.git
cd flutter-funkcionalitates
flutter pub get
Šis Flutter projekts uzlabo ziņu sistēmu ar deep-link navigāciju, vizuāliem paziņojumiem, CI/CD automatizāciju un personalizētu filtrēšanu. Lietotāji saņem tikai sev aktuālas ziņas, un izstrādātāji iegūst efektīvu darba plūsmu ar Firebase Functions un GitHub Actions

