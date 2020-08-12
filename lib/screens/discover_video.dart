import 'package:fastpedia/components/tab_bar.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


// Dashboard
class WatchVideo extends StatefulWidget {
  final VoidCallback onTimeAndSubSuccess;
  final VoidCallback onNextVideo;

  WatchVideo({Key key, this.onTimeAndSubSuccess, this.onNextVideo}) : super(key: key);

  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  // States
  Future userFuture;
  Future<User> getUserData() => UserPreferences().getUser();
  String urlVideo = 'https://m.youtube.com/watch?v=_uQrJ0TkZlc';
  bool isDone = false;

  // wkwebViewController
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _myController;

  // appWebViewControoler
  InAppWebViewController _inAppWebViewController;

  // dataDom
  String isSubscribe;
  Future<String> getDom () async {
    String data = await _inAppWebViewController.evaluateJavascript(source: "document.querySelectorAll(\"button.c3-material-button-button\")[5].innerText");
    setState(() {
      isSubscribe = data;
    });
    return data;
  }

  // countdown timer;
  Timer _timerCheck;
  int _time = 10;
  bool isDoneLoadWeb = false;
  bool isPlayingVideo = false;

  void countDown() {
    if (isPlayingVideo && _timerCheck.isActive) {
      setState(() {
        _time -= 1;
      });
    }
  }

  void checkIfPlay() {
    const oneSec = Duration(seconds: 1);
    _timerCheck = new Timer.periodic(oneSec, (timer) {
      if (isDoneLoadWeb) {
        var player = _inAppWebViewController.evaluateJavascript(source: 'document.getElementById("movie_player").classList.contains("playing-mode");');
        player.then((value) {
          setState(() {
            isPlayingVideo = value;
          });
          countDown();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //checkIfPlay();
  }

  @override
  Widget build(BuildContext context) {
    // inappwebvie
    Stack inAppwebView = Stack(
      children: <Widget>[
        Positioned(
          top: -Responsive.height(6, context),
          height: Responsive.height(100, context),
          width: Responsive.width(100, context),
          child: InAppWebView(
            initialUrl: urlVideo,
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: false,
                    mediaPlaybackRequiresUserGesture: false,
                    javaScriptEnabled: true,
                    useShouldInterceptAjaxRequest: true
                )
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _inAppWebViewController = controller;
            },
            onLoadStop: (InAppWebViewController controller, String url) {
              controller.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[2].style.display="none";');
              controller.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[3].style.display="none";');
              controller.evaluateJavascript(source: 'document.querySelectorAll(".mobile-topbar-header.cbox")[0].style.display="none";');
              setState(() {
                isDoneLoadWeb = true;
              });
              checkIfPlay();
            },
          ),
        ),
      ],
    );

    return Scaffold(
      body: inAppwebView,
      floatingActionButton: _containerButton(),
    );
  }

  dynamic _containerButton() {
    if (_time > 0) {
      return _countDown();
    }
    if (isDone && _time < 1) {
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
          if (isSubscribe.length == 10) {
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
          _time = 10;
        });
        _timerCheck.cancel();
        //_myController.loadUrl(urlVideo);
        _inAppWebViewController.loadUrl(url: urlVideo);
      },
    );
  }
}
