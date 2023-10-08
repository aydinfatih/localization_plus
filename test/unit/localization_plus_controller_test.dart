import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  LocalizationPlusController controller = await LocalizationPlusController.init(
    path: 'i18n',
    supportedLocales: [
      'en_US'.toLocale(),
      'tr_TR'.toLocale(),
    ],
  );

  group('LocalizationPlusController', () {
    test(
        'it sets the first locale supported when the current locale is not supported',
        () async {
      LocalizationPlusController controller =
          await LocalizationPlusController.init(
        path: 'i18n',
        supportedLocales: [
          'tr_TR'.toLocale(),
        ],
      );

      expect(controller.currentLocale, 'tr_TR'.toLocale());
    });

    test('it sets start locale if start locale is set', () async {
      LocalizationPlusController controller =
          await LocalizationPlusController.init(
              path: 'i18n',
              supportedLocales: [
                'en_US'.toLocale(),
                'tr_TR'.toLocale(),
              ],
              startLocale: 'tr_TR'.toLocale());

      expect(controller.currentLocale, 'tr_TR'.toLocale());
    });

    test('it loads fallback if fallback is enable', () async {
      LocalizationPlusController controller =
          await LocalizationPlusController.init(
        path: 'i18n',
        supportedLocales: [
          'en_US'.toLocale(),
          'tr_TR'.toLocale(),
        ],
        useFallbackTranslations: true,
        fallbackLocale: 'tr_TR'.toLocale(),
      );

      expect(controller.fallbackTranslations,
          json.decode(await rootBundle.loadString('i18n/tr-TR.json')));
    });

    test('it loads fallback if fallback is enable but fallback locale is null',
        () async {
      LocalizationPlusController controller =
          await LocalizationPlusController.init(
        path: 'i18n',
        supportedLocales: [
          'tr_TR'.toLocale(),
          'en_US'.toLocale(),
        ],
        useFallbackTranslations: true,
      );

      expect(controller.fallbackTranslations,
          json.decode(await rootBundle.loadString('i18n/tr-TR.json')));
    });

    test('it sets locale', () async {
      await controller.setLocale('tr_TR'.toLocale());
      expect(controller.currentLocale, 'tr_TR'.toLocale());
    });

    test('it resets locale ', () async {
      await controller.setLocale('tr_TR'.toLocale());
      expect(controller.currentLocale, 'tr_TR'.toLocale());

      await controller.resetLocale();

      expect(controller.currentLocale, 'en_US'.toLocale());
    });
  });
}
