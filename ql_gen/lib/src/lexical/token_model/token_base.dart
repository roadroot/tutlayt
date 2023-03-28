abstract class TokenBase {
  bool get isEmpty;

  final String name;

  const TokenBase({required this.name});

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    return other is TokenBase && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
