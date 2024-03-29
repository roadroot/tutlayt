import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutlayt/pagination/page.model.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/controller.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold(
      {required this.params, this.route, this.pageModel, super.key, this.body})
      : assert(
            pageModel == null && route != null ||
                pageModel != null && route == null,
            "Must specify a pageModel or route but not both.");

  final Widget? body;
  final PageModel? pageModel;
  final Map<String, String?> params;

  final String? route;

  PageModel getPage([String? route]) {
    return pageModel ??
        RouteUtil.routedPages.firstWhere((page) => page.route == route);
  }

  // TODO: handle error in the future builders across the app

  @override
  Widget build(BuildContext context) {
    PageModel page = getPage(route);
    return Scaffold(
      appBar: AppBar(
        title: page.title,
      ),
      body: body ?? page.body(params),
      drawer: Obx(() {
        final widgets = RouteUtil.pages
            .where((element) => element.drawer != null)
            .map<Widget>(
              (page) => ListTile(
                title: page.drawer!.title,
                leading: page.drawer!.leading,
                trailing: page.drawer!.trailing,
                selected: route == page.route,
                onTap: () => page.onTap(context, params),
              ),
            )
            .toList();
        User? data = Get.find<Controller>().userObs.value;
        if (data != null) {
          widgets.insert(
            0,
            GestureDetector(
              onTap: () => Get.offNamed(RouteUtil.userRoute),
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
