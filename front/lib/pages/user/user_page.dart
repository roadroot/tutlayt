import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/pages/user/widget/loading.dart';
import 'package:tutlayt/pages/user/widget/user_not_found.dart';
import 'package:tutlayt/pages/user/widget/user_profile.dart';
import 'package:tutlayt/services/user/user.service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key, this.userId});
  final String? userId;

  // TODO When disconnected, show a message to connect instead of user not found

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Get.find<UserService>().getUser(userId: userId),
      builder: (context, snapshot) {
        return Center(
          child: snapshot.connectionState != ConnectionState.done
              ? const Loading()
              : snapshot.data == null
                  ? const UserNotFound()
                  : UserProfile(snapshot.data!),
        );
      },
    );
  }
}
