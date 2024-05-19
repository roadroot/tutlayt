import 'dart:io';

import 'package:ql_gen/ql_gen.dart';
import 'package:test/test.dart';

abstract class GenUtils {
  static String getQlPath(String name) {
    return 'static/test/$name/input.gql';
  }

  static String getDartPath(String name) {
    return 'static/test/$name/output.dart';
  }

  static String generateQl(String name) {
    return ApiGenerator(getQlPath(name)).dartQlApi;
  }

  static String destruct(String dart) {
    return dart
        .replaceAll(RegExp(r'\n'), ' ')
        .replaceAllMapped(
            RegExp(r'([,;\(\)\[\]{}])'), (match) => ' ${match.group(1)} ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String getDestructedQl(String name) {
    return destruct(generateQl(name));
  }

  static String getDestructedDart(String name) {
    return destruct(File(getDartPath(name)).readAsStringSync());
  }

  static void test(String name) {
    expect(getDestructedQl(name), equals(getDestructedDart(name)));
  }
}
