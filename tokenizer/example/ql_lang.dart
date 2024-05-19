import 'package:tokenizer/tokenizer.dart';

import 'tokens.dart';

class QlLang {
  static const LiteralModel colon = LiteralModel(
    pattern: ':',
    name: ':',
    isSymbol: true,
  );
  static const LiteralModel openBrace = LiteralModel(
    pattern: '{',
    name: '{',
    isSymbol: true,
  );
  static const LiteralModel closeBrace = LiteralModel(
    pattern: '}',
    name: '}',
    isSymbol: true,
  );
  static const LiteralModel openBracket = LiteralModel(
    pattern: r'\[',
    name: '[',
    isSymbol: true,
  );
  static const LiteralModel closeBracket = LiteralModel(
    pattern: r'\]',
    name: ']',
    isSymbol: true,
  );
  static const LiteralModel openParen = LiteralModel(
    name: '(',
    pattern: r'\(',
    isSymbol: true,
  );
  static const LiteralModel closeParen = LiteralModel(
    name: ')',
    pattern: r'\)',
    isSymbol: true,
  );
  static const LiteralModel comma = LiteralModel(
    pattern: ',',
    name: ',',
    isSymbol: true,
  );
  static const LiteralModel exclamationToken = LiteralModel(
    name: '!',
    pattern: r'\!',
    isSymbol: true,
  );
  static const LiteralModel identifier = LiteralModel(
    name: 'identifier',
    pattern: r'[a-zA-Z_]\w*',
  );
  static const LiteralModel comment = LiteralModel(
    name: 'comment',
    pattern: r'#.*',
  );
  static const LiteralModel whitespace = LiteralModel(
    name: 'whitespace',
    pattern: r'\s+',
  );
  static const LiteralModel documenation = LiteralModel(
    name: 'doc',
    pattern: r'"""[^"]*"""',
  );
  static const LiteralModel nothing = LiteralModel(
    name: 'nothing',
    pattern: '',
  );
  static const NonLiteralModel type = NonLiteralModel(
    name: 'type',
    sequence: TokenAlternatives('typeAlternatives', [
      TokenSequence('typeArray', [
        QlLang.openBracket,
        NonLiteralQlTokens.type,
        QlLang.closeBracket,
        TokenAlternatives(
            'exclamationOrNothing', [QlLang.exclamationToken, QlLang.nothing]),
      ]),
      TokenSequence('typeSimple', [
        QlLang.identifier,
        TokenAlternatives(
            'exclamationOrNothing', [QlLang.exclamationToken, QlLang.nothing]),
      ])
    ]),
  );
  static const NonLiteralModel simpleField = NonLiteralModel(
    name: 'simpleField',
    sequence: TokenSequence('simpleFieldSequence', [
      QlLang.identifier,
      QlLang.colon,
      QlLang.type,
    ]),
  );
  static const NonLiteralModel parameterList = NonLiteralModel(
    name: 'parameters',
    sequence: TokenSequence('parametersSequence', [
      TokenAlternatives('parameterOrMore', [
        TokenSequence('parametersRecursion', [
          NonLiteralQlTokens.simpleField,
          QlLang.comma,
          NonLiteralQlTokens.parameterList,
        ]),
        NonLiteralQlTokens.simpleField,
      ]),
    ]),
  );
  static const NonLiteralModel parameteredField = NonLiteralModel(
    name: 'parameteredField',
    sequence: TokenSequence('parameteredFieldSequence', [
      QlLang.identifier,
      QlLang.openParen,
      NonLiteralQlTokens.parameterList,
      QlLang.closeParen,
      QlLang.colon,
      NonLiteralQlTokens.type,
    ]),
  );
  static const NonLiteralModel allField = NonLiteralModel(
    name: 'allField',
    sequence: TokenAlternatives('simpleOrParameteredField', [
      NonLiteralQlTokens.simpleField,
      NonLiteralQlTokens.parameteredField,
    ]),
  );
  static const NonLiteralModel fieldList = NonLiteralModel(
    name: 'fields',
    sequence: TokenAlternatives('fieldListAlternatives', [
      TokenSequence('fieldListRecursion', [
        NonLiteralQlTokens.allField,
        NonLiteralQlTokens.fieldList,
      ]),
      NonLiteralQlTokens.allField,
    ]),
  );
  static const NonLiteralModel object = NonLiteralModel(
    name: 'object',
    sequence: TokenSequence('objectSequence', [
      QlLang.identifier,
      QlLang.identifier,
      QlLang.openBrace,
      TokenAlternatives('fieldsOrNothing', [
        NonLiteralQlTokens.fieldList,
        QlLang.nothing,
      ]),
      QlLang.closeBrace,
    ]),
  );

  static final List<TokenModel> lang = [
    comment,
    documenation,
    identifier,
    colon,
    openBrace,
    closeBrace,
    openBracket,
    closeBracket,
    openParen,
    closeParen,
    whitespace,
    comma,
    exclamationToken,
    object,
    parameterList,
    allField,
    parameteredField,
    simpleField,
    type,
  ];

  static final List<TokenModel> ignore = [whitespace, comment, documenation];

  static final Map<String, NonLiteralModel> nonLiteralTokens = {
    NonLiteralQlTokens.type.name: QlLang.type,
    NonLiteralQlTokens.simpleField.name: QlLang.simpleField,
    NonLiteralQlTokens.parameterList.name: QlLang.parameterList,
    NonLiteralQlTokens.allField.name: QlLang.allField,
    NonLiteralQlTokens.parameteredField.name: QlLang.parameteredField,
    NonLiteralQlTokens.object.name: QlLang.object,
    NonLiteralQlTokens.fieldList.name: QlLang.fieldList,
  };
}
