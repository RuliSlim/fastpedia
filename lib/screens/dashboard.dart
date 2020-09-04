import 'package:auto_size_text/auto_size_text.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/points.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

    final Column adsPoin = Column(
      children: [
        Image(image: AssetImage('ads_poin.png'),),
        AutoSizeText(
          "ADS Point"
        ),
        AutoSizeText(
          _adsPoint != null ? _adsPoint.toStringAsFixed(2) : "0.0"
        )
      ],
    );

    final Column voucher = Column(
      children: [
        Image(image: AssetImage('voucher_icon.png'),),
        AutoSizeText(
            "Voucher"
        ),
        AutoSizeText(
            _voucher != null ? _voucher.toStringAsFixed(2) : "0.0"
        )
      ],
    );

    final Column pedPoint = Column(
      children: [
        Image(image: AssetImage('ped_poin_icon.png'),),
        AutoSizeText(
            "PED Point"
        ),
        AutoSizeText(
            _pedPoint != null ? _pedPoint.toStringAsFixed(2) : "0.0"
        )
      ],
    );

    final Container wallet = Container(
      child: Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: adsPoin,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: voucher,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: pedPoint,
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('banner_1.png'),
              width: Responsive.width(100, context),
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: wallet,
            )
          ],
        ),
      ),
    );
  }
}