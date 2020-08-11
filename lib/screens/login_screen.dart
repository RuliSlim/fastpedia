import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  String _username, _password;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebService webService = Provider.of<WebService>(context);

    final usernameField = TextFormField(
      obscureText: false,
      autofocus: false,
      autocorrect: false,
      onSaved: (value) => _username = value,
      onChanged: (value) => _username = value,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person_outline),
        labelText: 'username',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );

    final passwordField = TextFormField(
      obscureText: false,
      autofocus: false,
      autocorrect: false,
      onSaved: (value) => _password = value,
      onChanged: (value) => _password = value,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        labelText: 'password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
    );

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text('Authenticating ... Please Wait')
      ],
    );


    // Login function when pressed
    var doLogin = () {
      final form = formKey.currentState;

      final Future<Map<String, dynamic>> successfulMessage =
      webService.signIn(username: _username, password: _password);

      successfulMessage.then((response) {
        if (response['status']) {
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Flushbar(
            title: "Failed Login",
            message: response['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: Color.fromRGBO(32, 150, 83, 1),
            height: Responsive.height(15, context),
            width: Responsive.width(100, context),
          ),
          Container(
            height: Responsive.height(30, context),
            width: Responsive.width(100, context),
            padding: EdgeInsets.all(20),
            child: Image(
              image: AssetImage('Fast-logo.png'),
            ),
          ),
          Container(
              width: Responsive.width(80, context),
              height: Responsive.height(5, context),
              child:
              usernameField
//            TextField(
//              obscureText: false,
//              decoration: InputDecoration(labelText: 'username'),
//              controller: usernameController,
//            ),
          ),
          Container(
              width: Responsive.width(80, context),
              height: Responsive.height(5, context),
              child:
              passwordField
//            TextField(
//              obscureText: true,
//              decoration: InputDecoration(labelText: 'password'),
//              controller: passwordController,
//            ),
          ),
          Container(
            width: Responsive.width(80, context),
            height: Responsive.height(5, context),
            child: RaisedButton(
              onPressed: () {
                doLogin();
              },
              child: Text('Login'),
            ),
          ),
          Container(
              color: Color.fromRGBO(32, 150, 83, 1),
              height: Responsive.height(25, context),
              width: Responsive.width(100, context)
          )
        ],
      ),
    );
  }
}
