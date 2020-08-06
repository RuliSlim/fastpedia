import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


// Dashboard
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Future userFuture;
  Future<User> getUserData() => UserPreferences().getUser();

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _myController;

  String isSubscribe;

  Future<String> getDom () async {
    String data = await _myController.evaluateJavascript("document.querySelectorAll(\"button.c3-material-button-button\")[5].innerText");
    setState(() {
      isSubscribe = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }


  @override
  Widget build(BuildContext context) {

    final webView = Stack(
      children: <Widget>[
        Positioned(
          top: -Responsive.height(6, context),
          height: Responsive.height(100, context),
          width: Responsive.width(100, context),
          child: WebView(
            initialUrl: 'https://m.youtube.com/watch?v=_uQrJ0TkZlc',
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              _myController = webViewController;
            },
            onPageFinished: (url) {
              _myController.evaluateJavascript('document.querySelectorAll(".scwnr-content")[2].style.display="none";');
              _myController.evaluateJavascript('document.querySelectorAll(".scwnr-content")[3].style.display="none";');
              _myController.evaluateJavascript('document.querySelectorAll(".mobile-topbar-header.cbox")[0].style.display="none";');
            },
          ),
        ),
      ],
    );

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
        ),
      floatingActionButton: _subsAction(),
    );
  }

  _subsAction() {
    return FloatingActionButton(
      onPressed: () async {
        var hasil = getDom();
        hasil.then((value) {
          print(isSubscribe.length);
          if (isSubscribe.length == 13) {
            Flushbar(
              title: 'Failed!',
              message: 'You Have To Subscribe!',
              duration: Duration(seconds: 3),
            ).show(context);
          } else {
            Flushbar(
              title: 'Congrats!',
              message: 'You Earn Point!',
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      },
      child: Icon(Icons.save),
    );
  }
}
