import 'package:tutlayt/l10n/abstract_language.dart';

class EngDicos extends AbstractLanguage {
  @override
  String get code => 'en_US';

  @override
  String get appNameValue => 'My Language';

  @override
  String get drawerHomeValue => 'Home';

  @override
  String get drawerAskValue => 'Ask a question';

  @override
  String get usernameValue => 'Username';

  @override
  String get usernameHintValue => 'Enter your username';

  @override
  String get emailValue => 'Email';

  @override
  String get emailHintValue => 'Enter your email';

  @override
  String get passwordValue => 'Password';

  @override
  String get passwordHintValue => 'Enter your password';

  @override
  String get phoneValue => 'Phone';

  @override
  String get signupValue => 'Signup';

  @override
  String get alreadyHaveAccountValue => 'You already have an account ?';

  @override
  String get dontHaveAccountValue => 'Do not have an account yet ?';

  @override
  String get loginValue => 'Login';

  @override
  String get forgotPasswordValue => 'Forgot password ?';

  @override
  String get resetPasswordValue => 'Reset it';

  @override
  String get acceptUserAgreementValue =>
      'By checking this box, you agree to our terms of service, privacy policy and cookie policy';

  @override
  String get incorrectPasswordFormatValue =>
      'Wrong format (example:mulu@tutlayt.iw)';

  @override
  String get weakPasswordErrorValue =>
      'Password too weak, try adding special caracters';

  @override
  String get shortPasswordErrorValue => 'Password too short';

  @override
  String get shortUsernameErrorValue => 'Username too short';

  @override
  String get longUsernameErrorValue => 'Username too long';

  @override
  String get incorrectUsernameFormatValue =>
      'Only alphanumeric and _ allowed (example: lalla_wezna)';

  @override
  String get loginErrorValue => 'Connection failed';

  @override
  String get signupErrorValue => 'Could not sign up';

  @override
  String get loadingValue => 'Loading...';

  @override
  String get userNotFoundValue => 'Sorry, we couldn\'t find that user!';
}
