import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trans_flutter/src/app_localization_delegate.dart';

/// Service to handle translation of strings
class AppLocalization {
  /// Constructor to create a new instance of [AppLocalization]
  AppLocalization(Locale locale) {
    localeNotifier.value = locale;
  }

  /// Override this method to load the translations for locales from another source
  /// such as a database or a network call
  ///
  /// If set to null, then the translations will be loaded from the assets
  ///
  /// Output should be a map of key-value pairs where the key is the translation key
  /// and the value is the translated string
  ///
  /// Example:
  /// ```dart
  /// {
  ///     "Hello World": "Hola Mundo",
  ///     "Some sample text": "Algún texto de muestra",
  ///     "Hello World App": "Hello World App"
  /// }
  /// ```
  static Future<Map<String, String?>> Function(Locale locale)? loadMethod;

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
      _localizedStrings = await (loadMethod?.call(locale) ??
          _loadJsonFromAssets(
            'assets/translations/${locale.languageCode}.json',
          ));

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

  /// Initializes [supportedLocales] and [fallbackLocale] from the asset file
  static Future<void> initialize() async {
    try {
      await _loadSupportedLocales();
      await _loadFallbackLocale();
    } catch (e) {
      log(
        'Error Loading Supported Locales and Fallback Locale: $e',
        name: 'TranslateService',
      );
    }
  }
}
