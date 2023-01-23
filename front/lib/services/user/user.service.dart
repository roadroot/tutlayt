import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/services/user/user.model.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class UserService {
  Future<User?> get user async {
    final token = await GetIt.I<SecuredStoreService>().jwtToken;
    return token == null ? null : User.from(JwtDecoder.decode(token));
  }

  /// get the user with id [userId]
  /// or return the current logged user if there is one and if
  /// [userId] is null
  Future<User?> getUser({
    String? userId,
  }) async {
    if (userId == null) {
      return await user;
    }
    // await Future.delayed(const Duration(seconds: 3)); // TODO: remove this
    return await GetIt.I<ApiService>().queryUser(userId);
  }
}
