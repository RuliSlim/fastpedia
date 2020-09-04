import 'package:auto_size_text/auto_size_text.dart';
import 'package:commons/commons.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/history.dart';
import 'package:fastpedia/screens/history_keluar.dart';
import 'package:fastpedia/services/number_extension.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  @override
  _History createState() => _History();
}

class _History extends State<History> {
  List<HistoryVideo> historyVideo;
  List<HistoryPoint> historyPoint;
  List<HistoryKeluar> historyKeluar;
  List<HistoryKeluar> historyMasuk;

  List<String> category = ["Riwayat Nonton", "Riwayat Transaksi Masuk", "Riwayat Transaksi Keluar"];

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WebService webService = Provider.of<WebService>(context, listen: false);
      Map<String, dynamic> response = await webService.getHistory();
      setState(() {
        historyVideo = response['dataVideo'];
        historyPoint = response['dataPoint'];
        historyKeluar = response['dataKeluar'];
        historyMasuk = response['dataMasuk'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (historyPoint == null) {
      return Scaffold(
        body: loadingScreen(context, loadingType: LoadingType.JUMPING)
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: Responsive.width(100, context),
            color: Hexcolor("#F6FAF5"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (var i in category) Padding(
                  padding: EdgeInsets.all(5),
                  child: createCategory(title: i),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Container createCategory ({String title}) {
    return Container(
      width: Responsive.width(90, context),
      height: Responsive.height(15, context),
      child: Card(
        elevation: 5,
        child: InkWell(
          onTap: () {
            if(title.contains("Keluar")) {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => new ScreenHistoryKeluar(historyKeluar: historyKeluar, type: "Keluar",)));
            }

            if(title.contains("Masuk")) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => new ScreenHistoryKeluar(historyKeluar: historyMasuk, type: "Masuk")
              ));
            }

            if (title.contains("Nonton")) {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => new ScreenHistoryKeluar(historyPoint: historyPoint, type: "Nonton")
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      title,
                      maxFontSize: 50,
                      minFontSize: 30,
                    ),
                    AutoSizeText(
                      "Lihat detail $title",
                      maxFontSize: 20,
                      minFontSize: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container createCard ({double point, String date}) {
    return Container(
      width: Responsive.width(90, context),
      height: Responsive.height(15, context),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    "Reward Point",
                    maxFontSize: 50,
                    minFontSize: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(MaterialCommunityIcons.calendar),
                      AutoSizeText(
                        ParseDate(date).parseDate(),
                        maxFontSize: 20,
                        minFontSize: 10,
                      )
                    ],
                  )
                ],
              ),
              AutoSizeText(
                point.toString(),
                maxFontSize: 50,
                minFontSize: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}