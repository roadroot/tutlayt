import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/lexical/token_alternative.dart';
import 'package:ql_gen/src/lexical/token_sequence.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:test/test.dart';

void main() {
  group('tokenizeStart', () {
    group('basic case', () {
      final alternative = TokenAlternatives(
          'alternative', [QlLang.typeKeyword, QlLang.identifier]);
      final matchFirstOption = [
        Token(
          model: QlLang.typeKeyword,
          value: 'type',
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 5,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 5,
          endColumn: 12,
        ),
      ];
      final matchSecondOption = [
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 2,
          endLine: 2,
          startColumn: 1,
          endColumn: 8,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 2,
          endLine: 2,
          startColumn: 8,
          endColumn: 15,
        ),
      ];
      final noMatch = [
        Token(
          model: QlLang.openBrace,
          value: '{',
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 2,
        ),
        Token(
          model: QlLang.closeBrace,
          value: '}',
          startLine: 1,
          endLine: 1,
          startColumn: 2,
          endColumn: 3,
        ),
      ];
      group('first option', () {
        final result = alternative.tokenizeStart(matchFirstOption);
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(result?.$1.first, matchFirstOption.first);
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchFirstOption.sublist(1));
        });
      });

      group('second option', () {
        final result = alternative.tokenizeStart(matchSecondOption);
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(result?.$1.first, matchSecondOption.first);
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchSecondOption.sublist(1));
        });
      });

      group('no option', () {
        final result = alternative.tokenizeStart(noMatch);
        test('should return null', () {
          expect(result, isNull);
        });
      });
    });

    group('case having a sequence', () {
      final alternative = TokenAlternatives('alternative', [
        TokenSequence('sequence', [QlLang.typeKeyword, QlLang.identifier]),
        QlLang.identifier,
      ]);
      final matchFirstOption = [
        Token(
          model: QlLang.typeKeyword,
          value: 'type',
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 5,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 5,
          endColumn: 12,
        ),
        Token(
          model: QlLang.openBrace,
          value: '{',
          startLine: 1,
          endLine: 1,
          startColumn: 12,
          endColumn: 13,
        ),
      ];
      final matchSecondOption = [
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 2,
          endLine: 2,
          startColumn: 1,
          endColumn: 8,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 2,
          endLine: 2,
          startColumn: 8,
          endColumn: 15,
        ),
      ];

      group('first option', () {
        final result = alternative.tokenizeStart(matchFirstOption);
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(result?.$1, matchFirstOption.sublist(0, 2));
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchFirstOption.sublist(2));
        });
      });

      group('second option', () {
        final result = alternative.tokenizeStart(matchSecondOption);
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(result?.$1, matchSecondOption.sublist(0, 1));
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchSecondOption.sublist(1));
        });
      });
    });

    group('case having a sequence and a token', () {
      final alternative = TokenAlternatives('alternative', [
        TokenSequence(
            'sequence', [QlLang.simpleField, QlLang.parameteredField]),
        QlLang.parameteredField,
      ]);
      final simpleField = [
        Token(
          model: QlLang.identifier,
          value: 'article',
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 8,
        ),
        Token(
          model: QlLang.colon,
          value: ':',
          startLine: 1,
          endLine: 1,
          startColumn: 8,
          endColumn: 9,
        ),
        Token(
          model: QlLang.type,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 9,
          endColumn: 16,
        ),
      ];
      final parameteredField = [
        Token(
          model: QlLang.identifier,
          value: 'article',
          startLine: 1,
          endLine: 1,
          startColumn: 17,
          endColumn: 24,
        ),
        Token(
          model: QlLang.openParen,
          value: '(',
          startLine: 1,
          endLine: 1,
          startColumn: 24,
          endColumn: 25,
        ),
        Token(
          model: QlLang.parameterList,
          children: [
            Token(
              model: QlLang.identifier,
              value: 'title',
              startLine: 1,
              endLine: 1,
              startColumn: 25,
              endColumn: 30,
            ),
            Token(
              model: QlLang.colon,
              value: ':',
              startLine: 1,
              endLine: 1,
              startColumn: 30,
              endColumn: 31,
            ),
            Token(
              model: QlLang.type,
              value: 'String',
              startLine: 1,
              endLine: 1,
              startColumn: 31,
              endColumn: 37,
            ),
          ],
          value: 'title:String',
          startLine: 1,
          endLine: 1,
          startColumn: 25,
          endColumn: 37,
        ),
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
        Token(
          model: QlLang.type,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 39,
          endColumn: 46,
        ),
      ];
      final matchFirstOption = [
        ...simpleField,
        ...parameteredField,
        Token(
          model: QlLang.identifier,
          value: 'article',
          startLine: 1,
          endLine: 1,
          startColumn: 47,
          endColumn: 54,
        ),
      ];
      final matchSecondOption = [
        ...parameteredField,
        Token(
          model: QlLang.identifier,
          value: 'article',
          startLine: 1,
          endLine: 1,
          startColumn: 55,
          endColumn: 62,
        ),
      ];
      final expected = [
        Token(
          model: QlLang.simpleField,
          children: simpleField,
          value: 'article:Article',
          startLine: 1,
          endLine: 1,
          startColumn: 1,
          endColumn: 16,
        ),
        Token(
          model: QlLang.parameteredField,
          children: parameteredField,
          value: 'article(title:String):Article',
          startLine: 1,
          endLine: 1,
          startColumn: 17,
          endColumn: 46,
        ),
      ];
      group('first option', () {
        final result = alternative.tokenizeStart(
          matchFirstOption,
        );
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(result?.$1, expected);
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchFirstOption.sublist(9));
        });
      });

      group('second option', () {
        final result = alternative.tokenizeStart(
          matchSecondOption,
        );
        test('should return a list of tokens', () {
          expect(result, isNotNull);
        });
        test('should return the first token', () {
          expect(
            result?.$1,
            [
              Token(
                children: matchSecondOption.sublist(0, 6),
                model: QlLang.parameteredField,
                value: 'article(title:String):Article',
                startLine: 1,
                endLine: 1,
                startColumn: 17,
                endColumn: 46,
              )
            ],
          );
        });
        test('should return the rest of the tokens', () {
          expect(result?.$2, matchSecondOption.sublist(6));
        });
      });
    });
  });
}
