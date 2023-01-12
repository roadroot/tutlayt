import 'package:flutter/material.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tutlayt/graphql/graphql.dart';
import 'package:tutlayt/helper/message.dart';
import 'package:tutlayt/structure/default_scaffold.dart';

class Login extends StatelessWidget {
  Login({super.key});

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
                        prefixIcon: const Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(AppLocalizations.of(context)!.password),
                        prefixIcon: const Icon(Icons.lock)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        visualDensity: VisualDensity.standard),
                    onPressed: () async {
                      User? user = await ApiClient().login(
                          username: _username.text, password: _password.text);
                      if (mounted && user == null) {
                        Message.error.show(context,
                            AppLocalizations.of(context)!.connectionError);
                      }
                      // TODO next
                    },
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                        onPressed: () => Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          animation2) =>
                                      const DefaultScaffold('registration')),
                            ),
                        child: Text(AppLocalizations.of(context)!.signup))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.forgotPassword),
                    TextButton(
                        onPressed: () => null,
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
