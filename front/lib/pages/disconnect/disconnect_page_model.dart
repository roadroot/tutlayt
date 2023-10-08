import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutlayt/pages/home/home_page.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/controller.dart';

class DisconenctPageModel extends PageModel {
  DisconenctPageModel()
      : super(
          title: const Text('Disconnect'),
          drawer: const DrawerTile(
            title: Text('Disconnect'),
            leading: Icon(CupertinoIcons.power),
          ),
          onTap: (context, params) async {
            await Get.find<AuthService>().disconnect();
            Get.find<Controller>().user = null;
          },
          onlyWhenConnected: true,
        );

  @override
  Widget body(Map<String, String?> params) => const HomePage();
}
