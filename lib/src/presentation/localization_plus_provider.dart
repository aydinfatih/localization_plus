import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization_plus/localization_plus.dart';
import 'package:localization_plus/src/localization_plus_delegate.dart';

class LocalizationPlusProvider extends InheritedWidget {
  final LocalizationPlus parent;
  final LocalizationPlusController controller;
  final Locale locale;

  LocalizationPlusProvider({
    super.key,
    required this.parent,
    required this.controller,
    required this.locale,
  }) : super(child: parent.child);

  // region - Getters
  Locale get currentLocale => controller.currentLocale;

  Locale get deviceLocale => controller.deviceLocale;

  Locale? get fallbackLocale => controller.fallbackLocale;

  List<Locale> get supportedLocales => controller.supportedLocales;

  // endregion

  // region - Methods
  Future<void> setLocale(Locale locale) async =>
      await controller.setLocale(locale);

  Future<void> resetLocale() async => await controller.resetLocale();

  Future<void> deleteSavedLocale() async =>
      await controller.deleteSavedLocale();

  // endregion

  static LocalizationPlusProvider of(BuildContext context) {
    final LocalizationPlusProvider? result =
        context.dependOnInheritedWidgetOfExactType<LocalizationPlusProvider>();
    assert(result != null, 'No LocalizationPlusProvider found in context');
    return result!;
  }

  List<LocalizationsDelegate> get delegates => [
        LocalizationPlusDelegate(controller: controller),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  @override
  bool updateShouldNotify(LocalizationPlusProvider oldWidget) {
    return oldWidget.locale != controller.currentLocale;
  }
}
