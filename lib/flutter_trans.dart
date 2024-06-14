import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension on String to provide a translation getter
extension TranslateString on String {
  String get tr {
    return TranslateService.translate(this);
  }
}

/// Service to handle translation of strings
class TranslateService {
  /// The localized strings map
  static Map<String, dynamic> _localizedStrings = {};

  /// Getter for the current locale
  static Locale get locale => _localeNotifier.value;

  /// ValueNotifier to notify listeners about locale changes
  static final ValueNotifier<Locale> _localeNotifier =
      ValueNotifier(const Locale('en'));

  /// Sets the locale and loads the corresponding translations
  ///
  /// This will also rebuild the widgets that are listening to the _localeNotifier
  static Future<void> setLocale(Locale locale) async {
    _localeNotifier.value = locale;
    await load();
  }

  /// Loads the translations from the assets for the current locale
  static Future<void> load() async {
    try {
      _localizedStrings = await loadJsonFromAssets(
          'assets/translations/${locale.languageCode}.json');
    } catch (e) {
      log(
        'Error Loading Translations for locale `${locale.languageCode}`: $e',
        name: 'TranslateService',
      );
    }
  }

  /// Translates the given key to the current locale
  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

/// Loads the JSON file from the assets and decodes it
Future<Map<String, dynamic>> loadJsonFromAssets(String filePath) async {
  String jsonString = await rootBundle.loadString(filePath);
  return jsonDecode(jsonString);
}

/// Extension on Widget to provide a translate method
extension TranslateWidget on Widget {
  Widget translate() {
    return TranslationBuilder(
      builder: (context, locale) {
        return this;
      },
    );
  }
}

/// Widget to rebuild UI based on locale changes
class TranslationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Locale locale) builder;
  const TranslationBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TranslateService._localeNotifier,
      builder: (context, locale, child) {
        return builder(context, locale);
      },
    );
  }
}
