import 'package:commons/commons.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/video.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:smooth_star_rating/smooth_star_rating.dart';

// Dashboard
class WatchVideo extends StatefulWidget {
  @override
  _WatchVideoState createState() => _WatchVideoState();
}

class _WatchVideoState extends State<WatchVideo> {
  // States
  String _urlVideo = "";
  bool _isDone = false;
  bool _isShowRating = false;
  bool _hasSubmit = false;

  // appWebViewControoler
  InAppWebViewController _inAppWebViewController;

  // dataDom
  String _isSubscribe;
  String _isSubscribe2;
  String _isSubscribe3;

  Future<String> getDom () async {
    String data = await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("ytm-subscribe-button-renderer")[0].childNodes[0].childNodes[0].childNodes[0].getAttribute("aria-pressed");');
    String data2 = await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("button.c3-material-button-button")[5].attributes[2].nodeValue;');
    String data3 = await _inAppWebViewController.evaluateJavascript(source: '''
    function result() {
      var data = document.querySelectorAll("button.c3-material-button-button")[5].innerText;
      if (data == "SUBSCRIBE") {
        return "SUBSCRIBE";
      } else {
        return "TAEK";
      }
    }    
    result();
    ''');
    setState(() {
      _isSubscribe = data;
      _isSubscribe2 = data2;
      _isSubscribe3 = data3;
    });
    return data;
  }

  // countdown timer;
  Timer _timerCheck;
  int _time = 300;
  bool _isDoneLoadWeb = false;
  bool _isPlayingVideo = false;
  
  // data video;
  DataVideo _dataVideo;
  bool _status;
  String _message;
  bool _isLoading = true;

  // rating for videos
  double _rating = 3.0;
  String _comments = "Cukup bagus!";

  // state block sub
  bool _viewed = false;
  bool _viewedFinal = true;

  void countDown() {
    if (_isPlayingVideo && _timerCheck.isActive) {
      var data = _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("button.icon-button").length');
      data.then((value) {
        if (value >= 20) {
          _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("button.icon-button")[3].style.display="none";');
        }
      });

      setState(() {
        _time -= 1;
      });

      if (_time <= 0) {
        setState(() {
          _viewed = true;
        });
      }
    }
  }

  void checkIfPlay() {
    const oneSec = Duration(seconds: 1);
    if (_timerCheck != null) {
      _timerCheck.cancel();
    }

    _timerCheck = new Timer.periodic(oneSec, (timer) {
      if (_isDoneLoadWeb && _time >= 1) {
        var player = _inAppWebViewController.evaluateJavascript(source: 'document.getElementById("movie_player").classList.contains("playing-mode");');
        player.then((value) {
          setState(() {
            _isPlayingVideo = value;
          });
          countDown();
        });
      } else {
        _timerCheck.cancel();
      }
    });
  }

  void getData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WebService webService = Provider.of<WebService>(context, listen: false);
      Map<String, dynamic> response = await webService.getVideo();
      _status = response['status'];


