# 🧭 Family Copilot

**Family Copilot** ir Flutter balstīts projekts, kas demonstrē GitHub Copilot labākās prakses un uzlabo ziņu sistēmu ar personalizētu filtrēšanu, vizuāliem paziņojumiem, deep-link navigāciju un CI/CD automatizāciju. Lietotāji saņem tikai sev aktuālas ziņas, bet izstrādātāji iegūst efektīvu darba plūsmu ar Firebase Functions, golden testiem un coverage enforcement.

## 🛠️ Instalācija un Palaide

```bash
# Klonē repozitoriju
git clone https://github.com/skrastins58-source/Family_Copilot.git
cd Family_Copilot

# Instalē Flutter atkarības
flutter pub get
```

### 🔥 Firebase konfigurācija (ja nepieciešams)

- Pievieno `google-services.json` → `android/app/`
- Pievieno `GoogleService-Info.plist` → `ios/Runner/`

> Šie faili nav versiju kontrolē — iegūstami no Firebase Console.

### 🖼️ Golden testu sagatavošana

```bash
flutter test --update-goldens
```

> Ģenerē attēlus `goldens/` direktorijā, kas tiek izmantoti CI/CD vizuālajai validācijai.

### 🚀 Palaist aplikāciju

```bash
flutter run
```

---

## 🚧 Roadmap (MVP tuvākajām kārtām)

- [x] Sākuma HTML/CSS lapas un assets direktorija
- [x] Docs index + navigācija
- [ ] "Trīs Labie Vārdi" rituāla UI un saglabāšana
- [ ] Personalizēti avataru profili un attēlu upload
- [ ] Notifikāciju veidi pielāgoti katra ģimenes locekļa vēlmēm

---

## 🧪 Testēšana un Coverage

📈 **Zarojumu coverage slieksnis: 70%**  
Pēc UI testu sistēmas pievienošanas `test/main_test.dart` failā:

- App inicializācija ar Provider un MaterialApp
- Iestatījumu izvēles loģika un UI reakcijas
- Tumšā režīma pārbaude
- Kļūdu apstrāde ar dialogiem un validāciju
- Edge case un integrācijas testi

> Mērķis: paaugstināt coverage uz 80% pēc testu papildināšanas.

---

## 🖼️ Golden Testu Plūsma

Golden testi salīdzina komponentu vizuālo izskatu ar reference attēliem:

```dart
testWidgets('MyWidget golden test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('goldens/my_widget.png'),
  );
});
```

### CI integrācija:

1. Lokālā izstrāde → komponentu izmaiņas  
2. Golden attēlu ģenerēšana → `flutter test --update-goldens`  
3. Commit → versiju kontrole  
4. CI validācija → GitHub Actions  
5. Regression detection → UI izmaiņu brīdinājums

---

## 🤖 GitHub Copilot Labākās Prakses

### 1. Skaidri komentāri ar mērķiem

```dart
// Izveido widgetu, kas parāda paziņojumu ar attēlu
// Demonstrates how to create notifications with images
```

### 2. Konsekventas importu struktūras

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
```

### 3. Precīzi definēti uzdevumi

```dart
/// Formats timestamp to human-readable relative time
String _formatTimestamp(DateTime timestamp) { ... }
```

### 4. Strukturēta koda organizācija

```
lib/
├── main.dart
├── models/
├── screens/
├── widgets/
├── services/
├── providers/
└── utils/
```

### 5. Paredzama stilistika

- `_buildWidget()` → UI
- `_handleAction()` → notikumi
- `_showDialog()` → dialogi
- `_formatData()` → datu formatēšana

---

## 📦 Tehnoloģijas

- Flutter 3.x
- Firebase (Messaging, Firestore, Functions)
- GitHub Actions
- flutter_local_notifications
- SharedPreferences
- GoRouter

---

## 🌐 Lietotāja Pieredze

- Material Design 3
- Tumšais režīms
- Vairākvalodu atbalsts (LV/EN/RU)
- Accessibility (screen reader)

---

## 🧠 Arhitektūra

**Clean Architecture** principos:

- **Presentation Layer**: Screens un Widgets  
- **Business Logic Layer**: Providers un Services  
- **Data Layer**: Models un persistence

---

## 👥 Autori

Family Copilot Team — demonstrējot GitHub Copilot labākās prakses Flutter izstrādē.
```
