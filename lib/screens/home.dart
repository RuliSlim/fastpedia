import 'package:fastpedia/main.dart';
import 'package:fastpedia/screens/dashboard.dart';
import 'package:fastpedia/screens/discover_video.dart';
import 'package:fastpedia/screens/history.dart';
import 'package:fastpedia/screens/profile.dart';
import 'package:fastpedia/screens/qr_scanner.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>  with TickerProviderStateMixin{
  String titleAppBar = 'Home';
  String tabSelected = 'Home';
  bool isShown = true;
  bool changePassword = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  Map<String, Object> receiveData = ModalRoute.of(context).settings.arguments;

    if (receiveData != null && receiveData["type"] == "profile") {
      setState(() {
        _selectedIndex = 4;
      });
    }

    // Method
    void onPressedTabBar (int value) {
      setState(() {
        _selectedIndex = value;
        switch (value) {
          case 0:
            titleAppBar = "Home";
            break;
          case 1: {
            titleAppBar = 'Discover';
            isShown = true;
          }
          break;
          case 2: {
            titleAppBar = "QR Code";
            isShown = true;
          }
          break;
          case 3:
            titleAppBar = "History";
            isShown = true;
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
      elevation: 5,
      title: titleAppBar != "Ganti Password" ?
      Text(
        titleAppBar,
        style: TextStyle(
            color: Hexcolor("#FFFFFF"),
            fontSize: 20,
            fontWeight: FontWeight.w700
        ),
      ) :
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FlatButton(
            child: Icon(Icons.arrow_back, size: Responsive.width(10, context), color: Colors.black,),
            onPressed: () {
              backToProfile();
            },
          ),
          Text(
              titleAppBar,
              style: TextStyle(
                  color: Hexcolor("#FFFFFF"),
                  fontSize: 20,
                  fontWeight: FontWeight.w700
              )
          )
        ],
      ),
      centerTitle: false,
      backgroundColor: Hexcolor("#4EC24C"),
    );

    FlashyTabBar myFlashyTabBar = FlashyTabBar(
      selectedIndex: _selectedIndex,
      animationCurve: Curves.bounceIn,
      showElevation: true,
      onItemSelected: (value) {
        onPressedTabBar(value);
      },
      backgroundColor: Colors.white,
      items: [
        FlashyTabBarItem(
            icon: Icon(
              MaterialCommunityIcons.home,
              color: Colors.black,
            ),
            title: Text("Home"),
            activeColor: Hexcolor("#ADE7D6"),
            inactiveColor: Hexcolor("#E8EBEA")
        ),
        FlashyTabBarItem(
            icon: Icon(
              Icons.explore,
              color: Colors.black,
            ),
            title: Text("Discovery"),
            activeColor: Hexcolor("#ADE7D6"),
            inactiveColor: Hexcolor("#E8EBEA")
        ),
        FlashyTabBarItem(
            icon: Icon(
              MaterialCommunityIcons.qrcode_scan,
              color: Colors.black,
            ),
            title: Text("QR Code"),
            activeColor: Hexcolor("#ADE7D6"),
            inactiveColor: Hexcolor("#E8EBEA")
        ),
        FlashyTabBarItem(
            icon: Icon(
              MaterialIcons.history,
              color: Colors.black,
            ),
            title: Text("History"),
            activeColor: Hexcolor("#ADE7D6"),
            inactiveColor: Hexcolor("#E8EBEA")
        ),
        FlashyTabBarItem(
            icon: Icon(
              MaterialIcons.person,
              color: Colors.black,
            ),
            title: Text("Profile"),
            activeColor: Hexcolor("#ADE7D6"),
            inactiveColor: Hexcolor("#E8EBEA")
        )
      ],
    );

    // Method
    dynamic tabBarShown () {
      if (isShown) {
        return myFlashyTabBar;
      } else {
        return null;
      }
    }

    void onTimeAndSubSuccess () {
      WidgetsBinding.instance.addPostFrameCallback((_){
        // Add Your Code here.
        setState(() {
          isShown = true;
          tabSelected = 'Discover';
          _selectedIndex = 1;
        });
      });
    }

    void onNextVideo () {
      setState(() {
        isShown = true;
      });
    }

    final bodyScreen = [
      Container(
        child: Dashboard(),
      ),
      Container(
        child: WatchVideo(onTimeAndSubSuccess: onTimeAndSubSuccess, onNextVideo: onNextVideo),
      ),
      Container(
        child: Center(
          child: Image(image: AssetImage("coming-soon.jpg"),),
        ),
      ),
      Container(
        child: History(),
      ),
      Container(
        child: Profile(toChangePassword: toChangePassword, backToProfile: backToProfile, changePassword: changePassword),
      )
    ];

    // TODO: implement build
    return Scaffold(
        appBar: appBar,
        bottomNavigationBar: tabBarShown(),
        body: bodyScreen[_selectedIndex]
    );
  }

  void toChangePassword () {
    setState(() {
      titleAppBar = "Ganti Password";
      changePassword = true;
    });
  }

  void backToProfile () {
    setState(() {
      titleAppBar = "Profile";
      changePassword = false;
    });
  }
}