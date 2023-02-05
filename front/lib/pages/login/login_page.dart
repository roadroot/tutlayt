import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutlayt/services/user/user.model.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/util/message.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/widget/password_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _form = GlobalKey(debugLabel: 'registrationForm');
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(AppLocalizations.of(context)!.username),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: PasswordField(
                    controller: _password,
                    title: AppLocalizations.of(context)!.password,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.standard,
                    ),
                    onPressed: () async {
                      User? user = await GetIt.I<ApiService>().login(
                        username: _username.text,
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
                    },
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              RouteUtil.registerRoute,
                            ),
                        child: Text(AppLocalizations.of(context)!.signup))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.forgotPassword),
                    TextButton(
                        onPressed: () {}, // TODO implement reset password
                        child:
                            Text(AppLocalizations.of(context)!.resetPassword))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
