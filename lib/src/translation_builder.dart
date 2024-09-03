import 'package:flutter/material.dart';
import 'package:trans_flutter/src/app_localization.dart';

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
