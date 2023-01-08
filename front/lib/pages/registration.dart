import 'package:flutter/material.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/graphql/graphql.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

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
                      label: Text(AppLocalizations.of(context)!.email),
                      hintText: AppLocalizations.of(context)!.emailHint,
                      prefixIcon: const Icon(Icons.email)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
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
                    print(await ApiClient().createUser(
                        username: 'celine', email: 'djeddi', phone: '0777411'));
                  },
                  child: Text(AppLocalizations.of(context)!.signup),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                  TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, 'login'),
                      child: Text(AppLocalizations.of(context)!.login))
                ],
              ),
            ]),
      ),
    ));
  }
}
