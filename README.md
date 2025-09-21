
# Family Copilot

Flutter projekts, kas demonstrē GitHub Copilot labākās prakses un uzlabo ziņu sistēmu ar deep-link navigāciju, vizuāliem paziņojumiem, CI/CD automatizāciju un personalizētu filtrēšanu. Lietotāji saņem tikai sev aktuālas ziņas, un izstrādātāji iegūst efektīvu darba plūsmu ar Firebase Functions un GitHub Actions.

## 🛠️ Instalācija

1. Klonē repo:
git clone https://github.com/skrastins58-source/Family_Copilot.git

Kods
2. Iej dziļāk projekta mapē:
cd Family_Copilot

Kods
3. Instalē atkarības (piem., Flutter):
flutter pub get

Kods
4. Palaid lokāli:
flutter run

Kods
5. Ja izmanto Firebase: pievieno `google-services.json` (android/app/) un `GoogleService-Info.plist` (ios/Runner/).

---

## 🚧 Roadmap (MVP tuvākajām kārtām)

- [x] Sākuma HTML/CSS lapas un assets direktorija
- [x] Docs index + navigācija
- [ ] "Trīs Labie Vārdi" rituāla UI un saglabāšana
- [ ] Personalizēti avataru profili un attēlu upload
- [ ] Notifikāciju tips pēc locekļa preferences
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

## 🖼️ Golden testi

Golden testi salīdzina komponentu vizuālo izskatu ar iepriekš saglabātu attēlu (`goldens/`), lai pamanītu netīšas UI izmaiņas.

### Piemērs:
```dart
testWidgets('MyWidget golden test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('goldens/my_widget.png'),
  );
});
```

Golden testi tiek izpildīti CI vidē ar GitHub Actions (`flutter-golden.yml`).

CI workflow satur `flutter test --update-goldens` komandu.

Golden attēls jāģenerē lokāli ar:
```bash
flutter test --update-goldens
```

Pievieno attēlu versiju kontrolei.

Mērķis: Stabilizēt UI golden testu plūsmu un ieviest reproducējamu vizuālās kvalitātes validāciju projekta CI/CD.

### Golden testu workflow:

1. **Lokālā izstrāde**: Izstrādātājs izveido vai atjaunina UI komponentus
2. **Golden attēlu ģenerēšana**: Palaiž `flutter test --update-goldens` lai izveidotu reference attēlus
3. **Commit un push**: Pievieno jaunos golden attēlus versiju kontrolei
4. **CI validācija**: GitHub Actions automātiski palaiž golden testus katram PR
5. **Regression detection**: CI brīdina, ja UI ir mainījies bez golden attēlu atjaunošanas

### Golden testu labās prakses:

- **Konsistents fonts**: Izmanto Flutter embedded fonts testiem
- **Deterministic content**: Izvairieties no laika atkarīgiem datiem golden testos
- **Platform consistency**: CI izmanto Ubuntu ar Flutter 3.22.0 konsistentiem rezultātiem
- **Minimal test scope**: Testējiet konkrētus UI komponentus, nevis veselas aplikācijas

## 🧪 CI/CD Automation Scripts

Family_Copilot iekļauj contributor-friendly automatizācijas skriptus, kas nodrošina efektīvu izstrādes plūsmu un kvalitātes kontroli. Visi skripti ir divvalodīgi (Latviešu/English) un ievēro skrastins58-source standartus.

Family_Copilot includes contributor-friendly automation scripts that ensure efficient development workflow and quality control. All scripts are bilingual (Latvian/English) and follow skrastins58-source standards.

**📋 Pieejamie skripti / Available scripts:**
- PR statusa pārbaude un etiķešu piešķiršana / PR status check and labeling
- Golden attēlu validācija / Golden image validation  
- GitHub Actions artefaktu versiju atjaunināšana / GitHub Actions artifact version updates
- PR kopsavilkuma publicēšana / PR summary publishing

**📖 Detalizēta dokumentācija:** [scripts/README.md](scripts/README.md)

## Autori

Family Copilot Team - demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.
 Android 
## 🧰 Tehnoloģijas

- Flutter 3.x
- Firebase (Messaging, Firestore, Functions)
- GitHub Actions
- flutter_local_notifications

## 📦 Instalācija

```bash
git clone https://github.com/skrastins58-source/Family_Copilot.git
cd Family_Copilot
flutter pub get
flutter test --update-goldens  # Generate golden images for first run
flutter run
```

