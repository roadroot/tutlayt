import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/lexical/token_model/has_tokenize.dart';
import 'package:ql_gen/src/lexical/token_model/token_base.dart';

class TokenSequence extends HasTokenizeStart {
  final List<TokenBase> sequence;

  const TokenSequence(String name, this.sequence) : super(name: name);

  @override
  bool get isEmpty => sequence.isEmpty;

  @override
  String get name => '\'${sequence.map((t) => t.toString()).join('\' \'')}\'';

  @override
  (List<Token>, List<Token>)? tokenizeStart(List<Token> inputTokens) {
    final result = <Token>[];
    List<Token> remaining = inputTokens;
    for (final token in sequence) {
      if (token.isEmpty) {
        continue;
      }
      if (remaining.isEmpty) {
        return null;
      }
      if (remaining.first.model == token) {
        result.add(remaining.first);
        remaining = remaining.sublist(1);
        continue;
      }
      if (token is! HasTokenizeStart) {
        return null;
      }
      final tokenized = token.tokenizeStart(remaining);
      if (tokenized == null) {
        return null;
      }
      result.addAll(tokenized.$1);
      remaining = tokenized.$2;
    }
    return (result, remaining);
  }
}
