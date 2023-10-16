import 'package:test/test.dart';

import '../generation_util.dart';

void main() {
  group('mutation tests', () {
    test('mutation must be generated', () => GenUtils.test('mutation'));
  });
}
