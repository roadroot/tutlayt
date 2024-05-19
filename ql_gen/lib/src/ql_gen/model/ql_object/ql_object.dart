import 'package:ql_gen/src/ql_gen/model/ql_field.dart';
import 'package:ql_gen/src/ql_gen/model/ql_method.dart';

import 'ql_object_selector.dart';
import 'ql_object_type.dart';

class QlObject {
  final String name;
  final List<QlField> fields;
  final List<QlMethod> methods;
  final QlObjectType type;

  const QlObject({
    required this.name,
    this.fields = const [],
    this.methods = const [],
    this.type = QlObjectType.type,
  });

  Iterable<QlField> get nullableBasicFields =>
      fields.where((e) => e.type.isNullable && e.type.hasNativeCore);
  Iterable<QlField> get nonNullableBasicFields =>
      fields.where((e) => !e.type.isNullable && e.type.hasNativeCore);
  Iterable<QlField> get nullableNonBasicFields =>
      fields.where((e) => e.type.isNullable && !e.type.hasNativeCore);
  Iterable<QlField> get nonNullableNonBasicFields =>
      fields.where((e) => !e.type.isNullable && !e.type.hasNativeCore);
  Iterable<QlField> get variables => fields.where((e) => e.type.isVariable);

  String get classFields {
    StringBuffer output = StringBuffer();
    if (type.isOperation) {
      if (type == QlObjectType.subscription) {
        output.writeln(
            'final Stream<Map<String, dynamic>?> Function((String, Map<String, dynamic>) queryAndVariables) _executor;');
      } else {
        output.writeln(
            'final Future<Map<String, dynamic>?> Function((String, Map<String, dynamic>) queryAndVariables) _executor;');
      }
    }

    for (QlField field in fields) {
      output.writeln(field.classField);
    }
    return output.toString();
  }

  /// Returns the constructor of the class of the [QlObject].
  /// The consutructor is diffrent if the object is `Query`, `Mutation`, `Subscription`
  /// or if it is an input or type...
  String get constructor {
    StringBuffer output = StringBuffer();
    if (type.isOperation) {
      output.writeln('const $name(this._executor);');
    } else {
      output.writeln('const $name({');
      for (QlField field in fields) {
        output.writeln(field.constructorField);
      }
      output.writeln('});');
    }
    return output.toString().replaceAll(RegExp(r'{\s*}', multiLine: true), '');
  }

  String get classMethods {
    return methods.map((e) => '$e').join('');
  }

  String get buildMethod {
    StringBuffer output = StringBuffer();
    output.write('''(String, VariableContainer) build() {
      StringBuffer output = StringBuffer();
      final VariableContainer variables = VariableContainer();
      output.writeln('{');''');
    for (QlField field in fields) {
      output.writeln(field.qlValueCode);
    }
    output.write('''output.writeln('}');
      return (output.toString(), variables);
    }
    ''');
    return output.toString();
  }

  String get toStringMethod {
    return '''@override
      String toString() {
        return build().\$1;
      }
      ''';
  }

  /// Convert the result of a query to a dart object
  String get fromMap {
    StringBuffer output = StringBuffer();
    output.writeln('factory $name.fromMap(Map<String, dynamic> data) {');
    output.writeln('return $name(');
    for (QlField field in fields) {
      if (field.type.hasNativeCore) {
        if (field.type.isList) {
          if (field.type.nativeType?.parseFunction != null) {
            output.writeln(
                '${field.name}: data[\'${field.name}\']?.map(${field.type.nativeType!.parseFunction!})?.toList(),');
          } else {
            output.writeln(
                '${field.name}: data[\'${field.name}\']?.cast<${field.type.coreType.name}>(),');
          }
        } else {
          if (field.type.nativeType?.parseFunction != null) {
            output.writeln(
                '${field.name}: ${field.type.nativeType!.parseFunction!}(data[\'${field.name}\']),');
          } else {
            output.writeln('${field.name}: data[\'${field.name}\'],');
          }
        }
      } else {
        if (field.type.isList) {
          output.writeln(
              '${field.name}: construct(data[\'${field.name}\'], fromMap: ${field.type.coreType.name}.fromMap)?.cast<${field.type.coreType.name}>(),');
        } else if (field.type.isNullable) {
          output.writeln(
              '${field.name}: data[\'${field.name}\'] == null ? null : ${field.type.name}.fromMap(data[\'${field.name}\']),');
        } else {
          output.writeln(
              '${field.name}: ${field.type.name}.fromMap(data[\'${field.name}\']),');
        }
      }
    }
    output.writeln(');');
    output.writeln('}');
    return output.toString();
  }

  @override
  String toString() {
    if (fields.isEmpty && methods.isEmpty) {
      return '';
    }
    StringBuffer output = StringBuffer();
    output.writeln('class $name {');
    output.writeln(classFields);
    output.writeln(constructor);
    if (type == QlObjectType.type) {
      output.writeln(fromMap);
    }
    output.writeln(classMethods);
    output.writeln(buildMethod);
    output.writeln('}');
    if (type == QlObjectType.type) {
      output.writeln(QlObjectSelector(this));
    }
    return output.toString();
  }

  String get selectorName => '${name}Selector';
}
