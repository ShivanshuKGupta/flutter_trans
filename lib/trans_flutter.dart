import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Extension on String to provide a translation getter
extension TranslateString on String {
  String get tr {
    return AppLocalization.translate(this);
  }
}

/// Service to handle translation of strings
class AppLocalization {
  /// Constructor to create a new instance of [AppLocalization]
  AppLocalization(Locale locale) {
    localeNotifier.value = locale;
  }

  /// The localized strings map
  static Map<String, dynamic> _localizedStrings = {};

  /// Getter for the current locale
  static Locale get locale => localeNotifier.value;

  /// ValueNotifier to notify listeners about locale changes
  static final ValueNotifier<Locale> localeNotifier =
      ValueNotifier(const Locale('en'));

  /// List of supported locales]
  ///
  /// Make sure to call [initialize] before using this list
  /// You can call the initialize method in the main function
  /// before running the app
  static final List<Locale> supportedLocales = [
    const Locale('en'),
  ];

  static const localizationsDelegates = [
    AppLocalizationsDelegate(),
    ...GlobalMaterialLocalizations.delegates,
  ];

  /// The fallback locale to use when the current locale is not supported
  ///
  /// Make sure to call [initialize] before using this list
  /// You can call the initialize method in the main function
  /// before running the app
  static Locale fallbackLocale = const Locale('en');

  /// Enables translations for the given context
  ///
  /// This method should be called once in the build method
  /// of every widget in which the translations are used
  static void enable(BuildContext context) {
    Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  /// Sets the locale
  ///
  /// This will also rebuild the widgets that are listening to the [localeNotifier]
  static void changeLocale(Locale locale) async {
    localeNotifier.value = locale;
  }

  /// Loads the translations from the assets for the current locale
  Future<bool> load() async {
    debugPrint('Loading translations for ${locale.languageCode}');
    try {
      _localizedStrings = await _loadJsonFromAssets(
          'assets/translations/${locale.languageCode}.json');

      await _loadSupportedLocales();
      await _loadFallbackLocale();

      return true;
    } catch (e) {
      log(
        'Error Loading Translations for locale `${locale.languageCode}`: $e',
        name: 'TranslateService',
      );
    }
    return false;
  }

  /// Translates the given string to the current locale
  ///
  /// You can also use the [.tr] extension on [String] to get the translation
  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Loads the JSON file from the assets and decodes it
  static Future<Map<String, dynamic>> _loadJsonFromAssets(
      String filePath) async {
    String jsonString = await rootBundle.loadString(filePath);
    return json.decode(jsonString);
  }

  static Future<void> _loadSupportedLocales() async {
    final localesData =
        await _loadJsonFromAssets('assets/translations/all_locales.json');

    supportedLocales.clear();
    supportedLocales.addAll(
      (localesData['supportedLocales'] as List<dynamic>).map(
        (langCode) => Locale(langCode.toString()),
      ),
    );
    if (!supportedLocales.contains(const Locale('en'))) {
      supportedLocales.add(const Locale('en'));
    }
  }

  static Future<void> _loadFallbackLocale() async {
    final localesData =
        await _loadJsonFromAssets('assets/translations/all_locales.json');

    if (localesData['fallbackLocale'] != null) {
      fallbackLocale = Locale(localesData['fallbackLocale'].toString());
    }
  }

  /// Loads [supportedLocales] and [fallbackLocale] from the asset file
  static Future<void> initialize() async {
    await _loadSupportedLocales();
    await _loadFallbackLocale();
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalization.supportedLocales
        .map((e) => e.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}

/// Widget to rebuild UI based on locale changes
class TranslationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Locale locale) builder;

  /// Builder which rebuilds the UI based on locale changes
  const TranslationBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppLocalization.localeNotifier,
      builder: (context, locale, child) {
        return builder(context, locale);
      },
    );
  }
}
