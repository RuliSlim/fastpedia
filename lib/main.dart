import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebService()),
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        title: 'Fastpedia',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.token == null)
                    return LoginPage();
                  else
                    UserPreferences().removeUser();
                  return Welcome();
              }
            }
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/dashboard': (context) => DashBoard(),
        },
      ),
    );
  }
}

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

//      if (form.validate()) {
//        form.save();
        print([_username, _password, "ini form nih"]);

        final Future<Map<String, dynamic>> successfulMessage =
        webService.signIn(username: _username, password: _password);

        successfulMessage.then((response) {
          print([response, "ini response ansfnfa"]);
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else {
            Flushbar(
              title: "Failed Login",
              message: response['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
//      } else {
//        print('Form invalid');
//      }
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
//                try {
                  doLogin();
//                  final response = WebService().signIn(username: usernameController.text, password: passwordController.text);
//                  print(response);
//                } catch (e) {
//                  print([e, 'ini catch error']);
//                }
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

//TextEditingController

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

  static ApiService _instance = new ApiService.internal();
  ApiService.internal();

  factory ApiService() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();
}

// welcome page
class Welcome extends StatelessWidget {
  final User user;

  Welcome({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Provider.of<UserProvider>(context).setUser(user);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text("WELCOME ${user.username}"),
        ),
      ),
    );
  }
}

// Dashboard
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {

    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("DASHBOARD PAGE"),
        elevation: 0.1,
      ),
      body: Column(
        children: [
          SizedBox(height: 100,),
          Center(child: Text(user.username)),
          SizedBox(height: 100),
          RaisedButton(onPressed: (){}, child: Text("Logout"), color: Colors.lightBlueAccent,)
        ],
      ),
    );
  }
}