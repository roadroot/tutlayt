import 'package:tutlayt/l10n/abstract_language.dart';

class FrDicos extends AbstractLanguage {
  @override
  String get code => 'fr_FR';

  @override
  String get appNameValue => 'Ma langue';

  @override
  String get drawerHomeValue => 'Acceuil';

  @override
  String get drawerAskValue => 'Poser une question';

  @override
  String get usernameValue => 'Nom d\'utilisateur';

  @override
  String get usernameHintValue => 'Entrer votre nom d\'utilisateur';

  @override
  String get emailValue => 'Adresse électronique';

  @override
  String get emailHintValue => 'Entrer votre adresse électronique';

  @override
  String get passwordValue => 'Mot de passe';

  @override
  String get passwordHintValue => 'Entrer votre mot de passse';

  @override
  String get phoneValue => 'Numéro de téléphone';

  @override
  String get signupValue => 'S\'enregistrer';

  @override
  String get alreadyHaveAccountValue => 'Vous avez déjà un compte ?';

  @override
  String get dontHaveAccountValue => 'Vous n\'avez pas encore de compte ?';

  @override
  String get loginValue => 'Se connecter';

  @override
  String get forgotPasswordValue => 'Mot de passe oublié ?';

  @override
  String get resetPasswordValue => 'Réinitialisez le';

  @override
  String get acceptUserAgreementValue =>
      'En cochant cette case, vous acceptez nos conditions d\'utilisation, notre politique de confidentialité et notre politique en matière de cookies';

  @override
  String get incorrectPasswordFormatValue =>
      'Format incorrect (exemple: hmimi@tutlayt.iw)';

  @override
  String get weakPasswordErrorValue =>
      'Faible mot de passe, essayez d\'ajouter des caractères spéciaux';

  @override
  String get shortPasswordErrorValue => 'Mot de passe trop court';

  @override
  String get shortUsernameErrorValue => 'Nom d\'utilisateur trop court';

  @override
  String get longUsernameErrorValue => 'Nom d\'utilisateur trop long';

  @override
  String get incorrectUsernameFormatValue =>
      'Seuls les caractères alphanumériques et _ sont autorisés (exemple: massa_tiziri)';

  @override
  String get loginErrorValue => 'Connexion échouée';

  @override
  String get signupErrorValue => 'Inscription échouée';

  @override
  String get loadingValue => 'Chargement...';

  @override
  String get userNotFoundValue =>
      'Désolé, nous n\'avons pas pu trouver cet utilisateur !';
}
