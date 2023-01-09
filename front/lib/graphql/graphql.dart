import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  static const String _createUserMutation = """
    mutation(\$username: String!, \$email: String!, \$password: String!) {
      createUser(data: {
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

  static const String _loginMutation = """
    mutation(\$username: String!, \$password: String!) {
      login(data: {
        username: \$username
        password: \$password
      })
    }
  """;

  Future<User?> createUser(
      {required String username,
      required String email,
      required String password}) async {
    client.value.cache.store.reset();
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document: gql(_createUserMutation),
      variables: {'username': username, 'email': email, 'password': password},
      parserFn: (data) {
        // JwtDecoder.decode(data);
        return User(
            id: data['createUser']['id'],
            username: data['createUser']['username'],
            email: data['createUser']['email'],
            phone: data['createUser']['phone'],
            picture: data['createUser']['picture']);
      },
    ));
    return result.parsedData;
  }

  Future<User?> login(
      {required String username, required String password}) async {
    client.value.cache.store.reset();
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
