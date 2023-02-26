import 'package:graphql_generator/src/element_type.dart';

class Variable {
  const Variable({
    required this.alias,
    required this.technicalName,
    required this.type,
  });

  final String alias;
  final String technicalName;
  final VariableType type;

  @override
  String toString() {
    return 'Variable[alias: $alias, technicalName: $technicalName, type: $type]';
  }

  String toValue({bool enableList = false}) {
    if (type.isList && enableList) {
      if (type.isString) {
        return '\${"${technicalName}.map((e) => "\${e}").join(", ")}';
      } else {
        return '\${${technicalName}.join(", ")}';
      }
    } else if (type.isString) {
      return '"\$${technicalName}"';
    } else {
      return '\$${technicalName}';
    }
  }
}
