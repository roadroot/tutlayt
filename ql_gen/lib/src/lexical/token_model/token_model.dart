import 'package:ql_gen/src/lexical/token_model/token_base.dart';

abstract class TokenModel extends TokenBase {
  final bool isKeyword;
  final bool isSymbol;

  const TokenModel({
    this.isKeyword = false,
    this.isSymbol = false,
    required super.name,
  });
}
