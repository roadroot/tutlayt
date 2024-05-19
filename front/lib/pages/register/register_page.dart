import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/configuration/config.dart';
import 'package:tutlayt/l10n/abstract_language.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/util/message.dart';
import 'package:tutlayt/services/util/util.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/widget/controlled_check_box.dart';
import 'package:tutlayt/widget/password_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final GlobalKey<FormState> _form = GlobalKey(debugLabel: 'registrationForm');
  final TextEditingController _username = TextEditingController(
      text: faker.internet.userName().replaceAll('-', '_'));
  final TextEditingController _password =
      TextEditingController(text: faker.internet.password());
  final TextEditingController _email =
      TextEditingController(text: faker.internet.email());

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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.length < 6
                      ? shortUsernameError.tr
                      : value.length > 30
                          ? longUsernameError.tr
                          : Regex.username.hasMatch(value)
                              ? null
                              : incorrectUsernameFormat.tr,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(username.tr),
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
                      : incorrectPasswordFormat.tr,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: Text(email.tr),
                      hintText: emailHint.tr,
                      prefixIcon: const Icon(Icons.email)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: PasswordField(
                  controller: _password,
                  title: password.tr,
                  hintText: passwordHint.tr,
                  validator: (value) => value == null || value.length < 8
                      ? shortPasswordError.tr
                      : Util.getStrength(value) == Strength.weak
                          ? weakPasswordError.tr
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
                        acceptUserAgreement.tr,
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
                      User? user =
                          await Get.find<AuthService>().signUpCredentials(
                        username: _username.text,
                        email: _email.text,
                        password: _password.text,
                      );

                      if (user == null) {
                        Message.error.show(
                          signupError.tr,
                        );
                      } else {
                        Get.offNamed(
                          Routes.user.toString(),
                        );
                      }
                    }
                  },
                  child: Text(signup.tr),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(alreadyHaveAccount.tr),
                  TextButton(
                      onPressed: () => Get.replace(
                            Routes.login.toString(),
                          ),
                      child: Text(login.tr))
                ],
              ),
            ]),
      ),
    ));
  }
}
