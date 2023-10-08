import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl_standalone.dart';
import 'package:localization_plus/src/contracts/asset_loader.dart';
import 'package:localization_plus/src/extensions/locale_extension.dart';
import 'package:localization_plus/src/extensions/string_extension.dart';
import 'package:localization_plus/src/loaders/root_bundle_asset_loader.dart';
import 'package:localization_plus/src/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationPlusController extends ChangeNotifier {
  // region - Constructor Properties
  final List<Locale> supportedLocales;
  Locale currentLocale;
  final Locale deviceLocale;
  late final Locale? fallbackLocale;
  dynamic translationsLoadError;

  // endregion

  // region - Private Properties
  late final String _path;
  late final AssetLoader _loader;
  late final SharedPreferenceHelper _sharedPreferenceHelper;
  late final bool _saveLocale;
  late final bool _useOnlyLangCode;
  late final bool _useFallbackTranslations;
  late final Locale? _startLocale;
  Map<String, dynamic>? _translations;
  Map<String, dynamic>? _fallbackTranslations;

  // endregion

  // region - Constructor
  LocalizationPlusController._({
    required this.supportedLocales,
    required this.currentLocale,
    required this.deviceLocale,
    required this.fallbackLocale,
    required String path,
    required AssetLoader loader,
    required bool saveLocale,
    required bool useOnlyLangCode,
    required bool useFallbackTranslations,
    required Locale? startLocale,
    required SharedPreferenceHelper sharedPreferenceHelper,
  }) : assert(path.isNotEmpty) {
    _startLocale = startLocale;
    _useFallbackTranslations = useFallbackTranslations;
    _useOnlyLangCode = useOnlyLangCode;
    _saveLocale = saveLocale;
    _path = path;
    _loader = loader;
    _sharedPreferenceHelper = sharedPreferenceHelper;
  }

  static Future<LocalizationPlusController> init({
    required String path,
    required List<Locale> supportedLocales,
    AssetLoader loader = const RootBundleAssetLoader(),
    bool saveLocale = true,
    bool useOnlyLangCode = false,
    bool useFallbackTranslations = false,
    Locale? startLocale,
    Locale? fallbackLocale,
  }) async {
    assert(supportedLocales.isNotEmpty);

    SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper(
        sharedPreferences: await SharedPreferences.getInstance());
    // if locale saving is on, let's get the saved locale
    Locale? savedLocale = saveLocale ? sharedPreferenceHelper.locale : null;

    Locale deviceLocale = (await findSystemLocale()).toString().toLocale();
    Locale currentLocale;

    if (savedLocale != null &&
        supportedLocales.firstWhereOrNull(
                (supportedLocale) => supportedLocale.equals(savedLocale)) !=
            null) {
      currentLocale = savedLocale;
    } else if (startLocale != null &&
        supportedLocales.firstWhereOrNull(
                (supportedLocale) => supportedLocale.equals(startLocale)) !=
            null) {
      currentLocale = startLocale;
    } else if (supportedLocales.firstWhereOrNull(
            (supportedLocale) => supportedLocale.equals(deviceLocale)) !=
        null) {
      currentLocale = deviceLocale;
    } else {
      currentLocale = supportedLocales.first;
    }

    if (useFallbackTranslations && fallbackLocale == null) {
      fallbackLocale = supportedLocales.first;
    }

    LocalizationPlusController instance = LocalizationPlusController._(
      supportedLocales: supportedLocales,
      path: path,
      loader: loader,
      currentLocale: currentLocale,
      saveLocale: saveLocale,
      useOnlyLangCode: useOnlyLangCode,
      useFallbackTranslations: useFallbackTranslations,
      sharedPreferenceHelper: sharedPreferenceHelper,
      startLocale: startLocale,
      fallbackLocale: fallbackLocale,
      deviceLocale: deviceLocale,
    );

    await instance._loadTranslations();
    return instance;
  }
  // endregion

  // region - Getters
  Map<String, dynamic>? get translations => _translations;

  Map<String, dynamic>? get fallbackTranslations => _fallbackTranslations;

  bool get hasActiveListener => hasListeners;
  // endregion

  // region - Public Methods
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      throw AssertionError('Locale not supported');
    }

    if (locale == currentLocale) return;

    currentLocale = locale;
    await _loadTranslations();

    if (_saveLocale) {
      await _sharedPreferenceHelper.saveLocale(locale: locale);
    }

    notifyListeners();
  }

  Future<void> resetLocale() async {
    await setLocale(_startLocale ?? deviceLocale);
  }

  Future<void> deleteSavedLocale() async {
    await _sharedPreferenceHelper.deleteLocale();
  }

  Future _loadTranslations() async {
    try {
      _translations = Map.from(
        await _loader.load(
            path: _path,
            locale: currentLocale,
            useOnlyLanguageCode: _useOnlyLangCode),
      );

      if (_useFallbackTranslations && fallbackLocale != null) {
        _fallbackTranslations = Map.from(
          await _loader.load(
              path: _path,
              locale: fallbackLocale!,
              useOnlyLanguageCode: _useOnlyLangCode),
        );
      }

      translationsLoadError = null;
    } catch (err) {
      translationsLoadError = err;
      notifyListeners();
    }
  }

// endregion
}
