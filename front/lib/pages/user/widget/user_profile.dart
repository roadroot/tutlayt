import 'package:flutter/material.dart';
import 'package:tutlayt/services/user/user.model.dart';

class UserProfile extends StatelessWidget {
  static const double headerHeight = 150;
  static const double avatarHeight = 75;
  const UserProfile(this.user, {super.key});

  final UserResult user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Material(
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: const Color(0xFF0099CC),
                height: headerHeight / 3,
              ),
              Container(
                color: const Color(0xFF9ACC32),
                height: headerHeight / 3,
              ),
              Container(
                color: const Color(0xFFFFE613),
                height: headerHeight / 3,
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: headerHeight - avatarHeight * 1.5,
            ),
            Material(
              elevation: 25,
              shape: const CircleBorder(),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                foregroundImage: NetworkImage(user.picture ?? ''),
                maxRadius: avatarHeight,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  user.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ))
          ],
        ),
      ],
    );
  }
}
