import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class FancyTabBar extends StatefulWidget {
  @override
  _FancyTabBarState createState() => _FancyTabBarState();
}

class _FancyTabBarState extends State<FancyTabBar> with TickerProviderStateMixin {
  MotionTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MotionTabBar(
      labels: [
        'Home', 'Discover', 'Profile'
      ],
      initialSelectedTab: 'Discover',
      tabIconColor: Colors.amberAccent,
      tabSelectedColor: Colors.green,
      onTabItemSelected: (int value) {
        setState(() {
          _tabController.index = value;
        });
      },
      icons: [
        Icons.home, Icons.youtube_searched_for, Icons.person
      ],
    );
  }

}