      if (_status) {
        _dataVideo = response['data'];

        setState(() {
          _urlVideo = _dataVideo.data.video;
          _isDone = false;
          _time = 300;
          _hasSubmit = false;
          _viewed = false;
          _viewedFinal = true;
        });

        if (_timerCheck != null) {
          _timerCheck.cancel();
        }
        if (_inAppWebViewController != null && _urlVideo != null) {
          _inAppWebViewController.loadUrl(url: _urlVideo);
        }
      } else {

        setState(() {
          _message = response['message'];
        });
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    if (_timerCheck != null) {
      _timerCheck.cancel();
    }
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
            initialUrl: _urlVideo,
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
                _isDoneLoadWeb = true;
              });
              checkIfPlay();
            },
          ),
        ),
        Positioned(
          top: Responsive.height(42, context),
          height: Responsive.height(_viewedFinal ? _viewed ? 0 : 100 : 100, context),
          width: Responsive.width(_viewedFinal ? _viewed ? 0 : 100 : 100, context),
          child: Container(
            color: Colors.transparent,
            height: Responsive.height(100, context),
          ),
        )
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
      allowHalfRating: false,
      color: Hexcolor("#0B8B53"),
      starCount: 5,
      spacing: 2.0,
      onRated: (double value) {
        setState(() {
          _rating = value == 0 ? 1 : value;
          switch (value.round()) {
            case 1:
              _comments = "Tidak menarik..";
              break;
            case 2:
              _comments = "Kurang menarik..";
              break;
            case 3:
              _comments = "Cukup menarik..";
              break;
            case 4:
              _comments = "Menarik..";
              break;
            case 5:
              _comments = "Sangat menarik..";
              break;
            default:
              _comments = "Tidak menarik";
              break;
          }
        });
      },
    );

    Text comments = Text(_comments, style: TextStyle(
        color: Hexcolor("#1E3B2A"),
        fontWeight: FontWeight.w900,
    ),);

    // box container
    AnimatedContainer containerReview = AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.ease,
      decoration: BoxDecoration(
          color: Hexcolor("#ADE7D6"),
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
                FlatButton(
                  child: Text("Tinggalkan Review",
                    style: TextStyle(
                        color: Hexcolor("#1E3B2A"),
                        fontWeight: FontWeight.w900,
                        fontSize: 20
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isShowRating = !_isShowRating;
                    });
                  },
                )
              ],
            ),
          ),
          Visibility(
            visible: _isShowRating,
            child: Expanded(
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
          ),
        ],
      ),
    );

    if (!_isLoading) {
      if (_status) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: _isShowRating ? 4 : 10,
                  child: inAppwebView,
                ),
                Expanded(
                  flex: 1,
                  child:containerReview,
                )
              ],
            ),
            floatingActionButton: _containerButton(),
          );
      } else {
        return Scaffold(
          body: Center(child: Text(_message)),
        );
      }
    } else {
      return Scaffold(
        body: loadingScreen(
          context,
          loadingType: LoadingType.SCALING
        ),
      );
    }
  }

  dynamic _containerButton() {
    if (!_viewed) {
      return _countDown();
    }

    if (_isDone && _viewed && _dataVideo.sisa_nonton >= 1 && _hasSubmit) {
      return _nextVideoButton();
    }

    if (!_hasSubmit && _viewed) {
      return _subsAction();
    }

  }

  Row _countDown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: Responsive.width(8, context)),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _viewed = false;
                _viewedFinal = true;
              });
              getData();
            },
            child: Icon(Icons.shuffle),
          ),
        ),
        FloatingActionButton(
            onPressed: () async {
              Flushbar(
                title: 'Error',
                message: 'You have to watch $_time s',
                duration: Duration(seconds: 3),
              ).show(context);
            },
            child: Text('$_time')
        ),
      ],
    );
  }

  FloatingActionButton _subsAction() {
    return FloatingActionButton(
      onPressed: () async {
        var result = getDom();
        result.then((value) {
          if (_isSubscribe == "false" || _isSubscribe2 == "false" || _isSubscribe3 == "SUBSCRIBE") {
            Flushbar(
              title: 'Failed!',
              message: 'You Have To Subscribe!',
              duration: Duration(seconds: 3),
            ).show(context);
          } else {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              WebService webService = Provider.of<WebService>(context, listen: false);
              Map<String, dynamic> response = await webService.saveVideo(idVideo: _dataVideo.data.id, rating: _rating);
              Flushbar(
                title: response['status'] ? 'Congrats!' : 'Failed',
                message: response['message'],
                duration: Duration(seconds: 3),
              ).show(context);
            });

            setState(() {
              _isDone = true;
              _hasSubmit = true;
              _viewedFinal = false;
            });
          }
        });
      },
      child: Icon(Icons.save),
    );
  }

  FloatingActionButton _nextVideoButton() {
    return FloatingActionButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text((_dataVideo.sisa_nonton - 1).toString()),
          Icon(Icons.navigate_next),
        ],
      ),
      onPressed: () {
        if (_timerCheck != null) {
          _timerCheck.cancel();
        }
        getData();
      },
    );
  }

  // method
  void modifyDom() async {
    await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[2].style.display="none";');
    await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".scwnr-content")[3].style.display="none";');
    await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll(".mobile-topbar-header.cbox")[0].style.display="none";');
    await _inAppWebViewController.evaluateJavascript(source: 'document.querySelectorAll("ytm-comment-section-renderer.scwnr-content")[0].style.display="none";');
    await _inAppWebViewController.evaluateJavascript(source: 'var parent = document.getElementsByTagName("ytm-slim-owner-renderer")[0]; '
        'var child = parent.getElementsByTagName("a");'
        'child[0].removeAttribute("href");'
    );
    double _duration = await _inAppWebViewController.evaluateJavascript(source: 'document.querySelector(".video-stream").getDuration()');

    setState(() {
      _time = _duration.floor() - 3;
    });
  }
}
