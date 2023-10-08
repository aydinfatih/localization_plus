import 'package:flutter/material.dart';
import 'package:localization_plus/localization_plus.dart';

late BuildContext mockWidgetContext;

class MyMockApp extends StatelessWidget {
  const MyMockApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.currentLocale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const MyMockWidget(),
    );
  }
}

class MyMockWidget extends StatelessWidget {
  const MyMockWidget({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    mockWidgetContext = context;
    return Column(
      children: [
        const Text('hello').trans(),
      ],
    );
  }
}
