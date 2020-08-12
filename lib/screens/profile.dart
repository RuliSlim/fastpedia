import 'package:fastpedia/components/tab_bar.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/screens/discover_video.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  User userData;
  String username;

  void getUsername () async {
    User user = await UserPreferences().getUser();
    setState(() {
      userData = user;
      username = user.username;
    });
  }

  void logoutUser () {
    UserPreferences().removeUser();
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    print('panteq kau jiing');
  }

  @override
  Widget build(BuildContext context) {
    print(ModalRoute.of(context).settings.name);

    AppBar appBar = AppBar(
      backgroundColor: Colors.amberAccent,
      elevation: 0,
      centerTitle: true,
      title: Text('Profile'),
    );

    Row profilePicture = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
            children: <Widget>[
              CircleAvatar(
                child: Icon(Icons.person),
              ),
              Text('$username')
            ]
        ),
      ],
    );

    RaisedButton buttonLogOut = RaisedButton(
      onPressed: () {
        print('ini panteq kao');
        logoutUser();
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Text('Logout'),
    );

    // TODO: implement build
    return Scaffold(
        //appBar: appBar,
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              profilePicture,
              buttonLogOut
            ],
          ),
        ),
    );
  }

}

//@override
//_DashBoardState createState() => _DashBoardState();