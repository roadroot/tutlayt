import 'package:flutter/material.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: SizedBox(
          width: Config.loginPanelWidth,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(AppLocalizations.of(context)!.username),
                        prefixIcon: const Icon(Icons.person)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
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
                    onPressed: () => null,
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.dontHaveAccount),
                    TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                            context, 'registration'),
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
