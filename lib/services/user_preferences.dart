import 'package:fastpedia/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<void> saveUser(User user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setInt('id', user.id);
    pref.setString('username', user.username);
    pref.setString('token', user.token);
    pref.setString('role', user.role);
    pref.setString('name', user.name);
    pref.setString('email', user.email);
    pref.setString('nik', user.nik);
    pref.setString('phone', user.phone);
  }

  Future<User> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    int id = pref.get('id');
    String username = pref.get('username');
    String token = pref.get('token');
    String role = pref.get('role');
    String name = pref.get('name');
    String email = pref.get('email');
    String nik = pref.get('nik');
    String phone = pref.get('phone');

    return User(
      id: id,
      username: username,
      token: token,
      role: role,
      name: name,
      email: email,
      nik: nik,
      phone: phone
    );
  }

  void removeUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove('id');
    pref.remove('username');
    pref.remove('token');
    pref.remove('role');
    pref.remove('name');
    pref.remove('email');
    pref.remove('nik');
    pref.remove('phone');
  }

  Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }
}