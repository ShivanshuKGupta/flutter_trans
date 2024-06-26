# trans_flutter

`trans_flutter` is a Flutter package designed to work alongside the [fluttertrans CLI tool](https://pub.dev/packages/fluttertrans) to facilitate the localization of Flutter applications. This package helps in managing and accessing translations generated by the CLI tool, making it easy to internationalize your Flutter app.

## Features

- **Easy Integration**: Seamlessly integrates with the `fluttertrans` CLI tool to handle translations.
- **Dynamic Localization**: Provides utilities to dynamically change the app's locale and update the UI accordingly.
- **Extension Methods**: Adds convenient extension methods for translating strings.

## Installation

1. Add `trans_flutter` to your `pubspec.yaml`:

```bash
flutter pub add trans_flutter
```

2. Ensure your `pubspec.yaml` includes the `assets/translations/` folder:

```yaml
flutter:
  assets:
    - assets/translations/
```

3. Create a file `assets/translations/all_locales.json` with the following content:

```json
{
    "supportedLocales": ["en", "es"],
    "fallbackLocale": "hi"
}
```

4. Run `flutter pub get` to keep the assets dependencies up-to-date.

5. Follow the instructions to install the [fluttertrans CLI tool](https://pub.dev/packages/fluttertrans) for generating translation files.

## Usage

### Step 1: Generate Translations

Just add ```.tr``` extension to your strings in your code you want to translate. For example:

```dart
Text('Hello World'.tr)
```

and run the following command to generate translations:

```bash
fluttertrans
```

This will generate translation files in the `assets/translations/` folder, with the file name as the locale code (e.g., `en.json`, `es.json`, etc.). The file might look like this:

```json
{
  "Hello World": "Hola Mundo"
}
```

For more information on how to use the cli, refer to the [fluttertrans CLI tool](https://pub.dev/packages/fluttertrans).

### Step 2: Load Translations in Your App

#### Initialize TransFlutter

In your `main.dart` file, initialize `TransFlutter` before running the app:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransFlutter.initialize();
  runApp(MyApp());
}
```

#### Using `.tr` for Strings

You can easily translate strings using the `.tr` extension method:

```dart
import 'package:flutter/material.dart';
import 'package:trans_flutter/trans_flutter.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World'.tr), // This will translate the text 'Hello World'
      ),
      body: Center(
        child: Text('Welcome Message'.tr), // This will translate the text 'Welcome Message'
      ),
    );
  }
}
```

#### Change runApp

To ensure the entire app rebuilds when the locale changes, change the runApp as shown below

```dart
import 'package:flutter/material.dart';
import 'package:trans_flutter/trans_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransFlutter.initialize();

  runApp(
    // This builder method is called whenever the locale changes
    TranslationBuilder(
      builder: (context, locale) {
        return MainApp(key: ValueKey(locale.languageCode)); // Rebuild the app when the locale changes
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: "Flutter Demo Home Page".tr),
    );
  }
}
```

### Changing Locale at Runtime

To change the locale dynamically, use the `setLocale` method:

```dart
import 'package:flutter/material.dart';
import 'package:trans_flutter/trans_flutter.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'.tr),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await TransFlutter.setLocale(const Locale('es')); // Change to Spanish
          },
          child: Text('Change to Spanish'.tr),
        ),
      ),
    );
  }
}
```

## Full Example

```dart
import 'package:trans_flutter/trans_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TransFlutter.initialize();

  print('Current Locale: ${TransFlutter.locale}');
  print('Supported Locales: ${TransFlutter.supportedLocales}');
  print("Fallback Locale: ${TransFlutter.fallbackLocale}");

  runApp(
    TranslationBuilder(
      builder: (context, locale) {
        return MainApp(key: ValueKey(locale.languageCode));
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: "TransFlutter Demo Home Page".tr),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Click the floating button to change the locale'.tr,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (TransFlutter.locale == const Locale('en')) {
            await TransFlutter.setLocale(const Locale('es'));
          } else {
            await TransFlutter.setLocale(const Locale('en'));
          }
        },
        tooltip: 'Increment'.tr,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/ShivanshuKGupta/flutter_trans).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

`trans_flutter` makes it easy to internationalize your Flutter apps with minimal effort. With seamless integration and dynamic localization capabilities, you can ensure your app is ready for a global audience. Happy coding!
