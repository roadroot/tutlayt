import 'package:tokenizer/src/token.dart';
import 'package:tokenizer/src/token_model/token_base.dart';

abstract class HasTokenizeLiteral extends TokenBase {
  const HasTokenizeLiteral({required super.name});

  (List<Token>, List<Input>) tokenize(List<Input> input);
}

abstract class HasTokenizeNonLiteral extends TokenBase {
  const HasTokenizeNonLiteral({required super.name});

  List<Token>? tokenize(List<Token> inputTokens);
}

abstract class HasTokenizeStart extends TokenBase {
  const HasTokenizeStart({required super.name});

  (List<Token>, List<Token>)? tokenizeStart(List<Token> inputTokens);

  const HasTokenizeStart.empty({required super.name});
}
