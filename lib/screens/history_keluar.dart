import 'package:auto_size_text/auto_size_text.dart';
import 'package:fastpedia/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HistoryKeluar extends StatefulWidget {
  @override
  _HistoryKeluar createState () => _HistoryKeluar();
}

class _HistoryKeluar extends State<HistoryKeluar> {
  List<HistoryKeluar> historyKeluar;

  void initState() {
    super.initState();
    final  Map<String, Object> receiveData = ModalRoute.of(context).settings.arguments;

    setState(() {
      historyKeluar = receiveData['data'];
    });

  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (HistoryKeluar i in historyKeluar) createCard(title: )
        ],
      )
    );
  }

  Container createCard ({double point, String date, String title, String username}) {
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
                    "Transfer $title",
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
                      ),
                      AutoSizeText(
                        username,
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