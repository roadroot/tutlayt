import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:test/test.dart';

void main() {
  group('tokenize', () {
    group('typeKeyword', () {
      group('basic case', () {
        final input = 'type type';
        final result = QlLang.typeKeyword.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.typeKeyword,
              value: 'type',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 4,
            ),
            Token(
              model: QlLang.typeKeyword,
              value: 'type',
              startLine: 0,
              endLine: 0,
              startColumn: 5,
              endColumn: 9,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(result.$2, [Input(input: ' ', line: 0, column: 4, index: 4)]);
        });
      });

      group('in diffrent lines', () {
        final input = 'type\n type type';
        final result = QlLang.typeKeyword.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.typeKeyword,
              value: 'type',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 4,
            ),
            Token(
              model: QlLang.typeKeyword,
              value: 'type',
              startLine: 1,
              endLine: 1,
              startColumn: 1,
              endColumn: 5,
            ),
            Token(
              model: QlLang.typeKeyword,
              value: 'type',
              startLine: 1,
              endLine: 1,
              startColumn: 6,
              endColumn: 10,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(result.$2, [
            Input(input: '\n ', line: 0, column: 4, index: 4),
            Input(input: ' ', line: 1, column: 5, index: 10),
          ]);
        });
      });
    });

    group('identifier', () {
      group('basic case', () {
        final input = 'identifier identifier';
        final result = QlLang.identifier.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.identifier,
              value: 'identifier',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 10,
            ),
            Token(
              model: QlLang.identifier,
              value: 'identifier',
              startLine: 0,
              endLine: 0,
              startColumn: 11,
              endColumn: 21,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(
              result.$2, [Input(input: ' ', line: 0, column: 10, index: 10)]);
        });
      });

      group('in diffrent lines', () {
        final input = 'identifier\n identifier identifier';
        final result = QlLang.identifier.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.identifier,
              value: 'identifier',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 10,
            ),
            Token(
              model: QlLang.identifier,
              value: 'identifier',
              startLine: 1,
              endLine: 1,
              startColumn: 1,
              endColumn: 11,
            ),
            Token(
              model: QlLang.identifier,
              value: 'identifier',
              startLine: 1,
              endLine: 1,
              startColumn: 12,
              endColumn: 22,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(result.$2, [
            Input(input: '\n ', line: 0, column: 10, index: 10),
            Input(input: ' ', line: 1, column: 11, index: 22),
          ]);
        });
      });
    });
  });
}
