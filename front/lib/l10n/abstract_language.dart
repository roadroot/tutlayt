const String appName = 'appName';
const String drawerHome = 'drawerHome';
const String drawerAsk = 'drawerAsk';
const String username = 'username';
const String usernameHint = 'usernameHint';
const String email = 'email';
const String emailHint = 'emailHint';
const String password = 'password';
const String passwordHint = 'passwordHint';
const String phone = 'phone';
const String signup = 'signup';
const String alreadyHaveAccount = 'alreadyHaveAccount';
const String dontHaveAccount = 'dontHaveAccount';
const String login = 'login';
const String forgotPassword = 'forgotPassword';
const String resetPassword = 'resetPassword';
const String acceptUserAgreement = 'acceptUserAgreement';
const String incorrectPasswordFormat = 'incorrectPasswordFormat';
const String weakPasswordError = 'weakPasswordError';
const String shortPasswordError = 'shortPasswordError';
const String shortUsernameError = 'shortUsernameError';
const String longUsernameError = 'longUsernameError';
const String incorrectUsernameFormat = 'incorrectUsernameFormat';
const String loginError = 'loginError';
const String signupError = 'signupError';
const String loading = 'loading';
const String userNotFound = 'userNotFound';

abstract class AbstractLanguage {
  String get code;

  String get appNameValue;
  String get drawerHomeValue;
  String get drawerAskValue;
  String get usernameValue;
  String get usernameHintValue;
  String get emailValue;
  String get emailHintValue;
  String get passwordValue;
  String get passwordHintValue;
  String get phoneValue;
  String get signupValue;
  String get alreadyHaveAccountValue;
  String get dontHaveAccountValue;
  String get loginValue;
  String get forgotPasswordValue;
  String get resetPasswordValue;
  String get acceptUserAgreementValue;
  String get incorrectPasswordFormatValue;
  String get weakPasswordErrorValue;
  String get shortPasswordErrorValue;
  String get shortUsernameErrorValue;
  String get longUsernameErrorValue;
  String get incorrectUsernameFormatValue;
  String get loginErrorValue;
  String get signupErrorValue;
  String get loadingValue;
  String get userNotFoundValue;

  Map<String, String> get values => {
        appName: appNameValue,
        drawerHome: drawerHomeValue,
        drawerAsk: drawerAskValue,
        username: usernameValue,
        usernameHint: usernameHintValue,
        email: emailValue,
        emailHint: emailHintValue,
        password: passwordValue,
        passwordHint: passwordHintValue,
        phone: phoneValue,
        signup: signupValue,
        alreadyHaveAccount: alreadyHaveAccountValue,
        dontHaveAccount: dontHaveAccountValue,
        login: loginValue,
        forgotPassword: forgotPasswordValue,
        resetPassword: resetPasswordValue,
        acceptUserAgreement: acceptUserAgreementValue,
        incorrectPasswordFormat: incorrectPasswordFormatValue,
        weakPasswordError: weakPasswordErrorValue,
        shortPasswordError: shortPasswordErrorValue,
        shortUsernameError: shortUsernameErrorValue,
        longUsernameError: longUsernameErrorValue,
        incorrectUsernameFormat: incorrectUsernameFormatValue,
        loginError: loginErrorValue,
        signupError: signupErrorValue,
        loading: loadingValue,
        userNotFound: userNotFoundValue,
      };
}
