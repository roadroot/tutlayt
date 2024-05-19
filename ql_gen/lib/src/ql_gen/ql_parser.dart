import 'dart:io';

import 'package:ql_gen/src/ql_gen/ql_visitor.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:tokenizer/tokenizer.dart';

import 'model/native_type.dart';

class ApiGenerator {
  late List<Token> tokens;
  late List<Input> remainingSegments;
  late QlParser visitor;

  final String stringBufferExtension = '''
  extension InsertAt on StringBuffer {
    void insertAt(int index, String value) {
      if (index < 0 || index > length) {
        throw RangeError('index \$index out of bounds');
      }
      String temp = toString();
      clear();
      write(temp.substring(0, index));
      write(value);
      write(temp.substring(index));
    }
  }
  ''';

  static final String constructMethod = '''
  dynamic construct(dynamic data,
      {dynamic Function(Map<String, dynamic>)? fromMap}) {
    if(data == null) {return null;}
    if (data is List) {
    return data.map((e) => construct(e, fromMap: fromMap)).toList();
    }
    if (fromMap != null) {
      return fromMap(data);
    }
    return data;
  }
  ''';

  static final String keyGenerator = '''
  class KeyGenerator {
    int key = 0;

    @override
    String toString() {
      return (key++).toRadixString(36);
    }
  }

  final keyGenerator = KeyGenerator();
  ''';

  static final String variableContainer = '''
  class VariableInfo {
    final String name;
    final dynamic value;
    final String type;

    VariableInfo(this.value, this.type, [String? name])
        : name = name ?? keyGenerator.toString();
  }

  class VariableContainer {
    final Set<VariableInfo> variables = {};

    void add(dynamic value, String type, [String? name]) {
      variables.add(VariableInfo(value, type, name));
    }

    void concat(VariableContainer other) {
      variables.addAll(other.variables);
    }

    Map<String, dynamic> get map {
      Map<String, dynamic> map = {};
      for (VariableInfo variable in variables) {
        map[variable.name] = variable.value;
      }
      return map;
    }
  }
  ''';

  ApiGenerator(String path) {
    final res = Tokenizer.tokenizeFile(path, QlLang.lang, QlLang.ignore);
    tokens = res.$1;
    remainingSegments = res.$2;
    if (remainingSegments.isNotEmpty) {
      print('Warning: ${remainingSegments.length} segments were ignored');
    }
    visitor = QlParser();
    visitor.visitTokens(tokens);
  }

  void export(String path) {
    File(path).writeAsStringSync(dartQlApi);
    Process.runSync('dart', ['format', path]);
  }

  String get dartQlApi {
    StringBuffer sb = StringBuffer();
    sb.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    for (NativeType nativeType
        in visitor.nativeTypes.where((e) => e.dartImport != null)) {
      sb.writeln('import \'${nativeType.dartImport}\';');
    }
    sb.writeln(stringBufferExtension);
    sb.writeln(constructMethod);
    sb.writeln(keyGenerator);
    sb.writeln(variableContainer);
    sb.write(visitor.objects.join(''));
    return sb.toString();
  }
}
