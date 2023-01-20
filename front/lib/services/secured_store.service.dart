import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/services/user/user.model.dart';

class SecuredStoreService {
  static const String _tokenEntry = 'token';
  static const String _refreshTokenEntry = 'refreshToken';

  final _storage = const FlutterSecureStorage();

  Future<String?> get jwtToken async {
    return await _storage.read(key: _tokenEntry);
  }

  Future<String?> get jwtRefreshToken async {
    return await _storage.read(key: _refreshTokenEntry);
  }

  Future<void> setToken(String? token, String? refreshToken) async {
    await _storage.write(key: _tokenEntry, value: token);
    await _storage.write(key: _refreshTokenEntry, value: refreshToken);
  }

  Future<User?> getUserOrCurrentUser(String? userId) async {
    final token = await jwtToken;
    return token == null ? null : User.from(JwtDecoder.decode(token));
  }
}
