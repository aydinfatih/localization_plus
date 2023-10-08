import 'package:flutter/material.dart';
import 'package:localization_plus/src/extensions/map_extension.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class Localization {
  static final Localization _instance = Localization._();

  Localization._();

  static Localization get instance => _instance;

  late Map<String, dynamic> _translations;
  Map<String, dynamic>? _fallbackTranslations;
  late Locale _locale;

  static Localization? of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization);

  static void load(
      {required Locale locale,
      required Map<String, dynamic> translations,
      Map<String, dynamic>? fallbackTranslations}) {
    instance._translations = translations;
    instance._fallbackTranslations = fallbackTranslations;
    instance._locale = locale;
  }

  String trans(String key, {Map<String, String>? arguments}) {
    String text = _resolve(key: key);
    text = _replaceArguments(text: text, arguments: arguments);

    return _replaceLinks(text: text);
  }

  String plural(String key, num number, {Map<String, String>? arguments}) {
    String text = _resolvePlural(key: key, number: number);

    text = _replaceArguments(text: text, arguments: arguments);

    return _replaceLinks(text: text);
  }

  String transChoice(String key, num number, {Map<String, String>? arguments}) {
    String text = _resolveChoice(key: key, number: number);

    text = _replaceArguments(text: text, arguments: arguments);

    return _replaceLinks(text: text);
  }

  String _replaceArguments(
      {required String text, required Map<String, String>? arguments}) {
    if (arguments == null || arguments.isEmpty) return text;

    arguments.forEach((String key, String value) {
      text =
          text.replaceAll(RegExp('{${_capitalize(key)}}'), _capitalize(value));
      text = text.replaceAll(
          RegExp('{${key.toUpperCase()}}'), value.toUpperCase());
      text = text.replaceAll(RegExp('{$key}'), value);
    });

    return text;
  }

  String _replaceLinks({required String text}) {
    final matches = RegExp(r'(?:@(?:\.[a-z]+)?:(?:[\w\-_|.]+|\([\w\-_|.]+\)))')
        .allMatches(text);
    String resource = text;
    for (final match in matches) {
      String linkedKey = match[0]!;
      var linkedKeyMatches =
          RegExp(r'^@(?:\.([a-z]+))?:').allMatches(linkedKey);
      final prefix = linkedKeyMatches.first[0]!;
      final notation = linkedKeyMatches.first[1];

      final linkPlaceholder =
          linkedKey.replaceAll(prefix, '').replaceAll(RegExp('[()]'), '');

      String translated = _resolve(key: linkPlaceholder);

      switch (notation) {
        case 'lower':
          translated = translated.toLowerCase();
          break;
        case 'capitalize':
          translated = _capitalize(translated);
          break;
        case 'upper':
          translated = translated.toUpperCase();
          break;
      }

      resource = translated.isEmpty
          ? resource
          : resource.replaceAll(linkedKey, translated);
    }

    return resource;
  }

  dynamic _resolve({required String key}) {
    return _translations.select(key) ??
        _fallbackTranslations?.select(key) ??
        key;
  }

  String _resolvePlural({required String key, required num number}) {
    var resource = _resolve(key: key);
    if (resource is Map) {
      return Intl.pluralLogic(
        number,
        zero: resource['zero'],
        one: resource['one'],
        two: resource['two'],
        few: resource['few'],
        many: resource['many'],
        other: resource['other'],
        locale: _locale.languageCode,
      );
    }

    return resource;
  }

  String _resolveChoice({required String key, required num number}) {
    var resource = _resolve(key: key);

    // if resource is map
    if (resource is Map) {
      // get conditional keys
      List<String> keys = List.from((resource).keys);

      // find matched key
      var subKey = keys.firstWhereOrNull((String conditionalKey) {
        // split conditions
        List<String> conditions = conditionalKey.split('|');

        String? matchedKey = conditions.firstWhereOrNull((String condition) {
          // Split number between
          List numbers = condition.split(':');
          num? minNumber = num.tryParse(numbers.first);
          num? maxNumber = num.tryParse(numbers.last);

          if (numbers.length == 2 && minNumber != null && maxNumber != null) {
            return number >= minNumber && number <= maxNumber;
          }

          return minNumber != null && minNumber == number;
        });

        return matchedKey != null;
      });

      if (subKey != null) {
        return _resolve(key: '$key.$subKey');
      }

      if (exists('$key.*')) {
        return _resolve(key: '$key.*');
      }

      return key;
    }

    return resource;
  }

  bool exists(String key) {
    return _translations.select(key) != null;
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
