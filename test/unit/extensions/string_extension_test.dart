import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/localization.dart';

import '../../test_case.dart';

void main() {
  group('String Extension', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Localization.load(
          locale: 'tr-TR'.toLocale(),
          translations: translations,
          fallbackTranslations: fallbackTranslations);
    });

    test('it converts string to locale', () {
      expect(
          'tr_TUR_TR'.toLocale(),
          equals(const Locale.fromSubtags(
              languageCode: 'tr', scriptCode: 'TUR', countryCode: 'TR')));
      expect(
          'th_Thai'.toLocale(),
          equals(const Locale.fromSubtags(
              languageCode: 'th', scriptCode: 'Thai')));
      expect('tr_TR'.toLocale(), equals(const Locale('tr', 'TR')));
      expect('tr_TR'.toLocale(), equals(const Locale('tr', 'TR')));
      expect(
          'tr|TR'.toLocale(separator: '|'), equals(const Locale('tr', 'TR')));
      expect('tr'.toLocale(), equals(const Locale('tr')));
    });

    test('it translates string', () {
      expect('one.two.three'.trans(), equals('four'));
      expect('test_with_arguments'.trans(arguments: {'arg': 'example'}),
          equals('Test => example'));
    });

    test('it translates string according to the condition', () {
      expect('day'.transChoice(-1), equals('Yesterday'));
      expect('day'.transChoice(0), equals('Today'));
      expect('day'.transChoice(1), equals('Tomorrow'));
      expect('day'.transChoice(2), equals('2 days later'));
      expect('day'.transChoice(4), equals('A few days later'));
      expect('day'.transChoice(9), equals('After a week'));
      expect('day'.transChoice(21), equals('Earlier in the week'));
      expect('day'.transChoice(1200), equals('Any day'));
    });

    test('it translates string according to the pluralization rules', () {
      expect('plural'.plural(0, arguments: {'day': '0'}), equals('0 zero'));
      expect('plural'.plural(1, arguments: {'day': '1'}), equals('1 one'));
      expect('plural'.plural(2, arguments: {'day': '2'}), equals('2 two'));
      expect('plural'.plural(3, arguments: {'day': '3'}), equals('3 other'));
      expect('plural'.plural(4, arguments: {'day': '4'}), equals('4 other'));
      expect('plural'.plural(5, arguments: {'day': '5'}), equals('5 other'));
    });

    test('it checks for translation', () {
      expect('one.two.three'.transExists(), isTrue);
      expect('not_exists'.transExists(), isFalse);
    });
  });
}
