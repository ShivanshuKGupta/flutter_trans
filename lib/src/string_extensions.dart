import 'package:trans_flutter/src/app_localization.dart';

/// Extension on String to provide a translation getter
extension TranslateString on String {
  String get tr {
    return AppLocalization.translate(this);
  }
}
