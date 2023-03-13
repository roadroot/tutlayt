import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/auth/models/auth.dart';
import 'package:tutlayt/services/auth/models/params/credentials.dart';
import 'package:tutlayt/services/auth/models/params/register.dart';
import 'package:tutlayt/services/secured_store.service.dart';
import 'package:tutlayt/services/user/user.model.dart';

class AuthService {
  Future<UserResult?> signInCrendetials(
      {required String username, required String password}) async {
    return _getAndSaveUser(await GetIt.I<ApiService>().query(
      query: AuthQl.login(
          data: CredentialsResult(username: username, password: password)),
      parserFn: (data) {
        return AuthResult.fromMap(data);
      },
    ));
  }

  Future<UserResult?> signUpCredentials({
    required String username,
    required String email,
    required String password,
  }) async {
    return _getAndSaveUser(await GetIt.I<ApiService>().query(
      query: AuthQl.register(
        data: RegisterParamResult(
          email: email,
          password: password,
          username: username,
        ),
      ),
      parserFn: (data) {
        return AuthResult.fromMap(data);
      },
    ));
  }

  Future<UserResult?> refresh(String refreshToken) async {
    return _getAndSaveUser(await GetIt.I<ApiService>().query(
      query: AuthQl.refresh(data: refreshToken),
      parserFn: (data) {
        return AuthResult.fromMap(data);
      },
    ));
  }

  Future<UserResult?> _getAndSaveUser(AuthResult? token) async {
    if (token == null) return null;
    await GetIt.I<SecuredStoreService>()
        .setToken(token.token, token.refreshToken);

    return UserResult.fromMap(JwtDecoder.decode(token.token));
  }
}
