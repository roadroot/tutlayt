import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logging/logging.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class ApiService {
  late ValueNotifier<GraphQLClient> client;
  late Logger logger;

  ApiService() {
    Link httpLink = AuthLink(
      getToken: () async =>
          'Bearer ${await Get.find<SecuredStoreService>().jwtToken}',
    ).concat(HttpLink(
      dotenv.env['API_URL'] ?? '',
    ));

    WebSocketLink websocketLink = WebSocketLink(
      dotenv.env['API_WS_URL'] ?? '',
      config: const SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 30),
      ),
    );

    client = ValueNotifier(
      GraphQLClient(
        link: Link.split(
          (request) => request.isSubscription,
          websocketLink,
          httpLink,
        ),
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    Logger.root.level = Level.LEVELS.firstWhere(
      (element) => element.name == dotenv.env['API_LOG_LEVEL']?.toUpperCase(),
      orElse: () => Level.OFF,
    );
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(
          '[${record.level.name}] ${record.time} ${record.loggerName}: ${record.message}');
    });
    logger = Logger('ApiService');
    logger.info('ApiService initialized');
  }

  Future<Map<String, dynamic>?> query(String query) async {
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

  Future<Map<String, dynamic>?> mutate(String query) async {
    logger.info(query);
    try {
      return await client.value
          .mutate(MutationOptions(
            document: gql(query),
          ))
          .then((value) => value.data);
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> subscribe(String query) {
    logger.info(query);
    try {
      var s = client.value
          .subscribe(SubscriptionOptions(document: gql(query)))
          .map((event) => event.data);
      return s;
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }
}
