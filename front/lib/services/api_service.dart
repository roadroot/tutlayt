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
    ).concat(HttpLink(dotenv.env['API_URL'] ?? '',
        defaultHeaders: {'Apollo-Require-Preflight': 'true'}));

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

    logger = Logger('ApiService');
    logger.info('ApiService initialized');
  }

  Future<Map<String, dynamic>?> query(
      (String, Map<String, dynamic>) qlAndVariables) async {
    logger.info('Variables: ${qlAndVariables.$2}');
    logger.info('Query: ${qlAndVariables.$1}');
    try {
      return await client.value
          .query(QueryOptions(
            document: gql(qlAndVariables.$1),
            variables: qlAndVariables.$2,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ))
          .then((value) => value.data);
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> mutate(
      (String, Map<String, dynamic>) qlAndVariables) async {
    logger.info('Variables: ${qlAndVariables.$2}');
    logger.info('Mutation: ${qlAndVariables.$1}');
    try {
      return await client.value
          .mutate(MutationOptions(
            document: gql(qlAndVariables.$1),
            variables: qlAndVariables.$2,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ))
          .then((value) => value.data);
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }

  Stream<Map<String, dynamic>?> subscribe(
      (String, Map<String, dynamic>) qlAndVariables) {
    logger.info('Variables: ${qlAndVariables.$2}');
    logger.info('Subscription: ${qlAndVariables.$1}');
    try {
      var s = client.value
          .subscribe(SubscriptionOptions(
            document: gql(qlAndVariables.$1),
            variables: qlAndVariables.$2,
            cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
          ))
          .map((event) => event.data);
      return s;
    } catch (e) {
      logger.severe(e);
      rethrow;
    }
  }
}
