import 'package:ql_gen/src/ql_gen/model/ql_type.dart';

class QlField {
  final String name;
  final QlType type;

  static const Map<String, String> _specialCaractes = {
    r'\n': r'\\n',
    r'\r': r'\\r',
    r'\t': r'\\t',
    '"': r'\\\"',
  };

  const QlField({required this.name, required this.type});

  String get nameWithRequired => '$name${type.isNullable ? '!' : ''}';
  String get classField => 'final $this;';
  String get constructorField =>
      '${type.isNullable ? '' : 'required '}this.$name,';
  String get parameter => '$this,';
  String get nameWithNullable => '$name${type.isNullable ? '?' : ''}';

  String input(bool inMethod) {
    StringBuffer output = StringBuffer();
    if (type.isNullable) {
      output.writeln('if ($name != null) {');
    }
    if (type.isString) {
      output.write(
          'output.writeln(\'$name: "\${$name${type.isNullable && !inMethod ? '?' : ''}${_specialCaractes.entries.map((e) => '.replaceAll(\'${e.key}\', r\'${e.value}\')').reduce((value, element) => value + element)}}"\');');
    } else if (type.isList) {
      output.writeln('output.writeln(\'$name: [\');');
      output.writeln('output.writeln($nameWithRequired.join(\',\\n\'));');
      output.writeln('output.writeln(\']\');');
    } else {
      output.writeln('output.writeln(\'$name: \$$name\');');
    }
    if (type.isNullable) {
      output.writeln('}');
    }
    return output.toString();
  }

  @override
  String toString() {
    return '$type $name';
  }
}
