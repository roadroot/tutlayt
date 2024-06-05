import 'package:ql_gen/src/ql_gen/model/ql_type.dart';

enum QlFieldType { field, parameter }

class QlField {
  final String name;
  final QlType type;
  final QlFieldType fieldType;

  static const Map<String, String> _specialCharacters = {
    r'\\': r'\\\\',
    r'\n': r'\\n',
    r'\r': r'\\r',
    r'\t': r'\\t',
    '"': r'\\\"',
  };

  const QlField(
      {required this.name, required this.type, required this.fieldType});

  String get classField => 'final $this;';
  String get constructorField =>
      '${type.isNullable ? '' : 'required '}this.$name,';
  String get parameter => '$this,';

  /// returns the required symbol if the *field* (empty string in cased of a parameter) is nullable
  String get required =>
      type.isNullable && fieldType == QlFieldType.field ? '!' : '';

  /// dart code to print the content of the field in a query
  String get qlValueCode {
    String output = '';
    if (type.isVariable) {
      output = 'output.write(\'$name: \');${handleVariable(name, type)}';
    } else {
      output = '''output.write('$name: ');
          ${handleList(name, type, isNullHandled: true)}
          ''';
    }
    if (type.isNullable) {
      output = 'if ($name != null) {$output}';
    }
    return output;
  }

  /// Returns code to handle a variable in a query.
  String handleVariable(String name, QlType type) {
    if (type.isList) {
      return '''output.write('[');
        for(var element in $name$required) {
          ${handleVariable('element', type.innerType!)}
          output.write(',');
        }
        output.write(']');''';
    } else {
      return '''
        {
          final keyName = '${this.name}_\$keyGenerator';
          variables.add(${type.isString ? '\'${handleString(name, type)}\'' : name}, '${type.nativeType?.qlName}!', keyName);
          output.write('\\\$\$keyName');
        }
''';
    }
  }

  /// Returns code to print the content of (list of)* elements in a query.
  ///
  /// String with its special characters fixed (e.g. \n -> \\n).
  ///
  /// [name] is the name of the field
  /// [type] is the type of the field
  /// [isNullHandled] is true if the nullability of the field has already been handled
  String handleList(String name, QlType type,
      {bool isNullHandled = false, bool isParentList = false}) {
    String output;
    if (type.isList) {
      output = '''output.write('[');
          for(var element in $name$required) {
            ${handleList('element', type.innerType!, isParentList: true)}
            output.write(',');
          }
          output.write(']');''';
    } else {
      if (!type.isString) {
        if (type.nativeType == null) {
          output = '''{
            final result = $name${isParentList ? '' : required}.build();
            variables.concat(result.\$2);
            output.write(result.\$1);
          }
          ''';
        } else {
          output = 'output.writeln($name);';
        }
      } else {
        // todo check
        output =
            'output.writeln(${type.isNullable && !isNullHandled ? '$name==null?null:' : ''}\'${handleString(name, type)}\');';
      }
    }

    return output;
  }

  String handleString(String name, QlType type) {
    return '"\${$name$required${_specialCharacters.entries.map((e) => '.replaceAll(\'${e.key}\', r\'${e.value}\')').join('')}}"';
  }

  /// field as a parameter in a method (e.g. `String name`)
  @override
  String toString() {
    return '$type $name';
  }
}
