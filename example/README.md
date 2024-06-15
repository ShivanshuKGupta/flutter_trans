# Full Example

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
