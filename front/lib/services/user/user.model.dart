class User {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String? picture;

  const User(
      {required this.id,
      required this.username,
      required this.email,
      this.phone,
      this.picture});

  static User from(Map<String, dynamic> data) => User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      phone: data['phone'],
      picture: data['picture']);
}
