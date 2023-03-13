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

  Future<T?> query<T>({
    required String query,
    required T? Function(Map<String, dynamic> data) parserFn,
  }) async {
    QueryResult<T?> result = await client.value.query(QueryOptions(
      document: gql(query),
      parserFn: (data) {
        return parserFn(data);
      },
    ));
    return result.parsedData;
  }
}
