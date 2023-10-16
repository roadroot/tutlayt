import 'package:test/test.dart';

import '../generation_util.dart';

void main() {
  group('subscription tests', () {
    test('subscription must be generated', () => GenUtils.test('subscription'));
  });
}
