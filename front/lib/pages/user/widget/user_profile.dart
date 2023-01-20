import 'package:flutter/cupertino.dart';
import 'package:tutlayt/services/user/user.model.dart';

class UserProfile extends StatelessWidget {
  const UserProfile(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Text(user.username)],
    );
  }
}
