import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RootBundleAssetLoader', () {
    const assetLoader = RootBundleAssetLoader();

    test('it loads only by language code', () async {
      final result = await assetLoader.load(
        path: 'i18n',
        locale: 'en_US'.toLocale(),
        useOnlyLanguageCode: true,
      );

      expect(result, json.decode(await rootBundle.loadString('i18n/en.json')));
    });

    test('it loads only by locale', () async {
      final result = await assetLoader.load(
        path: 'i18n',
        locale: 'en_US'.toLocale(),
        useOnlyLanguageCode: false,
      );

      expect(
          result, json.decode(await rootBundle.loadString('i18n/en-US.json')));
    });

    test('it throws error if the file does not exist', () async {
      expect(
        () async => await assetLoader.load(
          path: 'i18n',
          locale: 'en_GB'.toLocale(),
          useOnlyLanguageCode: false,
        ),
        throwsFlutterError,
      );
    });
  });
}
