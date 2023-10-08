import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/localization.dart';

import '../test_case.dart';

void main() {
  group('Localization', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUpAll(() {
      Localization.load(
          locale: 'ar_DZ'.toLocale(),
          translations: translations,
          fallbackTranslations: fallbackTranslations);
    });

    test('it translates string', () {
      expect(Localization.instance.trans('test'), equals('example'));
      expect(
          Localization.instance
              .trans('test_with_arguments', arguments: {'arg': 'Example'}),
          equals('Test => Example'));
    });

    test('it translates fallback', () {
      expect(Localization.instance.trans('fallback'), equals('Fallback'));
    });

    test('it checks for translation', () {
      expect(Localization.instance.exists('test'), isTrue);
      expect(Localization.instance.exists('notExists'), isFalse);
    });

    test('it translates string with arguments', () {
      expect(
          Localization.instance
              .trans('uppercase_test', arguments: {'arg': 'title'}),
          equals('TITLE'));
      expect(
          Localization.instance
              .trans('capitalize_test', arguments: {'arg': 'title'}),
          equals('Title'));
    });

    test('it resolves linked translations', () {
      expect(
          Localization.instance
              .trans('hello_world', arguments: {'arg': 'test'}),
          equals('hello World FOUR test'));
    });

    test('it translates string according to the condition', () {
      expect(Localization.instance.transChoice('day', -1), equals('Yesterday'));
      expect(Localization.instance.transChoice('day', 0), equals('Today'));
      expect(Localization.instance.transChoice('day', 1), equals('Tomorrow'));
      expect(
          Localization.instance.transChoice('day', 2), equals('2 days later'));
      expect(Localization.instance.transChoice('day', 4),
          equals('A few days later'));
      expect(
          Localization.instance.transChoice('day', 9), equals('After a week'));
      expect(Localization.instance.transChoice('day', 21),
          equals('Earlier in the week'));
      expect(Localization.instance.transChoice('day', 1200), equals('Any day'));
    });

    test('it translates string according to the pluralization rules', () {
      expect(Localization.instance.plural('plural', 0, arguments: {'day': '0'}),
          equals('0 zero'));
      expect(Localization.instance.plural('plural', 1, arguments: {'day': '1'}),
          equals('1 one'));
      expect(Localization.instance.plural('plural', 2, arguments: {'day': '2'}),
          equals('2 two'));
      expect(Localization.instance.plural('plural', 3, arguments: {'day': '3'}),
          equals('3 few'));
      expect(
          Localization.instance.plural('plural', 60, arguments: {'day': '60'}),
          equals('60 many'));
    });

    test('it translates string according to the pluralization rules for other',
        () {
      expect(Localization.instance.plural('plural_other', 0), equals('other'));
      expect(Localization.instance.plural('plural_other', 1), equals('other'));
      expect(Localization.instance.plural('plural_other', 2), equals('other'));
      expect(Localization.instance.plural('plural_other', 3), equals('other'));
      expect(Localization.instance.plural('plural_other', 4), equals('other'));
      expect(Localization.instance.plural('plural_other', 5), equals('other'));
    });
  });
}
