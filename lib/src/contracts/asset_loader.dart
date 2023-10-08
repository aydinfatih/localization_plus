import 'package:flutter/material.dart';

abstract class AssetLoader {
  const AssetLoader();

  Future<Map<String, dynamic>> load(
      {required String path,
      required Locale locale,
      required bool useOnlyLanguageCode});
}
