import 'package:fastpedia/main.dart';
import 'package:fastpedia/screens/discover_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionEarnPoint extends StatefulWidget {
  final String title;
  final String description;
  final String icon;

  const OptionEarnPoint({Key key, this.title, this.description, this.icon}) : super(key: key);
  @override
  createState() => _OptionEarnPoint();
}

class _OptionEarnPoint extends State<OptionEarnPoint> {
  @override
  Widget build(BuildContext context) {
    final _title = widget.title;
    final _description = widget.description;
    // TODO: implement build
    return InkWell(
      onTap: () {
        if (widget.title == "Youtube") {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => new WatchVideo()
          ));
        }
      },
      child: SingleChildScrollView(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(Responsive.width(5, context)),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Image.network(
                    widget.icon,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: Responsive.width(5, context),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Text(
                        _title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                      Text(
                        _description,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}