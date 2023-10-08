import 'package:flutter/material.dart';
import 'package:localization_plus/src/localization.dart';
import 'package:localization_plus/src/localization_plus_controller.dart';

class LocalizationPlusDelegate extends LocalizationsDelegate<Localization> {
  final LocalizationPlusController controller;

  LocalizationPlusDelegate({required this.controller});

  @override
  bool isSupported(Locale locale) =>
      controller.supportedLocales.contains(locale);

  @override
  Future<Localization> load(Locale locale) async {
    Localization.load(
      locale: locale,
      translations: controller.translations!,
      fallbackTranslations: controller.fallbackTranslations,
    );

    return Localization.instance;
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}
