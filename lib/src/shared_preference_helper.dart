import 'package:flutter/material.dart';
import 'package:localization_plus/src/extensions/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  late SharedPreferences _sharedPreferences;
  final String _localeKey = 'locale';

  static final SharedPreferenceHelper _instance = SharedPreferenceHelper._();

  SharedPreferenceHelper._();

  factory SharedPreferenceHelper(
      {required SharedPreferences sharedPreferences}) {
    _instance._sharedPreferences = sharedPreferences;
    return _instance;
  }

  Future<bool> saveLocale({required Locale locale}) async {
    return await _sharedPreferences.setString(_localeKey, locale.toString());
  }

  Future<bool> deleteLocale() async {
    return await _sharedPreferences.remove(_localeKey);
  }

  Locale? get locale {
    return _sharedPreferences.get(_localeKey)?.toString().toLocale();
  }
}
