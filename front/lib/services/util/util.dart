import 'dart:math';

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
  email(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"),
  id(r"[a-zA-Z0-9\-]+"),
  ask(r"ask");

  final String value;

  bool hasMatch(String? value) {
    return value != null && RegExp(this.value).hasMatch(value);
  }

  const Regex(this.value);
}

// file size to human readable string
String fileSize(int size) {
  if (size < 1024) {
    return '$size B';
  }
  if (size < 1024 * 1024) {
    return '${(size / 1024).toStringAsFixed(2)} KB';
  }
  if (size < 1024 * 1024 * 1024) {
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
  return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
