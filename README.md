
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

## CI/CD Vizuālās Kvalitātes Validācija

Family Copilot projekts izmanto progresīvu CI/CD sistēmu, kas nodrošina augstu vizuālās kvalitātes standartu:

### 🔍 Lighthouse CI Integrācija
- **Web Performance Audits**: Automātiski pārbauda web aplikācijas performance, accessibility, best practices un SEO
- **Slieksņi**: Performance ≥70%, Accessibility ≥90%, Best Practices ≥85%, SEO ≥80%
- **Workflow**: `.github/workflows/lighthouse.yml`
- **Konfigurācija**: `.lighthouserc.js` ar Flutter-specifiskiem iestatījumiem

### 📦 Flutter Bundle Size Monitoring
- **APK Size Monitoring**: Maksimālais APK lielums 50MB (Android arm64)
- **Web Bundle Tracking**: Maksimālais web bundle lielums 10MB
- **Automātiskas brīdinājumi**: PR komentāri ar size analīzi
- **Size Analysis Reports**: JSON formātā ar detalizētu informāciju

### 🎨 Golden Tests / UI Regresijas Testi
- **Visual Regression Testing**: Automātiski salīdzina UI komponenšu screenshots
- **Baseline Management**: Glabā etalona attēlus `goldens/` mapē
- **Test Coverage**: Home, Settings, Notifications screens + komponenti
- **Dark/Light Mode**: Atsevišķi testi abiem tēmas režīmiem

### 📋 Workflow Fails
```
.github/workflows/
├── lighthouse.yml      # Web performance audits
├── flutter-size.yml    # Bundle size monitoring  
└── flutter-golden.yml  # UI regression tests
```

### 🛠 Lokālā Lietošana

**Lighthouse pārbaudes:**
```bash
npm install
npm run lhci:autorun
```

**Bundle size analīze:**
```bash
flutter build apk --analyze-size
flutter build web --analyze-size
```

**Golden testi:**
```bash
# Palaisīt testus
flutter test test/widget_test.dart

# Atjaunot baseline attēlus
flutter test test/widget_test.dart --update-goldens
```

### 🎯 Kvalitātes Metriku Uzraudzība

Visi CI/CD procesi veido detalizētus ziņojumus PR komentāros:
- Lighthouse rezultāti ar kategoriju vērtējumiem
- Bundle size salīdzinājumi ar slieksnim
- Golden test rezultāti ar vizuālās regresijas brīdinājumiem

Šī sistēma nodrošina, ka katrs koda commit saglabā augstu vizuālās kvalitātes standartu un performance rādītājus.

## Autori

Family Copilot Team - demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.

