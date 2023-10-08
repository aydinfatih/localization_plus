import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/extensions/locale_extension.dart';

void main() {
  group('Locale Extension', () {
    test('it returns true if equals', () async {
      Locale locale = 'th_Thai_TH'.toLocale();
      expect(locale.equals(locale), isTrue);
      expect(locale.equals('th_Thai_TH'.toLocale()), isTrue);

      locale = 'th_TH'.toLocale();
      expect(locale.equals('th_TH'.toLocale()), isTrue);
      expect(locale.equals('th_Thai_TH'.toLocale()), isTrue);

      locale = 'th'.toLocale();
      expect(locale.equals('th'.toLocale()), isTrue);
      expect(locale.equals('th_TH'.toLocale()), isTrue);
      expect(locale.equals('th_Thai_TH'.toLocale()), isTrue);
    });

    test('it returns false if not equals', () async {
      Locale locale = 'th_Thai_TH'.toLocale();
      expect(locale.equals('th'.toLocale()), isFalse);
      expect(locale.equals('th_Thai'.toLocale()), isFalse);
      expect(locale.equals('en_US'.toLocale()), isFalse);

      locale = 'th_TH'.toLocale();
      expect(locale.equals('th'.toLocale()), isFalse);
      expect(locale.equals('th_Thai'.toLocale()), isFalse);

      locale = 'th'.toLocale();
      expect(locale.equals('en'.toLocale()), isFalse);
    });
  });
}
