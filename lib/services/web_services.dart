import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class WebService with ChangeNotifier {
  var dio = new Dio();
  static const baseUrl = "http://192.168.100.42:8000/fast-mobile";
  static const loginUrl = "$baseUrl/login/";

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;

  Future<Map<String, dynamic>> signIn({String username, String password}) async {
    var result;
    bool isError = false;

    final Map<String, dynamic> logInData = {
      'username': username.toUpperCase(),
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    print([logInData, "sfusahfusa"]);
    try {
      final response = await dio.post(
          loginUrl,
          data: jsonEncode(logInData),
          options: Options(
            headers: {
              'Content-Type': 'application/json'
            },
          )
      );

      final responseData = response.data;
      print(responseData);
      final User user = User.fromJson(responseData);
      UserPreferences().saveUser(user);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': user};
    } on DioError catch(e) {
      if(e.response != null) {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'username or password invalid'};
      } else{
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'username or password invalid'};
      }
    }

    return result;
  }
}