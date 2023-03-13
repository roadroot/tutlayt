import 'package:ql_gen/ql_gen.dart';
import 'package:ql_gen/src/ql_gen/ql_parser.dart';

void main() async {
  var input = QlParser('static/test/schema.gql');
  print(input.tokens);
}
