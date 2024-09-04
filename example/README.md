# Full Example

```dart
import 'package:flutter/material.dart';
import 'package:trans_flutter/trans_flutter.dart';

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

const String name = "Raman Tank";

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// To enable localization for this page, call [AppLocalization.enable]
    /// This method is required to let Flutter know that this page is localized
    AppLocalization.enable(context);
    final newString = "${'Hello World'.tr} ${'Deep Patel'.tr}";

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Some sample text'.tr),
            Text(newString),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final locale in AppLocalization.supportedLocales)
                  ElevatedButton(
                    onPressed: () {
                      AppLocalization.changeLocale(locale); // Change the locale dynamically
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
