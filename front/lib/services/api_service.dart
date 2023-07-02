import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tutlayt/services/secured_store.service.dart';
import 'package:path/path.dart' as path;

class ApiService {
  final ValueNotifier<GraphQLClient> client;
  final Logger logger = Logger('ApiService');

  ApiService()
      : client = ValueNotifier(
          GraphQLClient(
            link: AuthLink(
              getToken: () async =>
                  'Bearer ${await GetIt.I<SecuredStoreService>().jwtToken}',
            ).concat(HttpLink(
              dotenv.env['API_URL'] ?? '',
            )),
            cache: GraphQLCache(store: HiveStore()),
          ),
        ) {
    logger.level = Level.LEVELS.firstWhere(
      (element) => element.name == dotenv.env['API_LOG_LEVEL']?.toUpperCase(),
      orElse: () => Level.OFF,
    );
    if (dotenv.env['API_LOG_FILE'] != null) {
      logger.onRecord.listen((record) async {
        Directory appDir = await getApplicationDocumentsDirectory();
        String log = path.join(appDir.path, dotenv.env['API_LOG_FILE']!);
        File logFile = await File(log).create(recursive: true);
        IOSink writer = logFile.openWrite(mode: FileMode.append);
        writer.write('${record.level.name}: ${record.time}: ${record.message}');
        writer.close();
      });
    }
    logger.info('ApiService initialized');
  }

  Future<Map<String, dynamic>?> executor(String query) async {
    logger.info(query);
    try {
      return await client.value
          .query(QueryOptions(
            document: gql(query),
          ))
          .then((value) => value.data);
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }
}
