import 'package:fastpedia/components/tab_bar.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


// Dashboard
class DashBoard extends StatefulWidget {
  final VoidCallback onTimeAndSubSuccess;
  final VoidCallback onNextVideo;

  DashBoard({Key key, this.onTimeAndSubSuccess, this.onNextVideo}) : super(key: key);

//  final String text;
//  final customFunction;
//  MyChildExample({Key key, this.text, this.customFunction}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // States
  Future userFuture;
  Future<User> getUserData() => UserPreferences().getUser();
  String urlVideo = 'https://m.youtube.com/watch?v=_uQrJ0TkZlc';
  bool isDone = false;

  // wkwebViewController
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _myController;

  // dataDom
  String isSubscribe;
  Future<String> getDom () async {
    String data = await _myController.evaluateJavascript("document.querySelectorAll(\"button.c3-material-button-button\")[5].innerText");
    setState(() {
      isSubscribe = data;
    });
    return data;
  }

  Timer _timer;
  int _time = 3;

  void countDown() {
    const oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (_time < 1) {
          timer.cancel();
        } else {
          _time -= 1;
        }
      });
    });
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
            initialUrl: urlVideo,
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
              countDown();
            },
          ),
        ),
      ],
    );

    return Scaffold(
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
      floatingActionButton: _containerButton(),
    );
  }

  dynamic _containerButton() {
    if (_time > 0) {
      return _countDown();
    }
    if (isDone && _time == 0) {
      return _nextVideoButton();
    } else {
      return _subsAction();
    }
  }

  FloatingActionButton _countDown() {
    return FloatingActionButton(
        onPressed: () async {
          Flushbar(
            title: 'Error',
            message: 'You have to watch $_time',
            duration: Duration(seconds: 3),
          ).show(context);
        },
        child: Text('$_time')
    );
  }

  FloatingActionButton _subsAction() {
    return FloatingActionButton(
      onPressed: () async {
        var hasil = getDom();
        hasil.then((value) {
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
            widget.onTimeAndSubSuccess();
            setState(() {
              isDone = true;
            });
          }
        });
      },
      child: Icon(Icons.save),
    );
  }

  FloatingActionButton _nextVideoButton() {
    return FloatingActionButton(
      child: Icon(Icons.navigate_next),
      onPressed: () {
        widget.onNextVideo();
        setState(() {
          urlVideo = 'https://m.youtube.com/watch?v=H5-e6M7SjL8';
          isDone = false;
        });
        _myController.loadUrl(urlVideo);
      },
    );
  }
}
