import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferenceHelper', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('it returns locale', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ru_RU'});

      SharedPreferences pref = await SharedPreferences.getInstance();
      SharedPreferenceHelper sharedPreferenceHelper =
          SharedPreferenceHelper(sharedPreferences: pref);

      expect(sharedPreferenceHelper.locale, equals('ru_RU'.toLocale()));
    });

    test('it saves locale', () async {
      SharedPreferences.setMockInitialValues({});

      SharedPreferences pref = await SharedPreferences.getInstance();
      SharedPreferenceHelper sharedPreferenceHelper =
          SharedPreferenceHelper(sharedPreferences: pref);

      Locale savedLocale = 'tr_TR'.toLocale();
      sharedPreferenceHelper.saveLocale(locale: savedLocale);

      expect(sharedPreferenceHelper.locale, equals(savedLocale));
    });

    test('it deletes locale', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ru_RU'});
      SharedPreferences pref = await SharedPreferences.getInstance();
      SharedPreferenceHelper sharedPreferenceHelper =
          SharedPreferenceHelper(sharedPreferences: pref);

      sharedPreferenceHelper.deleteLocale();

      expect(sharedPreferenceHelper.locale, isNull);
    });
  });
}
