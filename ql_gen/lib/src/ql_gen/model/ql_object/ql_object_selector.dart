import 'package:ql_gen/src/ql_gen/model/ql_field.dart';
import 'package:ql_gen/src/ql_gen/model/ql_object/ql_object.dart';

class QlObjectSelector {
  final QlObject object;
  const QlObjectSelector(this.object);

  String get constructor {
    StringBuffer output = StringBuffer();
    output.write('const ${object.selectorName}({');
    for (QlField field in object.nullableBasicFields) {
      output.write('this.${field.name} = false,');
    }
    for (QlField field in object.nonNullableNonBasicFields) {
      output.write('this.${field.name} = const ${field.type.selectorName}(),');
    }
    for (QlField field in object.nullableNonBasicFields) {
      output.write('this.${field.name},');
    }
    output.write('});');
    return output.toString().replaceAll(RegExp(r'{\s*}', multiLine: true), '');
  }

  String get fields {
    StringBuffer output = StringBuffer();
    for (QlField field in object.nullableBasicFields) {
      output.write('final bool ${field.name};');
    }
    for (QlField field in object.nonNullableNonBasicFields) {
      output.write('final ${field.type.selectorName} ${field.name};');
    }
    for (QlField field in object.nullableNonBasicFields) {
      output.write('final ${field.type.selectorName}? ${field.name};');
    }
    return output.toString();
  }

  /// return the toString method for the object
  String get toStringMethod {
    StringBuffer output = StringBuffer();
    output.writeln('@override');
    output.writeln('String toString() {');
    output.writeln('StringBuffer output = StringBuffer();');
    output.writeln('output.writeln(\'{\');');
    for (QlField field in object.nonNullableBasicFields) {
      output.writeln('output.writeln(\'${field.name}\');');
    }
    for (QlField field in object.nullableBasicFields) {
      output.writeln('if(${field.name}) {output.writeln(\'${field.name}\');}');
    }
    for (QlField field in object.nullableNonBasicFields) {
      output.writeln('if(${field.name} != null) {');
      output.writeln('output.writeln(\'${field.name} \${${field.name}!}\');');
      output.writeln('}');
    }
    for (QlField field in object.nonNullableNonBasicFields) {
      output.writeln('output.writeln(\'${field.name} \$${field.name}\');');
    }
    output.write('output.writeln(\'}\');');
    output.write('return output.toString();');
    output.write('}');
    return output.toString();
  }

  @override
  String toString() {
    if (object.fields.isEmpty) {
      return '';
    }
    return 'class ${object.selectorName} { $fields $constructor $toStringMethod }';
  }
}
