import 'package:ql_gen/src/ql_lang.dart';
import 'package:test/test.dart';
import 'package:tokenizer/tokenizer.dart';

void main() {
  group('tokenizeStart', () {
    group('basic case', () {
      final sequence = TokenSequence('sequence', [
        QlLang.identifier,
        QlLang.identifier,
        QlLang.colon,
        QlLang.identifier,
      ]);
      final match = [
        Token(
          model: QlLang.identifier,
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
          model: QlLang.colon,
          value: ':',
          startLine: 1,
          endLine: 1,
          startColumn: 12,
          endColumn: 13,
        ),
        Token(
          model: QlLang.identifier,
          value: 'type',
          startLine: 1,
          endLine: 1,
          startColumn: 13,
          endColumn: 17,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 17,
          endColumn: 24,
        ),
      ];
      final noMatch = [
        Token(
          model: QlLang.identifier,
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
          model: QlLang.colon,
          value: ':',
          startLine: 1,
          endLine: 1,
          startColumn: 12,
          endColumn: 13,
        ),
        Token(
          model: QlLang.openParen,
          value: '(',
          startLine: 1,
          endLine: 1,
          startColumn: 13,
          endColumn: 14,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 14,
          endColumn: 21,
        ),
      ];
      test('match', () {
        final result = sequence.tokenizeStart(match);
        expect(result, isNotNull);
        expect(result!.$1, match.sublist(0, 4));
        expect(result.$2, match.sublist(4));
      });

      test('no match', () {
        final result = sequence.tokenizeStart(noMatch);
        expect(result, isNull);
      });
    });

    group('with options', () {
      final sequence = TokenSequence('sequence', [
        QlLang.identifier,
        QlLang.identifier,
        QlLang.colon,
        TokenAlternatives(
            'alternative', [QlLang.identifier, QlLang.identifier]),
      ]);
      final match = [
        Token(
          model: QlLang.identifier,
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
          model: QlLang.colon,
          value: ':',
          startLine: 1,
          endLine: 1,
          startColumn: 12,
          endColumn: 13,
        ),
        Token(
          model: QlLang.identifier,
          value: 'type',
          startLine: 1,
          endLine: 1,
          startColumn: 13,
          endColumn: 17,
        ),
        Token(
          model: QlLang.identifier,
          value: 'Article',
          startLine: 1,
          endLine: 1,
          startColumn: 17,
          endColumn: 24,
        ),
      ];
      final otherMatch = [
        Token(
          model: QlLang.identifier,
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
          model: QlLang.colon,
          value: ':',
          startLine: 1,
          endLine: 1,
          startColumn: 12,
          endColumn: 13,
        ),
        Token(
          model: QlLang.identifier,
          value: 'eror',
          startLine: 1,
          endLine: 1,
          startColumn: 13,
          endColumn: 17,
        ),
      ];

      test('match', () {
        final result = sequence.tokenizeStart(match);
        expect(result, isNotNull);
        expect(result!.$1, match.sublist(0, 4));
        expect(result.$2, match.sublist(4));
      });

      test('other match', () {
        final result = sequence.tokenizeStart(otherMatch);
        expect(result, isNotNull);
        expect(result!.$1, otherMatch.sublist(0, 4));
        expect(result.$2, isEmpty);
      });
    });
  });
}
