import 'package:fastpedia/screens/dashboard.dart';
import 'package:fastpedia/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>  with TickerProviderStateMixin{
  String titleAppBar = 'Profile';
  String tabSelected = 'Profile';
  MotionTabController _myTabController;
  bool isShown = true;

  @override
  void initState() {
    super.initState();
    _myTabController = MotionTabController(initialIndex: 1, vsync: this);
    _myTabController.length = 2;
  }

  @override
  void dispose() {
    super.dispose();
    _myTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Method
    void onPressedTabBar (int value) {
      setState(() {
        _myTabController.index = value;
        switch (value) {
          case 0: {
            titleAppBar = 'Discover';
            isShown = false;
          }
          break;
          default: {
            titleAppBar = 'Profile';
            isShown = true;
          }
          break;
        }
      });
    }

    // Widgets
    AppBar appBar = AppBar(
      title: Text(titleAppBar),
      elevation: 0.0,
      centerTitle: true,
    );

    MotionTabBar myMotionTabBar = MotionTabBar(
      labels: [ 'Discover', 'Profile' ],
      tabSelectedColor: Colors.green,
      tabIconColor: Colors.red,
      initialSelectedTab: tabSelected,
      textStyle: TextStyle(color: Colors.amberAccent),
      onTabItemSelected: (int value) {
        print([value, '<<<<<<<<<<<<SAFSFAFFSDS>>>>>.']);
        onPressedTabBar(value);
      },
      icons: [
        Icons.youtube_searched_for,
        Icons.person
      ],
    );

    // Method
    dynamic tabBarShown () {
      if (isShown) {
        return myMotionTabBar;
      } else {
        return null;
      }
    }

    void onTimeAndSubSuccess () {
      setState(() {
        isShown = true;
        tabSelected = 'Discover';
      });
    }

    void onNextVideo () {
      setState(() {
        isShown = false;
      });
    }

    // TODO: implement build
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: tabBarShown(),
      body: MotionTabBarView(
        controller: _myTabController,
        children: <Widget>[
          Container(
            child: DashBoard(onTimeAndSubSuccess: onTimeAndSubSuccess, onNextVideo: onNextVideo)
          ),
          Container(
            child: Profile(),
          ),
        ],
      ),
    );
  }
}