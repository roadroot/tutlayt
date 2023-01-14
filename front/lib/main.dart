import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tutlayt/graphql/graphql.dart';
import 'package:tutlayt/structure/default_scaffold.dart';
import 'package:tutlayt/structure/routes.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ApiClient().client,
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
        ),
        initialRoute: RouteUtils.homeRoute,
        routes: DefaultScaffold.getRoutes(),
      ),
    );
  }
}
