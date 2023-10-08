import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';
import 'package:tutlayt/l10n/dicos.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/util/locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  hierarchicalLoggingEnabled = true;
  await initHiveForFlutter();
  registerServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: Get.find<ApiService>().client,
      child: GetMaterialApp(
        translations: Dicos(),
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
        title: 'Tutlayt',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        onGenerateRoute: RouteUtil.onGenerateRoute,
      ),
    );
  }
}
