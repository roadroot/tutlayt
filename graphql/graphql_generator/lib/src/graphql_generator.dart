import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:graphql_generator/src/field_data.dart';
import 'package:graphql_generator/src/visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:graphql_decorator/annotations.dart';

class GraphQLGenerator extends GeneratorForAnnotation<QlEntity> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    var string = StringBuffer();
    QlEntityVisitor visitor = QlEntityVisitor(string);
    element.visitChildren(visitor);
    string.writeln(generateResultType(visitor));
    string.writeln(genateClass(visitor));
    return string.toString();
  }

  static String generateResultType(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('class ${visitor.className!.toResultName()} {');
    output.writeln(generateResultTypeConstructor(visitor));
    output.writeln(generateFromMap(visitor));
    visitor.fields.forEach((value) {
      output.writeln(
          '  final ${value.type.toResultName(withList: true, withNullability: true)} ${value.technicalName};');
    });
    output.writeln();
    output.writeln(generateResultTypeToString(visitor));
    output.writeln('}');
    return output.toString();
  }

  static String genateClass(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('class ${visitor.className!.toQlClassName()} {');
    output.writeln(genenateFields(visitor));
    output.writeln(generateConstructor(visitor));
    output.writeln(generateQueries(visitor));
    output.writeln(generateToString(visitor));
    output.writeln('}');
    return output.toString();
  }

  static String genenateFields(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    visitor.fields
        .where((field) => field.type.isNullable || field.type.isObject)
        .forEach((value) {
      if (value.type.isObject) {
        output.writeln(
            '  final ${value.type.toQlClassName(withNullability: true)} ${value.technicalName};');
      } else {
        output.writeln('  final bool? ${value.technicalName};');
      }
    });
    return output.toString();
  }

  static String generateConstructor(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('  const ${visitor.className!.toQlClassName()}({');
    visitor.fields.where((field) => field.type.isNullable).forEach((value) {
      output.writeln('    this.${value.technicalName},');
    });
    visitor.fields
        .where((field) => !field.type.isNullable && field.type.isObject)
        .forEach((value) {
      output.writeln(
          '    this.${value.technicalName} = const ${value.type.toQlClassName()}(),');
    });
    output.writeln('  });');
    return output.toString().replaceAll(RegExp(r'{\s*}'), '');
  }

  static String generateToString(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('  @override');
    output.writeln('  String toString() {');
    output.writeln('    StringBuffer output = StringBuffer();');
    output.writeln('    output.writeln(\'{\');');
    visitor.fields
        .where((element) => !element.type.isNullable && !element.type.isObject)
        .forEach((value) {
      output.writeln('    output.writeln(\'${value.alias}\');');
    });
    visitor.fields
        .where((element) => element.type.isNullable || element.type.isObject)
        .forEach((value) {
      if (value.type.isNullable) {
        output.writeln('    if(${value.technicalName} != null) {');
      }
      if (value.type.isObject) {
        output.writeln(
            '      output.writeln(\'${value.alias}: \$${value.technicalName}\');');
      } else {
        output.writeln('      output.writeln(\'${value.alias}\');');
      }
      if (value.type.isNullable) {
        output.writeln('    }');
      }
    });
    output.writeln('    output.writeln(\'}\');');
    output.writeln('    return output.toString();');
    output.writeln('  }');
    return output.toString();
  }

  static String generateQueries(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    visitor.functions.forEach((value) {
      output.writeln('  static String ${value.actualName}(');
      output.writeln('  {');
      if (value.returnType.isExplicit && value.returnType.isObject) {
        output.writeln(
            '    ${value.returnType.toQlClassName()} select = const ${value.returnType.toQlClassName()}(),');
      }
      output.writeln(
          '${value.parameters.map((e) => '${e.type.toResultName(withList: true, withNullability: true, withRequired: true)} ${e.alias},').join('')}}) {'
              .replaceAll('{}', ''));
      output.writeln('    StringBuffer output = StringBuffer();');
      output.writeln('    output.writeln(\'${value.type.name} {\');');
      if (value.parameters.isNotEmpty) {
        output.writeln('    output.writeln(\'  ${value.name}(\');');
        value.parameters.forEach((element) {
          if (element.type.isNullable) {
            output.write('    if(${element.alias} != null) {\n  ');
          }
          output.writeln(
              '    output.writeln(\'    ${element.alias}: ${element.toValue()}\');');
          if (element.type.isNullable) {
            output.write('    }\n  ');
          }
        });
        output.write('    output.writeln(\'  )');
      } else {
        output.write('    output.writeln(\'  ${value.name}');
      }
      if (value.returnType.isExplicit && value.returnType.isObject) {
        output.writeln(' \$select\');');
      } else {
        output.writeln('\');');
      }
      output.writeln('    output.writeln(\'}\');');
      output.writeln('    return output.toString();');
      output.writeln('}');
    });
    return output.toString().replaceAll(RegExp(r'{\s*}'), '');
  }

  static String generateResultTypeToString(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('  @override');
    output.writeln('  String toString() {');
    output.writeln('    StringBuffer output = StringBuffer();');
    output.writeln('    output.writeln(\'{\');');
    visitor.fields.forEach((value) {
      if (value.type.isNullable) {
        output.writeln('    if(${value.technicalName} != null) {');
      }
      output.writeln(
          '     output.writeln(\'${value.alias}: ${value.toValue()},\');');
      if (value.type.isNullable) {
        output.writeln('    }');
      }
    });
    output.writeln('    output.writeln(\'}\');');
    output.writeln(
        '    return output.toString().replaceAll(\',\\n}\', \'\\n}\');');
    output.writeln('  }');
    return output.toString();
  }

  static String generateResultTypeConstructor(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln('  const ${visitor.className!.toResultName()}({');
    visitor.fields.forEach((value) {
      if (value.type.isNullable) {
        output.writeln('    this.${value.technicalName},');
      } else {
        output.writeln('    required this.${value.technicalName},');
      }
    });
    output.writeln('  });');
    return output.toString();
  }

  static String generateFromMap(QlEntityVisitor visitor) {
    StringBuffer output = StringBuffer();
    output.writeln(
        '  static ${visitor.className!.toResultName()}? fromMap(Map<String, dynamic>? data) {');
    output.writeln('    if(data == null) {');
    output.writeln('      return null;');
    output.writeln('    }');

    output.writeln('    return ${visitor.className!.toResultName()}(');
    visitor.fields.forEach((value) {
      output.writeln(
          '      ${value.technicalName}: ${generateMapping(value, withList: true)},');
    });
    output.writeln('    );');
    output.writeln('  }');
    return output.toString();
  }

  static String generateMapping(Variable field, {withList = false}) {
    if (field.type.isList && withList) {
      if (field.type.isObject) {
        return 'data[\'${field.alias}\']?.map<${field.type.toResultName()}>((e) => ${field.type.toResultName()}.fromMap(e))';
      }
      return 'data[\'${field.alias}\'] as List<${field.type.toResultName()}>';
    }
    if (field.type.isObject) {
      return '${field.type.toResultName()}.fromMap(data[\'${field.alias}\'])';
    }

    return 'data[\'${field.alias}\'] as ${field.type.toResultName(withNullability: true)}';
  }
}
