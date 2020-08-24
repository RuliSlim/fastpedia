import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

import 'package:smooth_star_rating/smooth_star_rating.dart';

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
  String urlVideo = 'https://m.youtube.com/watch?v=x62eLEaRWo8';
  bool isDone = false;

  // appWebViewControoler
  InAppWebViewController _inAppWebViewController;

  // dataDom
  String isSubscribe;
  Future<String> getDom () async {
    String data = await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("ytm-subscribe-button-renderer")[0].childNodes[0].childNodes[0].childNodes[0].getAttribute("aria-pressed");');
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

  // rating for videos
  double _rating = 3.0;
  String _comments = "Cukup bagus!";

  void countDown() {
    if (isPlayingVideo && _timerCheck.isActive) {
      var data = _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("button.icon-button").length');
      data.then((value) {
        if (value >= 20) {
          _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("button.icon-button")[3].style.display="none";');
        }
      });
      setState(() {
        _time -= 1;
      });
    }
  }

  void checkIfPlay() {
    const oneSec = Duration(seconds: 1);
    _timerCheck = new Timer.periodic(oneSec, (timer) {
      if (isDoneLoadWeb && _time >= 1) {
        var player = _inAppWebViewController.evaluateJavascript(source: 'document.getElementById("movie_player").classList.contains("playing-mode");');
        player.then((value) {
          setState(() {
            isPlayingVideo = value;
          });
          countDown();
        });
      } else {
        _timerCheck.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timerCheck != null) {
      _timerCheck.cancel();
    }
    super.dispose();
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
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                  mediaPlaybackRequiresUserGesture: false
                )
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _inAppWebViewController = controller;
            },
            onLoadStop: (InAppWebViewController controller, String url) {
              modifyDom();
              setState(() {
                isDoneLoadWeb = true;
              });
              checkIfPlay();
            },
          ),
        ),
      ],
    );

    // fields for review
    // stars for rating
    // comment for review
    SmoothStarRating starRating = SmoothStarRating(
      rating: _rating,
      isReadOnly: false,
      size: 30,
      filledIconData: Icons.star,
      halfFilledIconData: Icons.star,
      allowHalfRating: true,
      starCount: 5,
      spacing: 2.0,
      onRated: (double value) {
        setState(() {
          switch (value.round()) {
            case 0:
              _comments = "Tidak menarik..";
              break;
            case 1:
              _comments = "Kurang menarik..";
              break;
            case 2:
              _comments = "Cukup menarik..";
              break;
            case 3:
              _comments = "Menarik..";
              break;
            case 4:
              _comments = "Sangat menarik..";
              break;
            default:
              _comments = "Sangat menarik sekali..";
              break;
          }
        });
      },
    );

    Text comments = Text(_comments, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),);

    // box container
    AnimatedContainer containerReview = AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30)
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Tinggalkan Review",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: Responsive.width(80, context),
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20
              ),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Colors.white,
                          width: 3
                      )
                  )
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: starRating,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: comments,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );


    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: inAppwebView,
          ),
          Expanded(
            flex: 2,
            child: containerReview,
          )
        ],
      ),
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
            message: 'You have to watch $_time s',
            duration: Duration(seconds: 3),
          ).show(context);
        },
        child: Text('$_time')
    );
  }

  FloatingActionButton _subsAction() {
    return FloatingActionButton(
      onPressed: () async {
        var result = getDom();
        result.then((value) {
          if (isSubscribe == "false") {
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
          urlVideo = 'https://m.youtube.com/watch?v=vlCgfLDeDwU';
          isDone = false;
          _time = 10;
        });
        _timerCheck.cancel();
        _inAppWebViewController.loadUrl(url: urlVideo);
      },
    );
  }

  // method
  void modifyDom() {
    _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[2].style.display="none";');
    _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[3].style.display="none";');
    _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".mobile-topbar-header.cbox")[0].style.display="none";');
    _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("ytm-comment-section-renderer.scwnr-content")[0].style.display="none";');
    _inAppWebViewController.evaluateJavascript(source: 'var parent = document.getElementsByTagName("ytm-slim-owner-renderer")[0]; '
        'var child = parent.getElementsByTagName("a");'
        'child[0].removeAttribute("href");'
    );
  }
}
