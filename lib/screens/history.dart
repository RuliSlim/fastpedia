import 'package:auto_size_text/auto_size_text.dart';
import 'package:commons/commons.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/history.dart';
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

  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WebService webService = Provider.of<WebService>(context, listen: false);
      Map<String, dynamic> response = await webService.getHistory();
      setState(() {
        historyVideo = response['dataVideo'];
        historyPoint = response['dataPoint'];
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

    final Container containerCard = Container(
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
                        "date",
                        maxFontSize: 20,
                        minFontSize: 10,
                      )
                    ],
                  )
                ],
              ),
              AutoSizeText(
                "0",
                maxFontSize: 50,
                minFontSize: 30,
              )
            ],
          ),
        ),
      ),
    );

    // TODO: implement build
    if (historyPoint == null) {
      return Scaffold(
        body: Center(
          child: containerCard,
        ),
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
                for (var i in historyPoint) Padding(
                  padding: EdgeInsets.all(5),
                  child: createCard(date: i.created_at, point: i.poin_mining),
                )
              ],
            ),
          ),
        ),
      );
    }
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
                        date,
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