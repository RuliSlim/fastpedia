import 'package:auto_size_text/auto_size_text.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/history.dart';
import 'package:fastpedia/services/number_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';

class ScreenHistoryKeluar extends StatefulWidget {
  final List<HistoryKeluar> historyKeluar;
  final String type;
  final List<HistoryPoint> historyPoint;

  ScreenHistoryKeluar({this.historyKeluar, this.type, this.historyPoint});

  @override
  _ScreenHistoryKeluar createState () => _ScreenHistoryKeluar(historyKeluar, type, historyPoint);
}

class _ScreenHistoryKeluar extends State<ScreenHistoryKeluar> {
  List<HistoryKeluar> historyKeluar;
  String type;
  List<HistoryPoint> historyPoint;

  _ScreenHistoryKeluar(this.historyKeluar, this.type, this.historyPoint);

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Column nonton;
    Column trans;

    if (historyKeluar != null) {
      trans = Column(
        children: [
          for (var i in historyKeluar) createCard(
              title: i.tipe == "evoucher" ? "Voucher" : ParseDate(i.tipe).capital(),
              point: i.nominal,
              date: i.created_at,
              username: type == "Masuk" ? i.sender_username : i.receiver_username
          )
        ],
      );
    }

    if (historyPoint != null) {
      nonton = Column(
        children: [
          for (var i in historyPoint) createCard(
              title: "",
              username: "",
              date: i.created_at,
              point: i.poin_mining
          )
        ],
      );
    }


    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            type == "Nonton" ? "Riwayat Nonton" : "Riwayat Transaki $type",
            style: TextStyle(
                color: Hexcolor("#FFFFFF"),
                fontSize: 20,
                fontWeight: FontWeight.w700
            ),
          ),
          centerTitle: false,
          backgroundColor: Hexcolor("#4EC24C"),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: type == "Masuk" || type == "Keluar" ? trans : nonton
          ),
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
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AutoSizeText(
                    type == "Nonton" ? "Reward Point" : "Transfer $title",
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
                      ),
                      AutoSizeText(
                        type == "Nonton" ? "" : username,
                        style: TextStyle(
                            color: type == "Masuk" || type == "Nonton" ? Hexcolor("#4CAF50") : Hexcolor("#F44336")
                        ),
                        maxFontSize: 20,
                        minFontSize: 10,
                      )
                    ],
                  )
                ],
              ),
              AutoSizeText(
                type == "Masuk" || type == "Nonton" ? "+" + point.toString() : "-" + point.toString(),
                style: TextStyle(
                    color: type == "Masuk" || type == "Nonton" ? Hexcolor("#4CAF50") : Hexcolor("#F44336")
                ),
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