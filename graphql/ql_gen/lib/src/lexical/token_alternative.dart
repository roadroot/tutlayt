import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/lexical/token_model/has_tokenize.dart';
import 'package:ql_gen/src/lexical/token_model/token_base.dart';

class TokenAlternatives extends HasTokenizeStart {
  final List<TokenBase> alternatives;

  const TokenAlternatives(String name, this.alternatives) : super(name: name);

  @override
  bool get isEmpty => alternatives.isEmpty;

  @override
  String get name => '(${alternatives.map((t) => t.toString()).join(' | ')})';

  @override
  (List<Token>, List<Token>)? tokenizeStart(List<Token> inputTokens) {
    for (final alternative in alternatives) {
      if (alternative.isEmpty) {
        return ([], inputTokens);
      }
      if (inputTokens.isNotEmpty && inputTokens.first.model == alternative) {
        return ([inputTokens.first], inputTokens.sublist(1));
      }
      if (alternative is! HasTokenizeStart) {
        continue;
      }
      final tokenized = alternative.tokenizeStart(inputTokens);
      if (tokenized != null) {
        return tokenized;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) {
    return other is TokenAlternatives && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
