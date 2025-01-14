class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  Map<String, dynamic> toMapUser() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }
}
