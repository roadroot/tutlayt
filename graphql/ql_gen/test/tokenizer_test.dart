import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:ql_gen/src/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('basic case', () {
    final input = 'customer: Customer';
    final result = Tokenizer.tokenize(input, QlLang.lang);
    test('must match', () {
      expect(result, isNotNull);
    });
    test('tokens must match', () {
      expect(result.$1, [
        Token.from(QlLang.type, [
          Token(
            model: QlLang.identifier,
            value: 'customer',
            startLine: 0,
            endLine: 0,
            startColumn: 0,
            endColumn: 8,
          )
        ]),
        Token(
          model: QlLang.colon,
          value: ':',
          startLine: 0,
          endLine: 0,
          startColumn: 8,
          endColumn: 9,
        ),
        Token(
          model: QlLang.whitespace,
          value: ' ',
          startLine: 0,
          endLine: 0,
          startColumn: 9,
          endColumn: 10,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Customer',
          startLine: 0,
          endLine: 0,
          startColumn: 10,
          endColumn: 18,
        ),
      ]);
    });
    test('remaining must match', () {
      expect(result.$2, []);
    });
  });

  group('Mutation multiline', () {
    final input =
        'noise type Mutation {\n  createCustomers(input: [Customer!]!): String!\n  createSellers: [Seller]\n}°°°';
    final result = Tokenizer.tokenize(input, QlLang.lang, [QlLang.whitespace]);
    final expected = [
      Token.from(QlLang.type, [
        Token(
          model: QlLang.identifier,
          value: 'noise',
          startLine: 0,
          endLine: 0,
          startColumn: 0,
          endColumn: 5,
        ),
      ]),
      Token.from(
        QlLang.object,
        [
          Token(
            model: QlLang.typeKeyword,
            value: 'type',
            startLine: 0,
            endLine: 0,
            startColumn: 6,
            endColumn: 10,
          ),
          Token(
            model: QlLang.identifier,
            value: 'Mutation',
            startLine: 0,
            endLine: 0,
            startColumn: 11,
            endColumn: 19,
          ),
          Token(
            model: QlLang.openBrace,
            value: '{',
            startLine: 0,
            endLine: 0,
            startColumn: 20,
            endColumn: 21,
          ),
          Token.from(QlLang.allField, [
            Token.from(QlLang.parameteredField, [
              Token(
                model: QlLang.identifier,
                value: 'createCustomers',
                startLine: 1,
                endLine: 1,
                startColumn: 2,
                endColumn: 17,
              ),
              Token(
                model: QlLang.openParen,
                value: '(',
                startLine: 1,
                endLine: 1,
                startColumn: 17,
                endColumn: 18,
              ),
              Token.from(QlLang.parameterList, [
                Token.from(QlLang.simpleField, [
                  Token(
                    model: QlLang.identifier,
                    value: 'input',
                    startLine: 1,
                    endLine: 1,
                    startColumn: 18,
                    endColumn: 23,
                  ),
                  Token(
                    model: QlLang.colon,
                    value: ':',
                    startLine: 1,
                    endLine: 1,
                    startColumn: 23,
                    endColumn: 24,
                  ),
                  Token.from(
                    QlLang.type,
                    [
                      Token(
                        model: QlLang.openBracket,
                        value: '[',
                        startLine: 1,
                        endLine: 1,
                        startColumn: 25,
                        endColumn: 26,
                      ),
                      Token.from(
                        QlLang.type,
                        [
                          Token(
                            model: QlLang.identifier,
                            value: 'Customer',
                            startLine: 1,
                            endLine: 1,
                            startColumn: 26,
                            endColumn: 34,
                          ),
                          Token(
                            model: QlLang.exclamationToken,
                            value: '!',
                            startLine: 1,
                            endLine: 1,
                            startColumn: 34,
                            endColumn: 35,
                          ),
                        ],
                      ),
                      Token(
                        model: QlLang.closeBracket,
                        value: ']',
                        startLine: 1,
                        endLine: 1,
                        startColumn: 35,
                        endColumn: 36,
                      ),
                      Token(
                        model: QlLang.exclamationToken,
                        value: '!',
                        startLine: 1,
                        endLine: 1,
                        startColumn: 36,
                        endColumn: 37,
                      ),
                    ],
                  ),
                ])
              ]),
              Token(
                model: QlLang.closeParen,
                value: ')',
                startLine: 1,
                endLine: 1,
                startColumn: 37,
                endColumn: 38,
              ),
              Token(
                model: QlLang.colon,
                value: ':',
                startLine: 1,
                endLine: 1,
                startColumn: 38,
                endColumn: 39,
              ),
              Token.from(
                QlLang.type,
                [
                  Token(
                    model: QlLang.identifier,
                    value: 'String',
                    startLine: 1,
                    endLine: 1,
                    startColumn: 40,
                    endColumn: 46,
                  ),
                  Token(
                    model: QlLang.exclamationToken,
                    value: '!',
                    startLine: 1,
                    endLine: 1,
                    startColumn: 46,
                    endColumn: 47,
                  ),
                ],
              ),
            ]),
          ]),
          Token.from(QlLang.allField, [
            Token.from(QlLang.simpleField, [
              Token(
                model: QlLang.identifier,
                value: 'createSellers',
                startLine: 2,
                endLine: 2,
                startColumn: 2,
                endColumn: 15,
              ),
              Token(
                model: QlLang.colon,
                value: ':',
                startLine: 2,
                endLine: 2,
                startColumn: 15,
                endColumn: 16,
              ),
              Token.from(
                QlLang.type,
                [
                  Token(
                    model: QlLang.openBracket,
                    value: '[',
                    startLine: 2,
                    endLine: 2,
                    startColumn: 17,
                    endColumn: 18,
                  ),
                  Token.from(
                    QlLang.type,
                    [
                      Token(
                        model: QlLang.identifier,
                        value: 'Seller',
                        startLine: 2,
                        endLine: 2,
                        startColumn: 18,
                        endColumn: 24,
                      ),
                    ],
                  ),
                  Token(
                    model: QlLang.closeBracket,
                    value: ']',
                    startLine: 2,
                    endLine: 2,
                    startColumn: 24,
                    endColumn: 25,
                  ),
                ],
              ),
            ]),
          ]),
          Token(
            model: QlLang.closeBrace,
            value: '}',
            startLine: 3,
            endLine: 3,
            startColumn: 0,
            endColumn: 1,
          ),
        ],
      ),
    ];
    test('must match', () {
      expect(result, isNotNull);
    });
    test('tokens must match', () {
      expect(
        result.$1,
        expected,
      );
    });
    test('unknown tokens must match', () {
      expect(
        result.$2,
        [Input(input: '°°°', line: 3, column: 1, index: 97)],
      );
    });
  });
}
