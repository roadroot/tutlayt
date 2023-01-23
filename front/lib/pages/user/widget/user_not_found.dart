import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        Text(AppLocalizations.of(context)!.userNotFound),
      ],
    );
  }
}
