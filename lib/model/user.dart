class User {
  int id;
  String username;
  String token;
  String role;

  User({this.id, this.role, this.username, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      token: json['token'],
      role: json['role']
    );
  }
}

class SendUser {
  String username;
  String password;

  SendUser(String username, String password) {
    this.username = username;
    this.password = password;
  }
}