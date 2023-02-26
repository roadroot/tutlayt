import 'package:graphql_decorator/annotations.dart';
import 'package:tutlayt/services/auth/models/params/credentials.dart';
import 'package:tutlayt/services/auth/models/params/register.dart';

part 'auth.g.dart';

@QlEntity(name: 'token')
abstract class Auth {
  @QlField()
  final String token;
  @QlField()
  final String refreshToken;

  const Auth({
    required this.token,
    required this.refreshToken,
  });

  @QlMutation()
  Auth login(Credentials data);

  @QlMutation()
  Auth register(RegisterParam data);

  @QlMutation()
  Auth refresh(String data);
}
