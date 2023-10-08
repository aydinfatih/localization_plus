import 'package:flutter/widgets.dart';
import 'package:localization_plus/localization_plus.dart';

extension ContextExtension on BuildContext {
  // region - Getters
  Locale get currentLocale => LocalizationPlus.of(this).currentLocale;

  Locale get deviceLocale => LocalizationPlus.of(this).deviceLocale;

  List<Locale> get supportedLocales =>
      LocalizationPlus.of(this).supportedLocales;

  Locale? get fallbackLocale => LocalizationPlus.of(this).fallbackLocale;

  List<LocalizationsDelegate> get localizationDelegates =>
      LocalizationPlus.of(this).delegates;

  // endregion

  // region - Methods
  Future<void> setLocale(Locale locale) async =>
      LocalizationPlus.of(this).setLocale(locale);

  Future<void> deleteSavedLocale() async =>
      LocalizationPlus.of(this).deleteSavedLocale();

  Future<void> resetLocale() => LocalizationPlus.of(this).resetLocale();
//endregion
}
