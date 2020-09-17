import 'package:fastpedia/components/options_earn_point.dart';
import 'package:fastpedia/model/option_earn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuOnPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final List<OptionModel> _title = [
      new OptionModel(title: "Youtube", description: "Dapatkan point dengan menonton youtube", icon: "https://cdn.pixabay.com/photo/2016/11/18/11/17/social-1834016_1280.png"),
      new OptionModel(title: "Instagram", description: "Dapatkan point dengan menonton instagram", icon: "https://cdn.pixabay.com/photo/2016/11/18/11/16/social-1834010_1280.png"),
      new OptionModel(title: "Ads", description: "Dapatkan point dengan menonton ads", icon: "https://cdn.pixabay.com/photo/2016/08/04/09/05/coming-soon-1568623_1280.jpg")
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (var i in _title) OptionEarnPoint(title: i.title, description: i.description, icon: i.icon,)
        ],
      )
    );
  }

}