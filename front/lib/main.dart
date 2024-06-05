import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';
import 'package:tutlayt/l10n/dicos.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/controller.dart';
import 'package:tutlayt/services/user/user.service.dart';
import 'package:tutlayt/services/util/locator.dart';
import 'package:stack_trace/stack_trace.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  hierarchicalLoggingEnabled = true;

  Logger.root.level = Level.LEVELS.firstWhere(
    (element) => element.name == dotenv.env['API_LOG_LEVEL']?.toUpperCase(),
    orElse: () => Level.OFF,
  );

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print(
        '[${record.level.name}] ${record.time} ${record.loggerName}: ${record.message}');
  });

  await initHiveForFlutter();
  registerServices();

  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.root.severe("Error :  ${details.exception}");
    Logger.root.severe(Trace.from(details.stack!).terse);
  };
  Chain.capture(() async {
    try {
      Get.find<Controller>().user = await Get.find<UserService>().getUser();

      if (dotenv.env['AUTO_LOGIN'] == 'true') {
        if (dotenv.env['USERNAME'] != null && dotenv.env['PASSWORD'] != null) {
          var user = await Get.find<AuthService>().signInCrendetials(
            username: dotenv.env['USERNAME']!,
            password: dotenv.env['PASSWORD']!,
          );
          Logger.root.info('Auto login: ${user != null}');
        }
      }
    } catch (e) {
      Logger.root.severe("Error :  $e");
    }
    runApp(const MyApp());
  }, onError: (error, stackTrace) {
    Logger.root.severe("Async Error :  $error");
    Logger.root.severe(stackTrace.terse);
  });
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
          cardColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow.shade900,
          )
,
        ),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
