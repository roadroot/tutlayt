import 'package:tokenizer/tokenizer.dart';

import 'ql_lang.dart';

class NonLiteralQlTokens implements NonLiteralModel {
  static const NonLiteralQlTokens type = NonLiteralQlTokens('type');
  static const NonLiteralQlTokens simpleField =
      NonLiteralQlTokens('simpleField');
  static const NonLiteralQlTokens parameterList =
      NonLiteralQlTokens('parameters');
  static const NonLiteralQlTokens allField = NonLiteralQlTokens('allField');
  static const NonLiteralQlTokens parameteredField =
      NonLiteralQlTokens('parameteredField');
  static const NonLiteralQlTokens object = NonLiteralQlTokens('object');
  static const NonLiteralQlTokens fieldList = NonLiteralQlTokens('fields');

  @override
  final String name;

  const NonLiteralQlTokens(this.name);

  NonLiteralModel get model => QlLang.nonLiteralTokens[name]!;

  @override
  bool get isEmpty => model.isEmpty;

  @override
  HasTokenizeStart get sequence => model.sequence;

  @override
  bool get isKeyword => model.isKeyword;

  @override
  bool get isSymbol => model.isSymbol;

  @override
  (List<Token>, List<Token>)? tokenizeStart(List<Token> inputTokens) {
    return model.tokenizeStart(inputTokens);
  }

  @override
  List<Token> tokenize(List<Token> inputTokens) {
    return model.tokenize(inputTokens);
  }

  @override
  bool operator ==(Object other) {
    return other is TokenBase && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
