import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_plus/src/contracts/asset_loader.dart';

class RootBundleAssetLoader extends AssetLoader {
  const RootBundleAssetLoader();

  @override
  Future<Map<String, dynamic>> load({
    required String path,
    required Locale locale,
    required bool useOnlyLanguageCode,
  }) async {
    String filename =
        useOnlyLanguageCode ? locale.languageCode : locale.toLanguageTag();
    String localePath = '$path/$filename.json';
    return json.decode(await rootBundle.loadString(localePath)) ?? {};
  }
}
