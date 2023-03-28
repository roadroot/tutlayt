import 'dart:io';

import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/lexical/token_model/literal_model.dart';
import 'package:ql_gen/src/lexical/token_model/non_literal_model.dart';
import 'package:ql_gen/src/lexical/token_model/token_model.dart';

abstract class Tokenizer {
  static (List<Token>, List<Input>) tokenize(
      String input, List<TokenModel> lang,
      [List<TokenModel>? ignore]) {
    List<Token> tokens = [];
    List<Input> remainingSegments = [Input(input: input)];
    for (final element in lang.whereType<LiteralModel>()) {
      final res = element.tokenize(remainingSegments);
      tokens += res.$1;
      remainingSegments = res.$2;
    }
    tokens.removeWhere((element) => element.model.isEmpty);
    if (ignore != null) {
      tokens.removeWhere((element) => ignore.contains(element.model));
    }
    tokens.sort();
    for (final element in lang.whereType<NonLiteralModel>()) {
      tokens = element.tokenize(tokens);
    }
    return (tokens, remainingSegments);
  }

  static (List<Token>, List<Input>) tokenizeFile(
      String path, List<TokenModel> lang,
      [List<TokenModel>? ignore]) {
    return tokenize(File(path).readAsStringSync(), lang, ignore);
  }
}
