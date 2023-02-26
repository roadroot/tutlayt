import 'package:graphql_generator/src/element_type.dart';
import 'package:graphql_generator/src/field_data.dart';

enum RequestType {
  query,
  mutation,
  subscription,
}

class FunctionStruture {
  final String name;
  final String actualName;
  final VariableType returnType;
  final List<Variable> parameters;
  final RequestType type;

  FunctionStruture({
    required this.name,
    required this.actualName,
    required this.returnType,
    required this.parameters,
    required this.type,
  });
}
