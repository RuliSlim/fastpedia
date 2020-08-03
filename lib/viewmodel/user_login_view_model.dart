import 'package:fastpedia/model/User.dart';

class UserViewModel {
  User _user;

  UserViewModel({User user}) : _user = user;

  String get username {
    return _user.username;
  }

  int get id {
    return _user.id;
  }

  String get token {
    return _user.token;
  }

  String get role {
    return _user.role;
  }
}