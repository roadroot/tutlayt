import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/helper/util.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();
  final ValueNotifier<GraphQLClient> client;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal()
      : client = ValueNotifier(
          GraphQLClient(
            link: HttpLink(
              dotenv.env['API_URL'] ?? '',
            ),
            cache: GraphQLCache(store: HiveStore()),
          ),
        );

  static const String _registerMutation = """
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

  static const String _loginMutation = """
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

  static const String _refreshMutation = """
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
    await SecuredStore().setToken(result.data?['register']?['token'],
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
    await SecuredStore().setToken(result.data?['register']?['token'],
        result.data?['register']?['refreshToken']);
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
    await SecuredStore().setToken(result.data?['refresh']?['token'],
        result.data?['refresh']?['refreshToken']);
    return result.parsedData;
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final String? picture;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      this.picture});

  static User from(Map<String, dynamic> data) => User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      phone: data['phone']);
}
