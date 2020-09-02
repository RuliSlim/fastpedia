import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScreenScanner extends StatefulWidget {

  @override
  _ScreenScanner createState() => _ScreenScanner();
}

class _ScreenScanner extends State<ScreenScanner> {
  String barCode = '';
  String _username;

  GlobalKey globalKey = new GlobalKey();


  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final ButtonTheme scanButton = ButtonTheme(
        minWidth: Responsive.width(90, context),
        height: Responsive.width(15, context),
        child: RaisedButton(
          child: AutoSizeText("Scan QR Code",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white
            ),
            maxFontSize: 30,
            minFontSize: 20,
          ),
          onPressed: () {
            scan();
          },
          padding: EdgeInsets.all(8),
          textColor: Colors.white,
          color: Hexcolor("#4EC24C"),
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Hexcolor("#4EC24C"))
          ),
        )
    );

    return Scaffold(
      backgroundColor: Hexcolor("#F6FAF5"),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: new BorderRadius.circular(20),
                    child: Image(
                      image: AssetImage("qr_bg.png"),
                      height: Responsive.height(50, context),
                      width: Responsive.width(100, context),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(20),
                        color: Colors.white
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: QrImage(
                            data: _username != null ? _username : "",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: scanButton,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUsername () async {
    User user = await UserPreferences().getUser();
    setState(() {
      _username = user.username;
    });
  }

  Future scan() async {
    try {
      ScanResult barCode = await BarcodeScanner.scan();
      setState(() {
        this.barCode = barCode.rawContent;
      });

      if (barCode.type == ResultType.Barcode) {
        Navigator.pushNamed(context, "/transfer", arguments: {"username": this.barCode.toUpperCase()});
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barCode = 'The user did not granted access to camera!';
        });
      } else {
        setState(() {
          this.barCode = 'Unknown Error: $e';
        });
      }
    } on FormatException {
      setState(() {
        this.barCode = 'null (User returned using the "back"-button before scanning anything. Result)';
      });
    } catch (e) {
      setState(() {
        this.barCode = 'Unknown Error: $e';
      });
    }
  }

}