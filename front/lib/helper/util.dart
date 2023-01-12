import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tutlayt/graphql/graphql.dart';

abstract class Util {
  static const List<String> _blackList = ['azerty', '123', 'qwerty'];

  static Strength getStrength(String? password) {
    return Strength.from(_calculatePasswordStrength(password));
  }

  static num _calculatePasswordStrength(String? password) {
    if (password == null || password.length < 8) {
      return 0;
    }
    String whitePassword = password;
    for (String element in _blackList) {
      whitePassword = whitePassword.replaceAll(element, '');
      whitePassword = whitePassword.replaceAll(element.toLowerCase(), '');
      whitePassword = whitePassword.replaceAll(element.toUpperCase(), '');
      whitePassword = whitePassword.replaceAll(
          element.substring(0, 1).toUpperCase() + element.substring(1), '');
    }
    double score = 0;
    List<int> chars = whitePassword.codeUnits;
    for (int c in chars) {
      double charScore = 0;
      double diversity =
          1 / chars.where((element) => element == c).length + 0.1;

      if ('a'.codeUnitAt(0) <= c && 'z'.codeUnitAt(0) >= c) {
        charScore = 0.75;
      } else if ('A'.codeUnitAt(0) <= c && 'Z'.codeUnitAt(0) >= c) {
        charScore = 0.9;
      } else if ('0'.codeUnitAt(0) <= c && '9'.codeUnitAt(0) >= c) {
        charScore = 0.05;
      } else {
        charScore = 2;
      }
      score += diversity * charScore;
    }

    double size = 0.2 + password.length / 10;
    int distinctChars = chars.toSet().length;
    return pow(score * distinctChars, size);
  }
}

class SecuredStore {
  static const String _tokenEntry = 'token';
  static const String _refreshTokenEntry = 'refreshToken';
  static final SecuredStore _singleton = SecuredStore._internal();

  final _storage = const FlutterSecureStorage();

  factory SecuredStore() {
    return _singleton;
  }

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

  Future<User?> get user async {
    final token = await jwtToken;
    return token == null ? null : User.from(JwtDecoder.decode(token));
  }

  SecuredStore._internal();
}

enum Strength {
  weak,
  medium,
  strong;

  factory Strength.from(num strength) {
    if (strength < 80) {
      return weak;
    }
    if (strength < 250) {
      return medium;
    }
    return strong;
  }
}

enum Regex {
  /////////////////////////////////////////////////////////////
  ///                                                       ///
  ///    https://github.com/dart-lang/sdk/issues/27613      ///
  ///    use RegExp constant constructor when available     ///
  ///                                                       ///
  /////////////////////////////////////////////////////////////

  username(r'^[a-zA-Z][a-zA-Z0-9_\.]+$'),
  password(r'.{8,32}'),
  email(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final String _value;

  bool hasMatch(String? value) {
    return value != null && RegExp(_value).hasMatch(value);
  }

  const Regex(this._value);
}
