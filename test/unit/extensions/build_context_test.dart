import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/localization_plus_delegate.dart';
import 'package:localization_plus/src/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../my_mock_app.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Build Context Extension', () {
    testWidgets('check getters', (WidgetTester tester) async {
      await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({});
        LocalizationPlusController controller =
            await LocalizationPlusController.init(
          path: 'i18n',
          supportedLocales: [
            'en_US'.toLocale(),
            'tr_TR'.toLocale(),
          ],
          fallbackLocale: 'tr_TR'.toLocale(),
        );

        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        final BuildContext context = tester.element(find.byType(MyMockApp));

        expect(
            context.supportedLocales, ['en_US'.toLocale(), 'tr_TR'.toLocale()]);
        expect(context.currentLocale, 'en_US'.toLocale());
        expect(context.fallbackLocale, 'tr_TR'.toLocale());
        expect(context.deviceLocale, 'en_US'.toLocale());
        expect(context.localizationDelegates, [
          isA<LocalizationPlusDelegate>(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ]);
      });
    });

    testWidgets('it sets locale', (WidgetTester tester) async {
      await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({});
        LocalizationPlusController controller =
            await LocalizationPlusController.init(
          path: 'i18n',
          supportedLocales: [
            'en_US'.toLocale(),
            'tr_TR'.toLocale(),
          ],
        );

        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        final BuildContext context = tester.element(find.byType(MyMockApp));
        expect(
            context.supportedLocales, ['en_US'.toLocale(), 'tr_TR'.toLocale()]);
        expect(context.currentLocale, 'en_US'.toLocale());
        expect(context.fallbackLocale, isNull);

        context.setLocale('tr_TR'.toLocale());

        expect(context.currentLocale, 'tr_TR'.toLocale());
      });
    });

    testWidgets('it resets locale', (WidgetTester tester) async {
      await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({});
        LocalizationPlusController controller =
            await LocalizationPlusController.init(
          path: 'i18n',
          supportedLocales: [
            'en_US'.toLocale(),
            'tr_TR'.toLocale(),
          ],
        );

        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        final BuildContext context = tester.element(find.byType(MyMockApp));
        expect(
            context.supportedLocales, ['en_US'.toLocale(), 'tr_TR'.toLocale()]);
        expect(context.currentLocale, 'en_US'.toLocale());
        expect(context.fallbackLocale, isNull);

        context.setLocale('tr_TR'.toLocale());

        expect(context.currentLocale, 'tr_TR'.toLocale());

        context.resetLocale();

        expect(context.currentLocale, 'en_US'.toLocale());
      });
    });

    testWidgets('it deletes saved locale', (WidgetTester tester) async {
      await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({'locale': 'tr_TR'});
        SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper(
            sharedPreferences: await SharedPreferences.getInstance());

        LocalizationPlusController controller =
            await LocalizationPlusController.init(
          path: 'i18n',
          supportedLocales: [
            'en_US'.toLocale(),
            'tr_TR'.toLocale(),
          ],
        );

        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        final BuildContext context = tester.element(find.byType(MyMockApp));

        expect(sharedPreferenceHelper.locale, 'tr_TR'.toLocale());

        context.deleteSavedLocale();

        expect(sharedPreferenceHelper.locale, isNull);
      });
    });
  });
}
