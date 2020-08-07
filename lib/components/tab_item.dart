import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabItem extends StatefulWidget {
  TabItem({
    @required this.selected,
    @required this.iconData,
    @required this.title,
    @required this.callBackFunction
  });

  String title;
  IconData iconData;
  bool selected;
  Function callBackFunction;

  @override
  _TabItemState createState() => _TabItemState();
}

const double ICON_OFF = -3;
const double ICON_ON = 0;
const double TEXT_OFF = 3;
const double TEXT_ON = 1;
const double ALPHA_OFF = 0;
const double ALPHA_ON = 1;
const int ANIM_DURATION = 300;
const Color PURPLE = Color(0xFF8c77ec);

class _TabItemState extends State<TabItem> {

  double iconYAlign = ICON_ON;
  double textYAlign = TEXT_OFF;
  double iconAlpha = ALPHA_ON;

  @override
  void initState() {
    super.initState();
    _setIconAlpha();
  }

  @override
  void didUpdateWidget(TabItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setIconAlpha();
  }

  _setIconAlpha() {
    setState(() {
      iconYAlign = (widget.selected) ? ICON_OFF : ICON_ON;
      iconAlpha = (widget.selected) ? ALPHA_OFF : ALPHA_ON;
      textYAlign = (widget.selected) ? TEXT_ON : TEXT_OFF;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              alignment: Alignment(0, textYAlign),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            )
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
              duration: Duration(milliseconds: ANIM_DURATION),
              alignment: Alignment(0, iconYAlign),
              child: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                padding: EdgeInsets.all(0),
                alignment: Alignment(0, 0),
                icon: Icon(
                  widget.iconData,
                  color: PURPLE,
                ),
                onPressed: () {
                  widget.callBackFunction();
                },
              ),
            ),
          )
        ],
      )
    );
  }
}