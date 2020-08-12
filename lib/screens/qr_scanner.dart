import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenScanner extends StatefulWidget {

  @override
  _ScreenScanner createState() => _ScreenScanner();
}

class _ScreenScanner extends State<ScreenScanner> {
  String barCode = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: scan,
                  child: const Text('START CAMERA SCAN')
              ),
            )
            ,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(barCode, textAlign: TextAlign.center,),
            )
            ,
          ],
        ),
      ),
    );
  }

  Future scan() async {
    try {
      ScanResult barCode = await BarcodeScanner.scan();
      print([barCode, '<<<<<<<<<<<>ASD>SA>DSA>F>SA>FSA>FS>']);
      setState(() {
        this.barCode = barCode.toString();
      });
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