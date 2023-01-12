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

  static const String _createUserMutation =
      """
    mutation(\$username: String!, \$email: String!, \$password: String!) {
      register(data: {
        username: \$username
        email: \$email
        password: \$password
      }) {
        id
        username
        email
        phone
        picture
      }
    }
  """;

  static const String _loginMutation =
      """
    mutation(\$username: String!, \$password: String!) {
      login(data: {
        username: \$username
        password: \$password
      })
    }
  """;

  Future<User?> register(
      {required String username,
      required String email,
      required String password}) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_createUserMutation),
      variables: {'username': username, 'email': email, 'password': password},
      parserFn: (data) {
        Map<String, dynamic> user = JwtDecoder.decode(data['register']);
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    await SecuredStore().setToken(result.data?['register']);
    return result.parsedData;
  }

  Future<User?> login(
      {required String username, required String password}) async {
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_loginMutation),
      variables: {'username': username, 'password': password},
      parserFn: (data) {
        Map<String, dynamic> user = JwtDecoder.decode(data['login']);
        return User(
            id: user['id'],
            username: user['username'],
            email: user['email'],
            phone: user['phone'],
            picture: user['picture']);
      },
    ));
    await SecuredStore().setToken(result.data?['login']);
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
}
