import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fastpedia/model/error_handling.dart';
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
  static const baseUrl = "http://192.168.100.11:8000/fast-mobile";
  static const loginUrl = "$baseUrl/login/";
  static const registerUrl = "$baseUrl/register-mobile/";
  static const updateUrl = "$baseUrl/update-user-mobile/";

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredStatus => _registeredStatus;

  Future<Map<String, dynamic>> signIn({String username, String password}) async {
    var result;

    final Map<String, dynamic> logInData = {
      'username': username.toUpperCase(),
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

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
      final User user = User.fromJson(responseData);
      UserPreferences().saveUser(user);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': user};
    } on DioError catch (e) {
      print(e.response.data);
      if (e.response != null) {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'username or password invalid'};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'username or password invalid'};
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> register({String name, String email, String nik, String phone, String username, String password}) async {
    var result;

    try {
      final Map<String, dynamic> registerData = {
        'name': name,
        'email': email,
        'id_number': nik,
        'phone': phone,
        'username': username.toUpperCase(),
        'password': password,
        'referral_by': 24
      };

      print([registerData, '<<<<<<<<SADSDSA']);

      _loggedInStatus = Status.Authenticating;
      notifyListeners();

      final response = await dio.post(
          registerUrl,
          data: jsonEncode(registerData),
          options: Options(
            headers: {
              'Content-Type': 'application/json'
            },
          )
      );

      final responseData = response.data;
      final SuccessRegisterAndUpdate user = SuccessRegisterAndUpdate.fromJson(responseData);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': user.message, 'user': user};
    } on DioError catch (e) {
      print([e.response, e.response.data, "<<<<<<<<<<?"]);
      if (e.response.statusCode == 400) {
        final ErrorHandling error = ErrorHandling.fromJson(e.response.data);
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': error.message};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'Server is on maintenance'};
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> update({String name, String email, String nik, String phone}) async {
    var result;

    try {
      final Map<String, dynamic> updateData = {
        'name': name,
        'email': email,
        'id_number': nik,
        'phone': phone,
        'referral_by': 24
      };

      print([updateData, '<<<<<<<<SADSDSA']);

      _loggedInStatus = Status.Authenticating;
      notifyListeners();

      final token = await UserPreferences().getToken();
      print([token, '<<<<<<<<<<<<']);

      final response = await dio.post(
          updateUrl,
          data: jsonEncode(updateData),
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'authorization': 'Token $token'
            },
          )
      );

      final responseData = response.data;
      final SuccessRegisterAndUpdate user = SuccessRegisterAndUpdate.fromJson(responseData);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      final oldUser = await UserPreferences().getUser();

      oldUser.email = email;
      oldUser.phone = phone;

      final updateUser = await UserPreferences().saveUser(oldUser);

      result = {'status': true, 'message': user.message, 'user': user};
    } on DioError catch (e) {
      print([e.response, e.response.data, "<<<<<<<<<<?"]);
      if (e.response.statusCode == 400) {
        final SerializerHandling error = SerializerHandling.fromJson(e.response.data);

        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();

        List<String> messages = [];

        if (error.email != null) {
          messages.add("email sudah terdaftar");
        }

        if (error.phone != null) {
          messages.add("no hp sudah terdaftar");
        }

        if (error.password != null) {
          messages.add("password tidak valid");
        }

        String showErrorMessage = "";

        messages.asMap().forEach((index, value) {
          showErrorMessage += "${1 + index }. $value.\n";
        });

        result = {'status': false, 'message': showErrorMessage};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': 'Server is on maintenance'};
      }
    }
    return result;
  }
}