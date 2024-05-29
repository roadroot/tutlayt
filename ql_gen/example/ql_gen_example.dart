import 'dart:io';

import 'package:ql_gen/ql_gen.dart';
import 'package:ql_gen/src/ql_gen/ql_parser.dart';

void main() async {
  var input = ApiGenerator('static/test/schema.gql');
  File('ql.dart').writeAsStringSync(input.dartQlApi);
  Process.runSync('dart', ['format', 'ql.dart']);
}
