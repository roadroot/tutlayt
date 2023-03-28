import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class ApiService {
  final ValueNotifier<GraphQLClient> client;

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
        );

  Future<Map<String, dynamic>?> executor(String query) async {
    return await client.value
        .query(QueryOptions(
          document: gql(query),
        ))
        .then((value) => value.data);
  }
}
