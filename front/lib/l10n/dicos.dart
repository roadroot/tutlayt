import 'package:get/get.dart';
import 'package:tutlayt/l10n/abstract_language.dart';
import 'package:tutlayt/l10n/eng_dicos.dart';
import 'package:tutlayt/l10n/fr_dicos.dart';

class Dicos extends Translations {
  final Iterable<AbstractLanguage> languages = [EngDicos(), FrDicos()];

  @override
  Map<String, Map<String, String>> get keys =>
      {for (var language in languages) language.code: language.values};
}
