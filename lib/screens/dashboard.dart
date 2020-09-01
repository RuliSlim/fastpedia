import 'package:auto_size_text/auto_size_text.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/points.dart';
import 'package:fastpedia/services/number_extension.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double _adsPoint;
  double _pedPoint;
  double _voucher;

  // comps;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WebService webService = Provider.of<WebService>(context, listen: false);
      Map<String, dynamic> response = await webService.getPoint();

      final Points points = response['data'];

      setState(() {
        _adsPoint = points.ads_point;
        _pedPoint = points.peds;
        _voucher = points.evoucher;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final adsPointContainer = Container(
      width: Responsive.width(80, context),
      decoration: BoxDecoration(
          color: Hexcolor("#34DE34"),
          borderRadius: new BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              _adsPoint != null ? Delimiters(_adsPoint).pointDelimiters() : "0.0",
              style: TextStyle(
                  color: Colors.white
              ),
              maxFontSize: 30,
              minFontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AutoSizeText(
                  "ADS POINT",
                  style: TextStyle(
                      color: Colors.white,
                  ),
                  maxFontSize: 30,
                  minFontSize: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );

    final voucherContainer = Container(
      width: Responsive.width(80, context),
      decoration: BoxDecoration(
          color: Hexcolor("#34DE34"),
          borderRadius: new BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              _voucher != null ? Delimiters(_voucher).pointDelimiters() : "0.0",
              style: TextStyle(
                  color: Colors.white
              ),
              maxFontSize: 30,
              minFontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AutoSizeText(
                  "VOUCHER",
                  style: TextStyle(
                      color: Colors.white,
                  ),
                  maxFontSize: 30,
                  minFontSize: 20,
                )
              ],
            ),
          )
        ],
      ),
    );

    final pedsContainer = Container(
      width: Responsive.width(80, context),
      decoration: BoxDecoration(
          color: Hexcolor("#34DE34"),
          borderRadius: new BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              _pedPoint != null ? Delimiters(_pedPoint).pointDelimiters() : "0.0",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white
              ),
              maxFontSize: 30,
              minFontSize: 20,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AutoSizeText(
                  "PEDS POINT",
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.white,
                  ),
                  maxFontSize: 30,
                  minFontSize: 20,
                )
              ],
            ),
          )
        ],
      ),
    );

    final buttonWallet = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          child: AutoSizeText(
            "Points",
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Hexcolor("#1E3B2A")
            ),
            maxFontSize: 20,
            minFontSize: 16,
          ),
          onPressed: () => setState(() => _isActive = !_isActive),
        ),
      ],
    );

    final container = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buttonWallet,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: adsPointContainer,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: voucherContainer,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: pedsContainer,
            )
          ],
        ),
      ],
    );

    final box = AnimatedContainer(
        duration: Duration(seconds: 3),
        curve: Curves.ease,
        width: Responsive.width(100, context),
        decoration: BoxDecoration(
            color: Hexcolor("#F2FFF2"),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        child: _isActive? container : buttonWallet
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image(image: AssetImage('fast-logo-fix.png'),),
            ),
            box
          ],
        ),
      ),
    );
  }

}