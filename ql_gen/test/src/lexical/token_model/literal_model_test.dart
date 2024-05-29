import 'package:ql_gen/src/ql_lang.dart';
import 'package:test/test.dart';
import 'package:tokenizer/tokenizer.dart';

void main() {
  group('tokenize', () {
    group('openBracket', () {
      group('basic case', () {
        final input = '[ [';
        final result = QlLang.openBracket.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.openBracket,
              value: '[',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 1,
            ),
            Token(
              model: QlLang.openBracket,
              value: '[',
              startLine: 0,
              endLine: 0,
              startColumn: 2,
              endColumn: 3,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(result.$2, [Input(input: ' ', line: 0, column: 1, index: 1)]);
        });
      });

      group('in diffrent lines', () {
        final input = '[\n [ [';
        final result = QlLang.openBracket.tokenize([Input(input: input)]);
        test('must match', () {
          expect(result, isNotNull);
        });
        test('must match the correct value', () {
          expect(result.$1, [
            Token(
              model: QlLang.openBracket,
              value: '[',
              startLine: 0,
              endLine: 0,
              startColumn: 0,
              endColumn: 1,
            ),
            Token(
              model: QlLang.openBracket,
              value: '[',
              startLine: 1,
              endLine: 1,
              startColumn: 1,
              endColumn: 2,
            ),
            Token(
              model: QlLang.openBracket,
              value: '[',
              startLine: 1,
              endLine: 1,
              startColumn: 3,
              endColumn: 4,
            ),
          ]);
        });
        test('must match the correct remaining input', () {
          expect(result.$2, [
            Input(input: '\n ', line: 0, column: 1, index: 1),
            Input(input: ' ', line: 1, column: 2, index: 4),
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
