import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class AuthService {
  Future<User?> signInCrendetials(
      {required String username, required String password}) async {
    return _getAndSaveUser(await Get.find<Mutation>().login(
        const TokenSelector(),
        LoginParam(username: username, password: password)));
  }

  Future<User?> signUpCredentials({
    required String username,
    required String email,
    required String password,
  }) async {
    return _getAndSaveUser(await Get.find<Mutation>().register(
      const TokenSelector(),
      RegisterData(username: username, email: email, password: password),
    ));
  }

  Future<User?> refresh(String refreshToken) async {
    return await _getAndSaveUser(await Get.find<Mutation>()
        .refresh(const TokenSelector(), refreshToken));
  }

  Future<User?> _getAndSaveUser(Token? token) async {
    if (token == null) return null;
    await Get.find<SecuredStoreService>()
        .setToken(token.token, token.refreshToken);

    return User.fromMap(JwtDecoder.decode(token.token));
  }

  /// disconnect the current logged user
  Future<void> disconnect() async {
    await SecuredStoreService().setToken(null, null);
  }

  Future<bool> get isConnected async {
    return await Get.find<SecuredStoreService>().jwtToken != null;
  }
}
