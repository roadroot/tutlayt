import 'dart:io';

import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/ql_gen/ql_visitor.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:ql_gen/src/tokenizer.dart';

class QlParser {
  late List<Token> tokens;
  late List<Input> remainingSegments;
  late QlVisitor visitor;

  QlParser(String path) {
    final res = Tokenizer.tokenizeFile(path, QlLang.lang, QlLang.ignore);
    tokens = res.$1;
    remainingSegments = res.$2;
    visitor = QlVisitor();
    visitor.visitTokens(tokens);
  }

  void export(String path) {
    File(path).writeAsStringSync(dartQlApi);
    Process.runSync('dart', ['format', path]);
  }

  String get dartQlApi {
    StringBuffer sb = StringBuffer();
    sb.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    if (visitor.hasUploadType) {
      sb.writeln('import \'dart:io\';');
    }
    sb.write(visitor.objects.join(''));
    return sb.toString();
  }
}
