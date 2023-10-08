import 'package:localization_plus/src/localization.dart';

String trans(String key, {Map<String, String>? arguments}) {
  return Localization.instance.trans(key, arguments: arguments);
}

String transChoice(String key, num number, {Map<String, String>? arguments}) {
  return Localization.instance.transChoice(key, number, arguments: arguments);
}

String plural(String key, num number, {Map<String, String>? arguments}) {
  return Localization.instance.plural(key, number, arguments: arguments);
}

bool transExists(String key) {
  return Localization.instance.exists(key);
}
