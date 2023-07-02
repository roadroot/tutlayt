import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';
import 'package:tutlayt/pagination/route.util.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/util/locator.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initHiveForFlutter();
  setupGetIt();
  hierarchicalLoggingEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GetIt.I<ApiService>().client,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('fr', ''),
        ],
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
