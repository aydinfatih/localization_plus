import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/src/localization.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../my_mock_app.dart';

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

  group('LocalizationPlus Widget', () {
    testWidgets('it loads according to device locale',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        final BuildContext context = tester.element(find.byType(MyMockApp));

        expect(Localization.instance, isInstanceOf<Localization>());
        expect(
            Localization.of(mockWidgetContext), isInstanceOf<Localization>());
        expect(Localization.of(mockWidgetContext), Localization.instance);
        expect(LocalizationPlus.of(context).supportedLocales,
            ['en_US'.toLocale(), 'tr_TR'.toLocale()]);
        expect(LocalizationPlus.of(context).currentLocale, 'en_US'.toLocale());
        expect(LocalizationPlus.of(context).fallbackLocale, isNull);

        // Check widget
        expect(find.text('Hello'), findsOneWidget);

        // Change language
        await controller.setLocale('tr_TR'.toLocale());
        await tester.pump();

        expect(LocalizationPlus.of(context).currentLocale, 'tr_TR'.toLocale());
        expect(context.currentLocale, 'tr_TR'.toLocale());
        expect(controller.currentLocale, 'tr_TR'.toLocale());
      });
    });

    testWidgets('it shows error widget when translation fails to load',
        (WidgetTester tester) async {
      LocalizationPlusController controller =
          await LocalizationPlusController.init(
        path: 'i18',
        supportedLocales: ['en_US'.toLocale()],
      );

      await tester.runAsync(() async {
        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        // Check widget
        expect(find.byWidgetPredicate((widget) => widget is ErrorWidget),
            findsOneWidget);
      });
    });

    testWidgets('it disposes the controller when the widget is removed',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        LocalizationPlusController controller =
            await LocalizationPlusController.init(
          path: 'i18n',
          supportedLocales: ['en_US'.toLocale()],
        );

        // Create widget
        await tester.pumpWidget(
          LocalizationPlus(
            controller: controller,
            child: const MyMockApp(),
          ),
        );
        await tester.pump();

        expect(controller.hasActiveListener, true);

        await tester.pumpWidget(const SizedBox.shrink());

        expect(controller.hasActiveListener, false);
      });
    });

    testWidgets('it loads with saved locale', (WidgetTester tester) async {
      await tester.runAsync(() async {
        SharedPreferences.setMockInitialValues({'locale': 'tr_TR'});
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

        expect(Localization.instance, isInstanceOf<Localization>());
        expect(LocalizationPlus.of(context).supportedLocales,
            ['en_US'.toLocale(), 'tr_TR'.toLocale()]);
        expect(LocalizationPlus.of(context).currentLocale, 'tr_TR'.toLocale());
        expect(LocalizationPlus.of(context).fallbackLocale, isNull);

        // Check widget
        expect(find.text('Merhaba'), findsOneWidget);

        SharedPreferences.setMockInitialValues({});
      });
    });

    testWidgets('it throws error widget when translation fails to load',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
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

        expect(find.text('Hello'), findsOneWidget);

        await controller.setLocale('tr_TR'.toLocale());
        await tester.pump();

        expect(LocalizationPlus.of(context).currentLocale, 'tr_TR'.toLocale());

        expect(() async => await controller.setLocale('ar_DZ'.toLocale()),
            throwsAssertionError);
      });
    });
  });
}
