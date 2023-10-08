import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutlayt/l10n/abstract_language.dart';

class UserNotFound extends StatelessWidget {
  const UserNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/not-found.png',
          width: 200,
        ),
        Text(userNotFound.tr),
      ],
    );
  }
}
