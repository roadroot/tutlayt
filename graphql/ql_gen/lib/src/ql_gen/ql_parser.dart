import 'package:ql_gen/src/lexical/token.dart';
import 'package:ql_gen/src/ql_lang.dart';
import 'package:ql_gen/src/tokenizer.dart';

class QlParser {
  late List<Token> tokens;
  late List<Input> remainingSegments;

  QlParser(String path) {
    final res = Tokenizer.tokenizeFile(path, QlLang.lang, QlLang.ignore);
    tokens = res.$1;
    remainingSegments = res.$2;
  }
}
