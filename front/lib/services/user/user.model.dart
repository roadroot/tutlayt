import 'package:graphql_decorator/annotations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

part 'user.model.g.dart';

@QlEntity(name: 'user')
abstract class User {
  @QlField()
  final String id;
  @QlField()
  final String username;
  @QlField()
  final String email;
  @QlField()
  final String? phone;
  @QlField()
  final String? picture;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.picture,
  });

  @QlQuery()
  User user(String id);
}
