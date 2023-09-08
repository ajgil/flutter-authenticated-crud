// los usuarios de la app

class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> roles;
  final String token;

  User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.roles,
      required this.token});

  // getter
  bool get isAdmin {
    return roles.contains('admin');
  }
}
