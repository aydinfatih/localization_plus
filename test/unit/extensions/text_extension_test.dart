import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/localization.dart';

import '../../test_case.dart';

void main() {
  group('TextExtension', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      Localization.load(
          locale: 'tr-TR'.toLocale(),
          translations: translations,
          fallbackTranslations: fallbackTranslations);
    });

    testWidgets('trans', (WidgetTester tester) async {
      final textWidget = const Text('test').trans();

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: textWidget)));
      expect(find.text('example'), findsOneWidget);
    });

    testWidgets('transChoice', (WidgetTester tester) async {
      final textWidget = const Text('day').transChoice(1);

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: textWidget)));
      expect(find.text('Tomorrow'), findsOneWidget);
    });

    testWidgets('plural', (WidgetTester tester) async {
      final textWidget =
          const Text('plural').plural(0, arguments: {'day': '0'});

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: textWidget)));
      expect(find.text('0 zero'), findsOneWidget);
    });
  });
}
