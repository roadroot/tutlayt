import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/user/user.model.dart';
import 'package:tutlayt/services/util/message.dart';
import 'package:tutlayt/services/util/util.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/widget/controlled_check_box.dart';
import 'package:tutlayt/widget/password_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final GlobalKey<FormState> _form = GlobalKey(debugLabel: 'registrationForm');
  final TextEditingController _username =
      TextEditingController(text: faker.internet.userName());
  final TextEditingController _password =
      TextEditingController(text: faker.internet.password());
  final TextEditingController _email =
      TextEditingController(text: faker.internet.email());

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Center(
        child: Form(
      key: _form,
      child: SizedBox(
        width: Config.loginPanelWidth,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _username,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.length < 6
                      ? AppLocalizations.of(context)!.shortUsernameError
                      : value.length > 30
                          ? AppLocalizations.of(context)!.longUsernameError
                          : Regex.username.hasMatch(value)
                              ? null
                              : AppLocalizations.of(context)!
                                  .incorrectUsernameFormat,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.username),
                      prefixIcon: const Icon(Icons.person)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => Regex.email.hasMatch(value)
                      ? null
                      : AppLocalizations.of(context)!.incorrectPasswordFormat,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.email),
                      hintText: AppLocalizations.of(context)!.emailHint,
                      prefixIcon: const Icon(Icons.email)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: PasswordField(
                  controller: _password,
                  title: AppLocalizations.of(context)!.password,
                  hintText: AppLocalizations.of(context)!.passwordHint,
                  validator: (value) => value == null || value.length < 8
                      ? AppLocalizations.of(context)!.shortPasswordError
                      : Util.getStrength(value) == Strength.weak
                          ? AppLocalizations.of(context)!.weakPasswordError
                          : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ControlledCheckBox(
                      controller: BoolController(),
                    ),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.acceptUserAgreement,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                child: ElevatedButton(
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.standard),
                  onPressed: () async {
                    if (_form.currentState!.validate()) {
                      UserResult? user =
                          await GetIt.I<AuthService>().signUpCredentials(
                        username: _username.text,
                        email: _email.text,
                        password: _password.text,
                      );

                      if (mounted) {
                        if (user == null) {
                          Message.error.show(
                            context,
                            AppLocalizations.of(context)!.signupError,
                          );
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            RouteUtil.userRoute,
                          );
                        }
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.signup),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                  TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            RouteUtil.loginRoute,
                          ),
                      child: Text(AppLocalizations.of(context)!.login))
                ],
              ),
            ]),
      ),
    ));
  }
}
