import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutlayt/graphql/graphql.dart';
import 'package:tutlayt/helper/message.dart';
import 'package:tutlayt/helper/util.dart';
import 'package:tutlayt/structure/default_scaffold.dart';

class Registration extends StatelessWidget {
  Registration({super.key});
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
                child: TextFormField(
                  controller: _password,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.length < 8
                      ? AppLocalizations.of(context)!.shortPasswordError
                      : Util.getStrength(value) == Strength.weak
                          ? AppLocalizations.of(context)!.weakPasswordError
                          : null,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.password),
                      hintText: AppLocalizations.of(context)!.passwordHint,
                      prefixIcon: const Icon(Icons.lock)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
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
                      User? user = await ApiClient().register(
                          username: _username.text,
                          email: _email.text,
                          password: _password.text);

                      if (mounted && user == null) {
                        Message.error.show(
                            context, AppLocalizations.of(context)!.signupError);
                      }

                      // TODO next?
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
                      onPressed: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (context, animation, animation2) =>
                                    const DefaultScaffold('login')),
                          ),
                      child: Text(AppLocalizations.of(context)!.login))
                ],
              ),
            ]),
      ),
    ));
  }
}
