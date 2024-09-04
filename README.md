## TransFlutter

A Flutter package for easy localization and translation management. This package is to be used in conjunction with the [`fluttertrans`](https://pub.dev/packages/fluttertrans) cli tool.

### Setup

To get started with the `trans_flutter` package, follow these steps:

1. **Add the package to your project:**
   ```bash
   flutter pub add trans_flutter
   ```

2. **Configure your assets in `pubspec.yaml`:**
   Add the following lines to your `pubspec.yaml` file to include the translation assets:
   ```yaml
   flutter:
     assets:
       - assets/translations/
   ```

3. **Install the global Flutter translation tool:**
   ```bash
   dart pub global activate fluttertrans
   ```

4. **Generate the localization file:**
   Run the following command in your terminal:
   ```bash
   fluttertrans
   ```
   This command will generate a file at `assets/translations/all_locales.json`. Open this file and add the following JSON content:
   ```json
   {
       "supportedLocales": ["en", "es"],
       "fallbackLocale": "hi"
   }
   ```
   - `supportedLocales` defines the languages your app will support. You can add more languages to this list.
   - `fallbackLocale` defines the language to use when the user's preferred language is not supported.

### Example Usage

After completing the setup, you can use the `trans_flutter` package in your Flutter app as follows:

```dart
import 'package:trans_flutter/trans_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  /// Make sure to call this method before calling any other method
  /// of the package
  WidgetsFlutterBinding.ensureInitialized();

  /// This needs to be called to load all supported locales
  /// from the `all_locales.json` file
  await AppLocalization.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationBuilder(
      builder: (context, locale) {
        return MaterialApp(
          /// The below 3 lines setup localization for the app
          locale: locale,
          supportedLocales: AppLocalization.supportedLocales,
          localizationsDelegates: AppLocalization.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          title: 'Hello World App',
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// To enable localization for this page, call [AppLocalization.enable]
    /// This method is required to let Flutter know that this page is localized
    AppLocalization.enable(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Some sample text'.tr),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final locale in AppLocalization.supportedLocales)
                  ElevatedButton(
                    onPressed: () {
                      AppLocalization.changeLocale(locale); // Change the locale
                    },
                    child: Text(locale.languageCode),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Key Features

- **Initialization:** The `AppLocalization.initialize()` method loads all supported locales from the `all_locales.json` file.
- **Dynamic Locale Switching:** You can dynamically switch between locales using `AppLocalization.changeLocale(locale)`.
- **Translation:** Use the `.tr` extension method to automatically translate strings based on the current locale.
- **Localization Support:** The `TranslationBuilder` widget and `AppLocalization.enable(context)` method ensure that localization is integrated throughout your app.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue on the GitHub repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
