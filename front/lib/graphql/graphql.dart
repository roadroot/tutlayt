import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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

  static const String createUserMutation = """
    mutation(
        \$username: String!,
        \$email: String!,
        \$phone: String!
      ) {
      createUser(data: {
        username: \$username
        email: \$email
        phone: \$phone
      }) {
        id
        username
        email
        phone
        picture
      }
    }
  """;

  Future<User?> createUser(
      {required username, required email, required phone}) async {
    QueryResult<User?> result = await client.value.mutate(MutationOptions(
      document:
          gql(createUserMutation), // this is the query string you just created
      variables: {
        'username': username,
        'email': email,
        'phone': phone,
      },
      parserFn: (data) {
        return User(
            id: data['id'],
            username: data['username'],
            email: data['email'],
            phone: data['phone']);
      },
    ));
    return result.parsedData;
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String phone;
  final String? picture;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      required this.phone,
      this.picture});
}
