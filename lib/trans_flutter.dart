import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extension on String to provide a translation getter
extension TranslateString on String {
  String get tr {
    return TransFlutter.translate(this);
  }
}

/// Service to handle translation of strings
class TransFlutter {
  /// The localized strings map
  static Map<String, dynamic> _localizedStrings = {};

  /// Getter for the current locale
  static Locale get locale => localeNotifier.value;

  /// ValueNotifier to notify listeners about locale changes
  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  /// List of supported locales
  static final List<Locale> supportedLocales = [];

  /// The fallback locale to use when the current locale is not supported
  static Locale fallbackLocale = const Locale('en');

  /// Initializes the service by loading the supported locales
  /// and fallback locale
  Future<void> initialize() async {
    try {
      final localeData =
          await loadJsonFromAssets('assets/translations/all_locales.json');
      if (localeData['fallbackLocale'] != null) {
        fallbackLocale = Locale(localeData['fallbackLocale'].toString());
      }
      supportedLocales.clear();
      supportedLocales.addAll(
        (localeData['supportedLocales'] as List<dynamic>).map(
          (e) => Locale(e.toString()),
        ),
      );
    } catch (e) {
      log('Error Loading Supported Locales: $e', name: 'TranslateService');
    }
  }

  /// Sets the locale and loads the corresponding translations
  ///
  /// This will also rebuild the widgets that are listening to the _localeNotifier
  static Future<void> setLocale(Locale locale) async {
    localeNotifier.value = locale;
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

  /// Loads the JSON file from the assets and decodes it
  static Future<Map<String, dynamic>> loadJsonFromAssets(
      String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return jsonDecode(jsonString);
  }
}

/// Widget to rebuild UI based on locale changes
class TranslationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Locale locale) builder;
  const TranslationBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TransFlutter.localeNotifier,
      builder: (context, locale, child) {
        return builder(context, locale);
      },
    );
  }
}
