import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


// Dashboard
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Future userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }

  Future<User> getUserData() => UserPreferences().getUser();

  @override
  Widget build(BuildContext context) {

    final webView = WebView(
      initialUrl: 'https://m.youtube.com/watch?v=5u3pZZ6uvDo',
      javascriptMode: JavascriptMode.unrestricted,
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      
    );


//    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        appBar: AppBar(
          title: Text("DASHBOARD PAGE"),
          elevation: 0.1,
        ),
        body: FutureBuilder(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return webView;
            } else {
              return Text('ga ada data');
            }
          },
        )
    );
  }


}