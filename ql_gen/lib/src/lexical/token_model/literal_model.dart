import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/lexical/token_model/has_tokenize.dart';
import 'package:ql_gen/src/lexical/token_model/token_model.dart';

class LiteralModel extends TokenModel implements HasTokenizeLiteral {
  final String pattern;

  const LiteralModel({
    required this.pattern,
    required super.name,
    bool isKeyword = false,
    bool isSymbol = false,
  });
  @override
  bool get isEmpty => pattern.isEmpty;

  @override
  (List<Token>, List<Input>) tokenize(List<Input> input) {
    if (isEmpty) {
      return ([], input);
    }
    List<Input> resultedInputs = [];
    List<Token> resultedTokens = [];
    for (final segment in input) {
      final matches = RegExp(pattern).allMatches(segment.input).toList();
      List<Input> remainingSegments = [segment];
      if (matches.isNotEmpty) {
        for (final match in matches) {
          final startLines =
              segment.input.substring(0, match.start).split('\n');
          final endLines = segment.input.substring(0, match.end).split('\n');
          final lastSegment = remainingSegments.removeLast();
          final segementOffset = lastSegment.index - segment.index;
          remainingSegments.add(Input(
            input: lastSegment.input.substring(0, match.start - segementOffset),
            line: lastSegment.line,
            column: lastSegment.column,
            index: lastSegment.index,
          ));
          resultedTokens.add(Token(
            model: this,
            value: match.group(0)!,
            startLine: segment.line + startLines.length - 1,
            startColumn: startLines.length == 1
                ? segment.column + startLines.last.length
                : startLines.last.length,
            endLine: segment.line + endLines.length - 1,
            endColumn: endLines.length == 1
                ? segment.column + endLines.last.length
                : endLines.last.length,
          ));
          remainingSegments.add(Input(
            input: lastSegment.input.substring(match.end - segementOffset),
            line: segment.line + endLines.length - 1,
            column: endLines.length == 1
                ? segment.column + endLines.last.length
                : endLines.last.length,
            index: segment.index + match.end,
          ));
        }
      }
      resultedInputs.addAll(
          remainingSegments.where((element) => element.input.isNotEmpty));
    }
    resultedTokens.sort();
    return (resultedTokens, resultedInputs);
  }
}
