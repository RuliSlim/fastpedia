import 'package:fastpedia/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}