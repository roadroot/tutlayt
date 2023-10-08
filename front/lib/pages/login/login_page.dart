import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/l10n/abstract_language.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/controller.dart';
import 'package:tutlayt/services/util/message.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/widget/password_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _form = GlobalKey(debugLabel: 'registrationForm');
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      label: Text(username.tr),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: PasswordField(
                    controller: _password,
                    title: password.tr,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.standard,
                    ),
                    onPressed: () async {
                      User? user =
                          await Get.find<AuthService>().signInCrendetials(
                        username: _username.text,
                        password: _password.text,
                      );
                      if (user == null) {
                        Message.error.show(
                          loginError.tr,
                        );
                      } else {
                        Get.find<Controller>().user = user;
                        Get.offNamed(
                          RouteUtil.userRoute,
                        );
                      }
                    },
                    child: Text(login.tr),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(dontHaveAccount.tr),
                    TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              RouteUtil.registerRoute,
                            ),
                        child: Text(signup.tr))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(forgotPassword.tr),
                    TextButton(
                        onPressed: () {}, // TODO implement reset password
                        child: Text(resetPassword.tr))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
