import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/controller.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({required this.uri, super.key, this.body});

  final Widget? body;
  final Uri uri;

  PageModel get page =>
      Routes.routedPages.firstWhere((page) => page.canHandle(uri));

  // TODO: handle error in the future builders across the app

  @override
  Widget build(BuildContext context) {
    PageModel page = this.page;
    return Scaffold(
      appBar: AppBar(
        title: page.title,
      ),
      body: body ?? page.body(uri),
      drawer: Obx(() {
        final widgets = Routes.pages
            .where((e) => e.drawer != null)
            .map<Widget>(
              (e) => ListTile(
                title: e.drawer!.title,
                leading: e.drawer!.leading,
                trailing: e.drawer!.trailing,
                selected: listEquals(e.route, page.route),
                onTap: () => e.onTap(context, uri),
              ),
            )
            .toList();
        User? data = Get.find<Controller>().userObs.value;
        if (data != null) {
          widgets.insert(
            0,
            GestureDetector(
              onTap: () => Get.offNamed(Routes.user.toString()),
              child: DrawerHeader(
                decoration: const BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      elevation: 25,
                      shape: const CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        foregroundImage: NetworkImage(data.picture ?? ''),
                        maxRadius: 40,
                      ),
                    ),
                    Text(
                      data.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      data.email,
                      style: TextStyle(color: Theme.of(context).disabledColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Drawer(
            child: ListView(
          children: widgets,
        ));
      }),
    );
  }
}
