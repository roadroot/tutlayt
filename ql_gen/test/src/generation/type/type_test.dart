import 'package:test/test.dart';

import '../generation_util.dart';

void main() {
  group('type tests', () {
    test(
      'Basic type must be correctly converted',
      () => GenUtils.test('type/base'),
    );

    test(
      'Multiple types must be correctly converted',
      () => GenUtils.test('type/multiple'),
    );

    test(
      'Multiple types with relations must be correctly converted',
      () => GenUtils.test('type/related'),
    );
  });
}
