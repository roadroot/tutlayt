import 'package:ql_gen/src/utils/iterables.dart';
import 'package:test/test.dart';

class _EqualityMatcher extends Matcher {
  final Iterable<Object>? expected;
  const _EqualityMatcher(this.expected);

  @override
  bool matches(actual, Map matchState) => equal(actual, expected);

  @override
  Description describe(Description description) =>
      description.addDescriptionOf(expected);
}

Matcher iterableEquals(Iterable<Object>? expected) =>
    _EqualityMatcher(expected);
