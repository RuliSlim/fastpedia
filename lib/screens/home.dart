import 'package:fastpedia/screens/discover_video.dart';
import 'package:fastpedia/screens/profile.dart';
import 'package:fastpedia/screens/qr_scanner.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
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

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _myTabController = MotionTabController(initialIndex: 2, vsync: this);
    _myTabController.length = 3;
  }

  @override
  void dispose() {
    _myTabController.dispose();
    super.dispose();
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
      labels: [ 'Discover', 'QR', 'Profile' ],
      tabSelectedColor: Colors.green,
      tabIconColor: Colors.red,
      initialSelectedTab: tabSelected,
      textStyle: TextStyle(color: Colors.amberAccent),
      onTabItemSelected: (int value) {
        onPressedTabBar(value);
      },
      icons: [
        Icons.youtube_searched_for,
        Icons.scanner,
        Icons.person
      ],
    );

    FlashyTabBar myFlashyTabBar = FlashyTabBar(
      selectedIndex: _selectedIndex,
      animationCurve: Curves.bounceIn,
      showElevation: true,
      onItemSelected: (value) => setState(() {
        _selectedIndex = value;
      }),
      items: [
        FlashyTabBarItem(
          icon: Icon(Icons.youtube_searched_for),
          title: Text("Discovery")
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.scanner),
          title: Text("QR")
        ),
        FlashyTabBarItem(
          icon: Icon(Icons.person),
          title: Text("Profile")
        )
      ],
    );

    // Method
    dynamic tabBarShown () {
      if (isShown) {
        return Visibility(
          child: myMotionTabBar,
          visible: true,
        );
      } else {
        return Visibility(
          child: myMotionTabBar,
          visible: false,
        );
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
            child: WatchVideo(onTimeAndSubSuccess: onTimeAndSubSuccess, onNextVideo: onNextVideo)
          ),
          Container(
            child: ScreenScanner(),
          ),
          Container(
            child: Profile(),
          ),
        ],
      ),
    );
  }
}