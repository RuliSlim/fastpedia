import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/screens/dashboard.dart';
import 'package:fastpedia/screens/login_screen.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}


class _MyApp extends State<MyApp> {
  Future userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }

  Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {

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
            future: userFuture,
            builder: (context, snapshot) {
              print([snapshot, "ini snapshot"]);

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  print([snapshot.data.username, 'ini default']);
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.token == null)
                    return LoginPage();
                  else
//                    UserPreferences().removeUser();
//                    Provider.of<UserProvider>(context, listen: false).setUser(snapshot.data.);
                  return DashBoard();
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

//TextEditingController

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height * (p / 100);
  }
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
          child: Text("WELCOME yo}"),
        ),
      ),
    );
  }
}


