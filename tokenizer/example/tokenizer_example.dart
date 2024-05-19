import 'package:tokenizer/tokenizer.dart';

import 'ql_lang.dart';

void main() {
  print(Tokenizer.tokenizeFile('example/input.gql', QlLang.lang, QlLang.ignore));
}
