import 'package:fastpedia/components/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:vector_math/vector_math.dart' as vector;

// FANCY TABABAR manual

/*
class FancyTabBar extends StatefulWidget {
  @override
  _FancyTabBarState createState() => _FancyTabBarState();
}

class _FancyTabBarState extends State<FancyTabBar>  with TickerProviderStateMixin{

  AnimationController _animationController;
  Tween<double> _positionTween;
  Animation<double> _positionAnimation;

  AnimationController _fadeOutController;
  Animation<double> _fadeFabOutAnimation;
  Animation<double> _fadeFabInAnimation;

  double fabIconAlpha = 1;
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;
  int currentSelected = 1;

  void getSelected () {
    String currentRouteName = ModalRoute.of(context).settings.name;
    print(currentRouteName);
    setState(() {
      switch (currentRouteName) {
        case '/profile': {
          currentSelected = 2;
  //        _positionAnimation = 2.0;
        _initAnimationAndStart(_positionAnimation.value, 2);
        }
        break;
        default:
          currentSelected = 1;
          break;
      }
    });
  }


  @override
  void initState() {
    super.initState();
//    getSelected();
    print('panteq ini kena tak muncul eeeq smdsamsam');
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300)
    );
    _fadeOutController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300 ~/ 5)
    );

    _positionTween = Tween<double>(begin: 0, end: 0);
    _positionAnimation = _positionTween.animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut)
    )..addListener(() { setState(() {});
    });

    _fadeFabOutAnimation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: _fadeOutController, curve: Curves.easeOut)
    )..addListener(() { setState(() {
      fabIconAlpha = _fadeFabOutAnimation.value;
    });
    })..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          activeIcon = nextIcon;
        });
      }
    });

    _fadeFabInAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Interval(0.8, 1, curve: Curves.easeOut))
          ..addListener(() {
            setState(() {
              fabIconAlpha = _fadeFabInAnimation.value;
            });
          })
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          height: 65,
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -1), blurRadius: 8
            )
          ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TabItem(selected: currentSelected == 0, iconData: Icons.home, title: 'HOME', callBackFunction: () {
                setState(() {
                  nextIcon = Icons.home;
                  currentSelected = 0;
                });
                _initAnimationAndStart(_positionAnimation.value, -1);
              }),
              TabItem(selected: currentSelected == 1, iconData: Icons.search, title: 'SEARCH', callBackFunction: () {
                setState(() {
                  nextIcon = Icons.search;
                  currentSelected = 1;
                });
//                  Navigator.pushReplacementNamed(context, '/dashboard');
                _initAnimationAndStart(_positionAnimation.value, 0);
              }),
              TabItem(
                  selected: currentSelected == 2,
                  iconData: Icons.person,
                  title: "USER",
                  callBackFunction: () {
                    setState(() {
                      nextIcon = Icons.person;
                      currentSelected = 2;
                    });
                    print(ModalRoute.of(context).settings.name);
                    _initAnimationAndStart(_positionAnimation.value, 1);
                    Navigator.pushReplacementNamed(context, '/profile');
                  })
            ],
          ),
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Align(
              heightFactor: 1,
              alignment: Alignment(_positionAnimation.value, 0),
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 90,
                      width: 90,
                      child: ClipRect(
                        clipper: HalfClipper(),
                        child: Container(
                          child: Center(
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 70,
                        width: 90,
                        child: CustomPaint(
                          painter: HalfPainter(),
                        )),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PURPLE,
                            border: Border.all(
                                color: Colors.white,
                                width: 5,
                                style: BorderStyle.none)),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Opacity(
                            opacity: fabIconAlpha,
                            child: Icon(
                              activeIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _initAnimationAndStart(double from, double to) {
    _positionTween.begin = from;
    _positionTween.end = to;

    _animationController.reset();
    _fadeOutController.reset();
    _animationController.forward();
    _fadeOutController.forward();
  }

}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class HalfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect beforeRect = Rect.fromLTWH(0, (size.height / 2) - 10, 10, 10);
    final Rect largeRect = Rect.fromLTWH(10, 0, size.width - 20, 70);
    final Rect afterRect =
    Rect.fromLTWH(size.width - 10, (size.height / 2) - 10, 10, 10);

    final path = Path();
    path.arcTo(beforeRect, vector.radians(0), vector.radians(90), false);
    path.lineTo(20, size.height / 2);
    path.arcTo(largeRect, vector.radians(0), -vector.radians(180), false);
    path.moveTo(size.width - 10, size.height / 2);
    path.lineTo(size.width - 10, (size.height / 2) - 10);
    path.arcTo(afterRect, vector.radians(180), vector.radians(-90), false);
    path.close();

    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
*/

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
        print(value);
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