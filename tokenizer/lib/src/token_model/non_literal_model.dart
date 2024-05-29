import 'package:tokenizer/src/token.dart';
import 'package:tokenizer/src/token_model/has_tokenize.dart';
import 'package:tokenizer/src/token_model/token_model.dart';

class NonLiteralModel extends TokenModel
    implements HasTokenizeNonLiteral, HasTokenizeStart {
  final HasTokenizeStart sequence;

  const NonLiteralModel({
    required this.sequence,
    required super.name,
  });

  @override
  bool get isEmpty => sequence.isEmpty;

  @override
  List<Token> tokenize(List<Token> inputTokens) {
    List<Token> tokenized = [];
    List<Token> remaining = inputTokens.toList();
    while (remaining.isNotEmpty) {
      final result = tokenizeStart(remaining);
      if (result != null) {
        tokenized += result.$1;
        remaining = result.$2;
      } else {
        tokenized.add(remaining.removeAt(0));
      }
    }
    return tokenized;
  }

  @override
  (List<Token> created, List<Token> remaining)? tokenizeStart(
      List<Token> inputTokens) {
    final result = sequence.tokenizeStart(inputTokens);
    if (result == null) {
      return null;
    }
    if (result.$1.isEmpty) {
      throw Exception(
          'Empty token created, make sure the model \'$this\' does not produce empty tokens');
    }
    return (
      [
        Token(
          children: result.$1,
          model: this,
          value: result.$1.map((e) => e.value).join(''),
          startLine: result.$1.first.startLine,
          startColumn: result.$1.first.startColumn,
          endLine: result.$1.last.endLine,
          endColumn: result.$1.last.endColumn,
        )
      ],
      result.$2,
    );
  }
}
