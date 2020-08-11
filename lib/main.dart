import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/screens/dashboard.dart';
import 'package:fastpedia/screens/home.dart';
import 'package:fastpedia/screens/login_screen.dart';
import 'package:fastpedia/screens/profile.dart';
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
    userFuture.then((value) {
      if (value.username == null) {
        print('ini vaaal>>>>>>><<<<');
      } else {
        print('ini masuuuk njiiing');
      }
    });
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
                  return HomePage();
              }
            }
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/dashboard': (context) => DashBoard(),
          '/profile': (context) => Profile(),
          '/home': (context) => HomePage()
        },
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



