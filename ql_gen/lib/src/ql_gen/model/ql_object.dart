import 'package:ql_gen/src/ql_gen/model/ql_field.dart';
import 'package:ql_gen/src/ql_gen/model/ql_method.dart';

class QlObject {
  final String name;
  final List<QlField> fields;
  final List<QlMethod> methods;
  final QlObjectType type;
  static final String constructMethod = '''
  dynamic construct(dynamic data,
      {dynamic Function(Map<String, dynamic>)? fromMap}) {
    if (data is List) {
      return data.map((e) => construct(e, fromMap: fromMap));
    }
    if (fromMap != null) {
      return fromMap(data);
    }
    return data;
  }
  ''';

  bool get hasUploadType => fields.any((e) => e.type.isUploadType);

  Iterable<QlField> get nullableBasicFields =>
      fields.where((e) => e.type.isNullable && e.type.isBasicTypeOrBasicList);
  Iterable<QlField> get nonNullableBasicFields =>
      fields.where((e) => !e.type.isNullable && e.type.isBasicTypeOrBasicList);
  Iterable<QlField> get nullableNonBasicFields =>
      fields.where((e) => e.type.isNullable && !e.type.isBasicTypeOrBasicList);
  Iterable<QlField> get nonNullableNonBasicFields =>
      fields.where((e) => !e.type.isNullable && !e.type.isBasicTypeOrBasicList);
  Iterable<QlField> get nonBasicFields =>
      fields.where((e) => !e.type.isBasicTypeOrBasicList);
  Iterable<QlField> get nullableFields =>
      fields.where((e) => e.type.isNullable);
  Iterable<QlField> get nonNullableFields =>
      fields.where((e) => !e.type.isNullable);

  const QlObject({
    required this.name,
    this.fields = const [],
    this.methods = const [],
    this.type = QlObjectType.type,
  });

  String get classFields {
    StringBuffer output = StringBuffer();
    if (type == QlObjectType.query || type == QlObjectType.mutation) {
      output.writeln(
          'final Future<Map<String, dynamic>?> Function(String query) _executor;');
    } else {
      for (QlField field in fields) {
        output.writeln(field.classField);
      }
    }
    return output.toString();
  }

  String get constructor {
    StringBuffer output = StringBuffer();
    if (type == QlObjectType.query ||
        type == QlObjectType.mutation ||
        type == QlObjectType.subscription) {
      output.writeln('const $name(this._executor);');
    } else {
      output.writeln('const $name({');
      for (QlField e in fields) {
        output.writeln(e.constructorField);
      }
      output.writeln('});');
    }
    return output.toString().replaceAll(RegExp(r'{\s*}', multiLine: true), '');
  }

  String get classMethods {
    return methods.map((e) => '$e').join('');
  }

  String get toStringMethod {
    StringBuffer output = StringBuffer();
    output.writeln('@override');
    output.writeln('String toString() {');
    output.writeln('StringBuffer output = StringBuffer();');
    output.writeln('output.writeln(\'{\');');
    for (QlField field in fields) {
      output.writeln(field.input);
    }
    output.write('output.writeln(\'}\');');
    output.write('return output.toString();');
    output.write('}');
    return output.toString();
  }

  String get fromMap {
    return 'factory $name.fromMap(Map<String, dynamic> data) {return $name(${fields.map((e) => '${e.name}: data[\'${e.name}\'],').join('')});}';
  }

  @override
  String toString() {
    StringBuffer output = StringBuffer();
    output.writeln('class $name {');
    output.writeln(classFields);
    output.writeln(constructor);
    if (type == QlObjectType.type) {
      output.writeln(fromMap);
    }
    output.writeln(constructMethod);
    output.writeln(classMethods);
    output.writeln(toStringMethod);
    output.writeln('}');
    if (type == QlObjectType.type) {
      output.writeln(QlObjectSelector(this));
    }
    return output.toString();
  }

  String get selectorName => '${name}Selector';
}

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

  String get selectGetter {
    StringBuffer output = StringBuffer();
    output.writeln('String select() {');
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
      output.writeln(
          'output.writeln(\'${field.name} \${${field.name}!.select()}\');');
      output.writeln('}');
    }
    for (QlField field in object.nonNullableNonBasicFields) {
      output.writeln(
          'output.writeln(\'${field.name} \${${field.name}.select()}\');');
    }
    output.write('output.writeln(\'}\');');
    output.write('return output.toString();');
    output.write('}');
    return output.toString();
  }

  String get toStringMethod {
    StringBuffer output = StringBuffer();
    output.writeln('@override');
    output.writeln('String toString() {');
    output.writeln('StringBuffer output = StringBuffer();');
    output.writeln('output.writeln(\'{\');');
    for (QlField field in object.fields) {
      if (field.type.isNullable) {
        if (field.type.isBasicTypeOrBasicList) {
          output.writeln('if(${field.name}) {');
        } else {
          output.writeln('if(${field.name} != null) {');
        }
      }
      output.writeln('output.writeln(\'${field.name}\');');
      if (field.type.isNullable) {
        output.writeln('}');
      }
    }
    output.writeln('output.writeln(\'}\');');
    output.writeln('return output.toString();');
    output.writeln('}');

    return output.toString();
  }

  @override
  String toString() {
    if (object.fields.isEmpty) {
      return '';
    }
    return 'class ${object.selectorName} { $fields $constructor $selectGetter $toStringMethod }';
  }
}

enum QlObjectType {
  input,
  type,
  mutation,
  query,
  subscription;

  const QlObjectType();
  factory QlObjectType.from(String value) {
    switch (value) {
      case 'input':
        return QlObjectType.input;
      case 'type':
        return QlObjectType.type;
      case 'mutation':
        return QlObjectType.mutation;
      case 'query':
        return QlObjectType.query;
      case 'subscription':
        return QlObjectType.subscription;
      default:
        throw Exception('Invalid QlObjectType');
    }
  }
}
