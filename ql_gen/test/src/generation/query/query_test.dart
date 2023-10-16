import 'package:test/test.dart';

import '../generation_util.dart';

void main() {
  group('query tests', () {
    test('empty query must be generated', () => GenUtils.test('query/empty'));
  });
}
