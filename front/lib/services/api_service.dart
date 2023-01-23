import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/services/user/user.model.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class ApiService {
  final ValueNotifier<GraphQLClient> client;

  ApiService()
      : client = ValueNotifier(
          GraphQLClient(
            link: HttpLink(
              dotenv.env['API_URL'] ?? '',
            ),
            cache: GraphQLCache(store: HiveStore()),
          ),
        );

  static const String _userQuery =
      """
        query(\$id: String!) {
          user(id: \$id) {
            id
            username
            picture
            email
            phone
          }
        }
  """;

  static const String _registerMutation =
      """
    mutation(\$username: String!, \$email: String!, \$password: String!) {
      register(data: {
        username: \$username
        email: \$email
        password: \$password
      }) {
        token
        refreshToken
      }
    }
  """;

  static const String _loginMutation =
      """
    mutation(\$username: String!, \$password: String!) {
      login(data: {
        username: \$username
        password: \$password
      }) {
        token
        refreshToken
      }
    }
  """;

  static const String _refreshMutation =
      """
    mutation(\$refreshToken: String!) {
      refresh(data: \$refreshToken) {
        token
        refreshToken
      }
    }
  """;

  Future<User?> register(
      {required String username,
      required String email,
      required String password}) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_registerMutation),
      variables: {'username': username, 'email': email, 'password': password},
      parserFn: (data) {
        Map<String, dynamic> user =
            JwtDecoder.decode(data['register']?['token']);
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['register']?['token'],
        result.data?['register']?['refreshToken']);
    return result.parsedData;
  }

  Future<User?> login(
      {required String username, required String password}) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_loginMutation),
      variables: {'username': username, 'password': password},
      parserFn: (data) {
        Map<String, dynamic> user = JwtDecoder.decode(data['login']?['token']);
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['login']?['token'],
        result.data?['login']?['refreshToken']);
    return result.parsedData;
  }

  Future<User?> refresh(String refreshToken) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_refreshMutation),
      variables: {'refreshToken': refreshToken},
      parserFn: (data) {
        Map<String, dynamic> user = JwtDecoder.decode(data['refresh']['token']);
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    await GetIt.I<SecuredStoreService>().setToken(
        result.data?['refresh']?['token'],
        result.data?['refresh']?['refreshToken']);
    return result.parsedData;
  }

  Future<User?> queryUser(String userId) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.query(QueryOptions(
      document: gql(_userQuery),
      variables: {'id': userId},
      parserFn: (data) {
        Map<String, dynamic> user = data['user'];
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    return result.parsedData;
  }
}
