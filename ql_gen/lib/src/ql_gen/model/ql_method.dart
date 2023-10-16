import 'package:ql_gen/src/ql_gen/model/ql_field.dart';
import 'package:ql_gen/src/ql_gen/model/ql_object.dart';
import 'package:ql_gen/src/ql_gen/model/ql_type.dart';

class QlMethod {
  final String name;
  final List<QlField> parameters;
  final QlType returnType;
  final QlObjectType objectType;

  const QlMethod({
    required this.name,
    this.parameters = const [],
    required this.returnType,
    required this.objectType,
  });

  String get qlMethodName => '${name}Ql';

  String get qlMethod {
    StringBuffer output = StringBuffer();
    output.writeln('String $qlMethodName(');
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('${returnType.selectorName} \$selector,');
    }
    for (QlField e in parameters) {
      output.writeln(e.parameter);
    }
    output.writeln(') {');
    output.writeln('StringBuffer output = StringBuffer();');
    if (objectType == QlObjectType.query) {
      output.writeln('output.writeln(\'query {\');');
    } else if (objectType == QlObjectType.mutation) {
      output.writeln('output.writeln(\'mutation {\');');
    } else if (objectType == QlObjectType.subscription) {
      output.writeln('output.writeln(\'subscription {\');');
    }
    output
        .writeln('output.writeln(\'$name${parameters.isEmpty ? '' : '('}\');');
    for (QlField e in parameters) {
      output.writeln(e.input(true));
    }
    if (parameters.isNotEmpty) {
      output.writeln('output.writeln(\')\');');
    }
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('output.writeln(\$selector);');
    }

    output.writeln('output.writeln(\'}\');');
    output.writeln('return output.toString();');
    output.writeln('}');
    return output.toString();
  }

  String get method {
    if (objectType == QlObjectType.subscription) {
      return _subscription;
    } else {
      return _query;
    }
  }

  String get _subscription {
    StringBuffer output = StringBuffer();
    output.writeln('Stream<$returnType> $name (');
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('${returnType.selectorName} \$selector,');
    }
    for (QlField e in parameters) {
      output.writeln(e.parameter);
    }
    output.writeln(') {');
    output.writeln('return _executor($qlMethodName(');
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('\$selector,');
    }
    for (QlField e in parameters) {
      output.writeln('${e.name},');
    }
    output.write(')).map((e) => construct(e?[\'$name\'],');
    if (!returnType.isBasicTypeOrBasicList) {
      output.write(' fromMap: ${returnType.coreType.name}.fromMap,');
    }
    output.writeln('));');
    output.writeln('}');
    return output.toString();
  }

  String get _query {
    StringBuffer output = StringBuffer();
    output.writeln('Future<$returnType> $name (');
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('${returnType.selectorName} \$selector,');
    }
    for (QlField e in parameters) {
      output.writeln(e.parameter);
    }
    output.writeln(') async {');
    output.writeln('return construct((await _executor($qlMethodName(');
    if (!returnType.isBasicTypeOrBasicList) {
      output.writeln('\$selector,');
    }
    for (QlField e in parameters) {
      output.writeln('${e.name},');
    }
    output.write(')))?[\'$name\'],');
    if (!returnType.isBasicTypeOrBasicList) {
      output.write(' fromMap: ${returnType.coreType.name}.fromMap,');
    }
    output.writeln(');');
    output.writeln('}');
    return output.toString();
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln(method);
    output.writeln(qlMethod);
    return output.toString();
  }
}
