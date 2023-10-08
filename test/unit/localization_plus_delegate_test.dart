import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/src/localization.dart';
import 'package:localization_plus/src/localization_plus_controller.dart';
import 'package:localization_plus/src/localization_plus_delegate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizationPlusDelegate', () {
    late LocalizationPlusDelegate delegate;
    late LocalizationPlusController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'locale': 'en_US'});

      final supportedLocales = [const Locale('en'), const Locale('es')];
      controller = await LocalizationPlusController.init(
          path: 'i18n', supportedLocales: supportedLocales);

      delegate = LocalizationPlusDelegate(controller: controller);
    });

    test('it supports locale', () {
      final result = delegate.isSupported(const Locale('en'));
      expect(result, isTrue);
    });

    test('it does not support locale', () {
      final result = delegate.isSupported(const Locale('fr'));
      expect(result, isFalse);
    });

    test('it returns localization class', () async {
      final result = await delegate.load(const Locale('es'));
      expect(result, isA<Localization>());
    });

    test('it does not reload', () {
      final oldDelegate = LocalizationPlusDelegate(controller: controller);

      final result = delegate.shouldReload(oldDelegate);
      expect(result, isFalse);
    });
  });
}
