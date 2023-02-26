import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/services/auth/models/auth.dart';
import 'package:tutlayt/services/auth/models/params/credentials.dart';
import 'package:tutlayt/services/auth/models/params/register.dart';
import 'package:tutlayt/services/user/user.model.dart';
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

  Future<UserResult?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    client.value.cache.store.reset();
    QueryResult<UserResult?> result = await client.value.mutate(MutationOptions(
      document: gql(AuthQl.register(
          data: RegisterParamResult(
        email: email,
        password: password,
        username: username,
      ))),
      parserFn: (data) {
        Map<String, dynamic> user =
            JwtDecoder.decode(data['register']?['token']);
        return UserResult.fromMap(user);
      },
    ));
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['register']?['token'],
        result.data?['register']?['refreshToken']);
    return result.parsedData;
  }

  Future<UserResult?> login(
      {required String username, required String password}) async {
    client.value.cache.store.reset();
    QueryResult<UserResult?> result = await client.value.mutate(
      MutationOptions(
        document: gql(
          AuthQl.login(
              data: CredentialsResult(username: username, password: password)),
        ),
        parserFn: (data) {
          return UserResult.fromMap(JwtDecoder.decode(data['login']?['token']));
        },
      ),
    );
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['login']?['token'],
        result.data?['login']?['refreshToken']);
    return result.parsedData;
  }

  Future<UserResult?> refresh(String refreshToken) async {
    client.value.cache.store.reset();
    QueryResult<UserResult?> result = await client.value.mutate(MutationOptions(
      document: gql(AuthQl.refresh(data: refreshToken)),
      variables: {'refreshToken': refreshToken},
      parserFn: (data) {
        return UserResult.fromMap(JwtDecoder.decode(data['refresh']['token']));
      },
    ));
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['refresh']?['token'],
        result.data?['refresh']?['refreshToken']);
    return result.parsedData;
  }

  Future<UserResult?> queryUser(String userId) async {
    client.value.cache.store.reset();
    QueryResult<UserResult?> result = await client.value.query(QueryOptions(
      document: gql(UserQl.user(id: userId)),
      variables: {'id': userId},
      parserFn: (data) {
        return UserResult.fromMap(data['user']);
      },
    ));
    return result.parsedData;
  }
}
