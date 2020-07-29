import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(32, 150, 83, 1),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Color.fromRGBO(32, 150, 83, 1),
            height: Responsive.height(2, context),
            width: Responsive.width(100, context),
          ),
          Container(
            // color: Color.fromRGBO(32, 150, 83, 0.6),
            height: Responsive.height(25, context),
            width: Responsive.width(100, context),
            padding: EdgeInsets.all(20),
            child: Image(
              image: AssetImage('Fast-logo.png'),
            ),
          ),
          Container(
            width: Responsive.width(80, context),
            child: TextField(
              obscureText: false,
              decoration: InputDecoration(labelText: 'username'),
            ),
            margin: EdgeInsets.only(top: 5),
          ),
          Container(
            width: Responsive.width(80, context),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'password'),
            ),
            margin: EdgeInsets.only(top: 5),
          ),
          Container(
            width: Responsive.width(80, context),
            child: RaisedButton(
              onPressed: null,
              child: Text('Login'),
            ),
            margin: EdgeInsets.only(top: 15),
          ),
          Container(
            color: Color.fromRGBO(32, 150, 83, 1),
            height: Responsive.height(25, context),
            margin: EdgeInsets.only(top: 53),
            width: Responsive.width(100, context),
          )
        ],
      ),
    );
  }
}

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height * (p / 100);
  }
}

class ApiService {
  final String _baseUrl = 'https://quote-garden.herokuapp.com';
  // final htto
//   static var shared = ApiService();
  void loginUser() {
    // http.Response response = await http.post(
    //   url: 'https://example.com',
    //   headers: {"Content-Type": "application/json"},
    //   body: body,
    // );
  }

  Future login() async {
    http.Response response = await http.post(
      url: 'https://example.com',
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }
}

class UserLogin {
  final int id;
  final String username;
  final String token;

  const UserLogin({this.id, this.username, this.token});
}
