# 🤝 Piedalīšanās Family Copilot projektā

Paldies par interesi par Family Copilot projektu! Mēs novērtējam sabiedrības ieguldījumu un esam sagatavoti palīdzēt jauniem izstrādātājiem.

## 🚀 Kā sākt

### Prasības
- Flutter 3.22.0 vai jaunāks
- Dart 3.0+
- Git pamatzināšanas
- GitHub konts

### Lokālā izstrādes vide

1. **Fork repozitoriju**
   ```bash
   # Izveidojiet fork GitHub interfeisā, pēc tam klonējiet
   git clone https://github.com/YOUR-USERNAME/Family_Copilot.git
   cd Family_Copilot
   ```

2. **Instalējiet atkarības**
   ```bash
   flutter pub get
   ```

3. **Ģenerējiet golden attēlus (ja nepieciešams)**
   ```bash
   ./generate_goldens.sh
   # vai
   flutter test test/widget_test.dart --update-goldens
   ```

4. **Palaidiet testus**
   ```bash
   flutter test --coverage
   ```

## 📋 Kā piedalīties

### 🐛 Bug ziņojumi
1. Pārbaudiet [esošos issues](https://github.com/skrastins58-source/Family_Copilot/issues)
2. Izmantojiet bug template
3. Iekļaujiet reprodukcijas soļus un ekspektācijas

### ✨ Jaunu funkciju ieteikumi
1. Aprakstiet problēmu, ko risinājat
2. Ierosināms risinājums
3. Ietekme uz lietotājiem

### 🔧 Pull Request process

1. **Izveidojiet jaunu branch**
   ```bash
   git checkout -b feature/jauna-funkcionalitate
   # vai
   git checkout -b fix/bug-nosaukums
   ```

2. **Attīstiet un testējiet**
   ```bash
   # Pievienojiet testus jaunai funkcionalitātei
   flutter test
   
   # Pārbaudiet formatējumu
   dart format .
   
   # Palaidiet analīzi
   flutter analyze
   ```

3. **Pārbaudiet golden testus**
   ```bash
   flutter test test/widget_test.dart
   # Ja UI mainījies, atjauniniet:
   flutter test test/widget_test.dart --update-goldens
   ```

4. **Commit un push**
   ```bash
   git add .
   git commit -m "feat: apraksts par izmaiņām"
   git push origin feature/jauna-funkcionalitate
   ```

5. **Izveidojiet Pull Request**
   - Izmantojiet PR template
   - Pievienojiet screenshots UI izmaiņām
   - Saistiet ar related issues

## 📏 Koda kvalitātes standarti

### Code Coverage
- Minimālais līmenis: **80%**
- Testējiet visas jaunās funkcijas
- Iekļaujiet edge cases

### Golden testi
- Jāatjaunina pie UI izmaiņām
- Konsistents fonts un saturs
- Minimāls test scope

### Stilistika
```dart
// Publiskām metodēm - dokumentācija
/// Parāda ziņojumu dialoga logā ar [message] saturu
void showNotification(String message) {
  // implementācija
}

// Privātām metodēm - komentāri
// Validē lietotāja ievadi pirms saglabāšanas
void _validateInput() {
  // implementācija
}
```

### Naming konvencijas
- `_buildWidget()` - UI komponenti
- `_handleAction()` - notikumu apstrāde
- `_formatData()` - datu formatēšana
- `_showDialog()` - dialoga parādīšana

## 🧪 Testing vadlīnijas

### Unit testi
```dart
testWidgets('Component renders correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.text('Expected Text'), findsOneWidget);
});
```

### Golden testi
```dart
testWidgets('MyWidget golden test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  await expectLater(
    find.byType(MyWidget),
    matchesGoldenFile('goldens/my_widget.png'),
  );
});
```

## 🔄 CI/CD process

Katrs PR automātiski izpilda:

1. **Build process** - Android APK un Web bundle
2. **Testing** - Unit, widget un golden testi
3. **Coverage check** - Validē 80% slieksni
4. **Code analysis** - Flutter analyze un formatting
5. **Golden test validation** - UI consistency check

## 💬 Saziņa

- **Issues** - Bug ziņojumi un funkciju pieprasījumi
- **Discussions** - Arhitektūras apspriešana
- **PR Reviews** - Koda pārskati un feedback

## 🏷️ Labels un prioritātes

- `good first issue` - Piemēroti jauniem izstrādātājiem
- `help wanted` - Nepieciešama sabiedrības palīdzība
- `bug` - Bug fiksējumi
- `enhancement` - Jaunas funkcijas
- `documentation` - Dokumentācijas uzlabojumi

## 🌟 Recognition

Contributors tiek atzīmēti:
- README.md Contributors sadaļā
- Release notes
- GitHub contributors grafikā

## 📄 Licence

Piedalīšanās projektā nozīmē, ka jūsu devums tiks licencēts zem projekta MIT licences.

---

**Jautājumi?** Izveidojiet [GitHub Issue](https://github.com/skrastins58-source/Family_Copilot/issues/new) vai sazinājieties ar mūsu komandu!