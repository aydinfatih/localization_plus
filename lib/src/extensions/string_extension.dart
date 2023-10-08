import 'package:flutter/material.dart';
import 'package:localization_plus/src/helpers.dart' as helpers;

extension StringExtension on String {
  Locale toLocale({String separator = '_'}) {
    final localeList = split(separator);
    switch (localeList.length) {
      case 3:
        return Locale.fromSubtags(
          languageCode: localeList.first,
          scriptCode: localeList[1],
          countryCode: localeList.last,
        );
      case 2:
        return localeList.last.length == 4
            ? Locale.fromSubtags(
                languageCode: localeList.first,
                scriptCode: localeList.last,
              )
            : Locale(localeList.first, localeList.last);
      default:
        return Locale(localeList.first);
    }
  }

  String trans({Map<String, String>? arguments}) {
    return helpers.trans(this, arguments: arguments);
  }

  String transChoice(num number, {Map<String, String>? arguments}) {
    return helpers.transChoice(this, number, arguments: arguments);
  }

  String plural(num number, {Map<String, String>? arguments}) {
    return helpers.plural(this, number, arguments: arguments);
  }

  bool transExists() {
    return helpers.transExists(this);
  }
}
