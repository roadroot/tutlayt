import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:test/test.dart';

import '../../matchers.dart';

void main() {
  group('tokenizeStart', () {
    group('object', () {
      test('must not match', () {
        const input = [
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 1,
            endColumn: 5,
            model: QlLang.identifier,
            value: 'type',
          )
        ];
        expect(QlLang.type.tokenizeStart(input), isNull);
      });
      group('must match', () {
        const input = [
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 1,
            endColumn: 5,
            model: QlLang.identifier,
            value: 'type',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 6,
            endColumn: 10,
            model: QlLang.identifier,
            value: 'Hello',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 11,
            endColumn: 12,
            model: QlLang.openBrace,
            value: '{',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 12,
            endColumn: 13,
            model: QlLang.closeBrace,
            value: '}',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 13,
            endColumn: 14,
            model: QlLang.exclamationToken,
            value: '!',
          ),
        ];
        final result = QlLang.object.tokenizeStart(input);
        test('must be not null', () {
          expect(result, isNotNull);
        });
        test('must have correct created', () {
          expect(
              result?.$1,
              iterableEquals([
                Token(
                  model: QlLang.object,
                  value: 'typeHello{}',
                  children: input.sublist(0, 4),
                  startLine: 1,
                  endLine: 1,
                  startColumn: 1,
                  endColumn: 13,
                )
              ]));
        });
        test('must have correct remaining', () {
          expect(result?.$2, iterableEquals(input.sublist(4)));
        });
      });
    });

    group('parameterList', () {
      test('must not match', () {
        const input = [
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 1,
            endColumn: 5,
            model: QlLang.identifier,
            value: 'type',
          )
        ];
        expect(QlLang.parameterList.tokenizeStart(input), isNull);
      });
      group('one parameter', () {
        final inputWithoutRequired = [
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 3,
            endColumn: 7,
            model: QlLang.identifier,
            value: 'user',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 7,
            endColumn: 8,
            model: QlLang.colon,
            value: ':',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 8,
            endColumn: 12,
            model: QlLang.identifier,
            value: 'User',
          ),
          Token(
            startLine: 1,
            endLine: 1,
            startColumn: 12,
            endColumn: 13,
            model: QlLang.closeParen,
            value: ')',
          ),
        ];
        final inputWithRequired = inputWithoutRequired.sublist(0, 3)
          ..add(Token(
            startLine: 1,
            endLine: 1,
            startColumn: 12,
            endColumn: 13,
            model: QlLang.exclamationToken,
            value: '!',
          ))
          ..add(Token(
            startLine: 1,
            endLine: 1,
            startColumn: 13,
            endColumn: 14,
            model: QlLang.closeParen,
            value: ')',
          ));

        group('without required', () {
          final result =
              QlLang.parameterList.tokenizeStart(inputWithoutRequired);
          test('must be not null', () {
            expect(result, isNotNull);
          });
          test('must have correct created', () {
            expect(
              result?.$1,
              iterableEquals([
                Token(
                  model: QlLang.parameterList,
                  value: 'user:User',
                  children: [
                    Token(
                      model: QlLang.simpleField,
                      value: 'user:User',
                      children: inputWithoutRequired.sublist(0, 2) +
                          [
                            Token(
                              model: QlLang.type,
                              value: 'User',
                              children: inputWithRequired.sublist(2, 3),
                              startLine: 1,
                              endLine: 1,
                              startColumn: 8,
                              endColumn: 12,
                            )
                          ],
                      startLine: 1,
                      endLine: 1,
                      startColumn: 3,
                      endColumn: 12,
                    )
                  ],
                  startLine: 1,
                  endLine: 1,
                  startColumn: 3,
                  endColumn: 12,
                )
              ]),
            );
          });
          test('must have correct remaining', () {
            expect(result?.$2, inputWithoutRequired.sublist(3));
          });
        });

        group('with required', () {
          final result = QlLang.parameterList.tokenizeStart(inputWithRequired);
          test('must have correct created', () {
            expect(
              result?.$1,
              iterableEquals([
                Token(
                  model: QlLang.parameterList,
                  value: 'user:User!',
                  children: [
                    Token(
                      model: QlLang.simpleField,
                      value: 'user:User!',
                      children: inputWithRequired.sublist(0, 2) +
                          [
                            Token(
                              model: QlLang.type,
                              value: 'User!',
                              children: inputWithRequired.sublist(2, 4),
                              startLine: 1,
                              endLine: 1,
                              startColumn: 8,
                              endColumn: 13,
                            )
                          ],
                      startLine: 1,
                      endLine: 1,
                      startColumn: 3,
                      endColumn: 13,
                    )
                  ],
                  startLine: 1,
                  endLine: 1,
                  startColumn: 3,
                  endColumn: 13,
                )
              ]),
            );
          });
          test('must have correct remaining', () {
            expect(result?.$2, inputWithRequired.sublist(4));
          });
        });
      });
    });
  });

  group('tokenize', () {
    group('type', () {
      final input = [
        Token(
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 5,
          model: QlLang.identifier,
          value: 'type',
        ),
        Token(
          startLine: 1,
          endLine: 1,
          startColumn: 6,
          endColumn: 10,
          model: QlLang.identifier,
          value: 'User',
        ),
        Token(
          startLine: 1,
          endLine: 1,
          startColumn: 10,
          endColumn: 11,
          model: QlLang.openBrace,
          value: '{',
        ),
        Token(
          startLine: 1,
          endLine: 1,
          startColumn: 11,
          endColumn: 18,
          model: QlLang.identifier,
          value: 'Desktop',
        ),
        Token(
          startLine: 1,
          endLine: 1,
          startColumn: 18,
          endColumn: 19,
          model: QlLang.exclamationToken,
          value: '!',
        ),
      ];
      final result = QlLang.type.tokenize(input);

      test('must be not null', () {
        expect(result, isNotNull);
      });
      test('must have correct created', () {
        expect(
          result,
          iterableEquals([
            Token.from(QlLang.type, input.sublist(0, 1)),
            Token.from(QlLang.type, input.sublist(1, 2)),
            input[2],
            Token.from(QlLang.type, input.sublist(3, 5)),
          ]),
        );
      });
    });
  });
}
