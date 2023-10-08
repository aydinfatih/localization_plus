import 'package:flutter_test/flutter_test.dart';
import 'package:localization_plus/src/extensions/map_extension.dart';

import '../../test_case.dart';

void main() {
  group('Map Extension', () {
    test('it selects by key', () async {
      expect(translations.select('one.two.three'), equals('four'));
      expect(translations.select('one.two'), {"three": "four"});
      expect(translations.select('test'), equals('example'));
      expect(translations.select('none'), isNull);
    });
  });
}
