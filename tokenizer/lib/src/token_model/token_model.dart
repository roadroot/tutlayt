import 'package:tokenizer/src/token_model/token_base.dart';

abstract class TokenModel extends TokenBase {
  final bool isKeyword;
  final bool isSymbol;

  const TokenModel({
    this.isKeyword = false,
    this.isSymbol = false,
    required super.name,
  });
}
