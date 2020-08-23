import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/components/tab_bar.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/enums.dart';
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

  // state components
  bool _isActive = false;
  bool _isMyVideo = false;

  // focus fields;
  FocusNode _focusName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusNIK = new FocusNode();
  FocusNode _focusHP = new FocusNode();

  // check if text fields is active
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusPassword = new FocusNode();

  // state value
  String _username;
  String _password;

  String _name;
  String _email;
  String _nik;
  String _noHp;

  // states validation;
  bool _usernameValidation = false;
  bool _passwordValidation = false;
  bool _nameValidation = false;
  bool _emailValidation = false;
  bool _nikValidation = false;
  bool _noHpValidation = false;

  void getUsername () async {
    User user = await UserPreferences().getUser();
    print([user.phone, user.name, user.nik]);
    setState(() {
      userData = user;
      username = user.username;
      _name = user.name;
      _email = user.email;
      _nik = user.nik;
      _noHp = user.phone;
    });
  }

  void logoutUser () {
    UserPreferences().removeUser();
  }

  @override
  void initState() {
    super.initState();
    getUsername();

    // focus comp
    _focusUsername.addListener(_onFocusChange);
    _focusPassword.addListener(_onFocusChange);

    // register components focus
    _focusName.addListener(_onFocusChange);
    _focusEmail.addListener(_onFocusChange);
    _focusNIK.addListener(_onFocusChange);
    _focusHP.addListener(_onFocusChange);
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

    // box container
    Row buttonInfoOrVideo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text("My Information",
            style: TextStyle(
                color: _isMyVideo ? Colors.grey : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20
            ),
          ),
          onPressed: () {
            _changeInfoOrVideos(type: InfoVideos.info);
          },
        ),
        Text("|"),
        FlatButton(
          child: Text("My Videos",
            style: TextStyle(
                color: _isMyVideo ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w900,
                fontSize: 20
            ),
          ),
          onPressed: () {
            _changeInfoOrVideos(type: InfoVideos.videos);
          },
        )
      ],
    );

    // register components
    final nameField = CustomTextFields(
      textInputAction: TextInputAction.next,
      isError: _nameValidation,
      errorMessage: 'masukan nama sesuai ktp',
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autoCorrect: false,
      focusNode: _focusName,
      label: 'name',
      hintText: 'masukan nama anda',
      width: 80,
      icon: Icon(Icons.person),
      secret: false,
      initialValue: _name,
      readOnly: true,
      onFiledSubmitted: (val) {
        _focusName.unfocus();
        FocusScope.of(context).requestFocus(_focusEmail);
      },
      onChanged: (val) {
        validation(type: TypeField.name, value: val);
      },
    );

    final emailField = CustomTextFields(
      textInputAction: TextInputAction.next,
      isError: _emailValidation,
      errorMessage: 'email is invalid',
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusEmail,
      label: 'email',
      hintText: 'masukan email anda',
      width: 80,
      icon: Icon(Icons.email),
      secret: false,
      initialValue: _email,
      readOnly: true,
      onFiledSubmitted: (val) {
        _focusEmail.unfocus();
        FocusScope.of(context).requestFocus(_focusNIK);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.email);
      },
    );

    final nikField = CustomTextFields(
      textInputAction: TextInputAction.next,
      isError: _nikValidation,
      errorMessage: 'masukan NIK anda',
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusNIK,
      label: 'NIK',
      width: 80,
      icon: Icon(Icons.verified_user),
      secret: false,
      initialValue: _nik,
      readOnly: true,
      onFiledSubmitted: (val) {
        _focusNIK.unfocus();
        FocusScope.of(context).requestFocus(_focusHP);
      },
      onChanged: (val) {
        validation(type: TypeField.nik, value: val);
      },
    );

    final noHPField = CustomTextFields(
      textInputAction: TextInputAction.next,
      isError: _noHpValidation,
      errorMessage: 'no hp tidak valid',
      keyboardType: TextInputType.phone,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusHP,
      label: 'phone number',
      width: 80,
      icon: Icon(Icons.phone),
      secret: false,
      initialValue: _noHp,
      readOnly: true,
      onFiledSubmitted: (val) {
        _focusHP.unfocus();
        FocusScope.of(context).requestFocus(_focusUsername);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.noHp);
      },
    );

    ButtonTheme updateOrInsertVideo = ButtonTheme(
      minWidth: Responsive.width(80, context),
      child: RaisedButton(
        child: Text(
          _isMyVideo ? "Add Video" : "Save Info",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        padding: EdgeInsets.all(8),
        textColor: Colors.white,
        color: Colors.blue,
        splashColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black)
        ),
      ),
    );

    SingleChildScrollView infoFields = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: nameField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: emailField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: nikField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: noHPField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: _isActive ? updateOrInsertVideo : null,
            )
          ],
        ),
      ),
    );

    Column containerFields =  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget> [
        buttonInfoOrVideo,
        Expanded(child: infoFields)
      ],
    );

    AnimatedContainer containerInfoAndMyVideo = AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.ease,
        decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        child: _isActive ? containerFields : buttonInfoOrVideo
    );

    AnimatedPadding animationPadding = AnimatedPadding(
      duration: Duration(seconds: 1),
      padding: EdgeInsets.only(bottom: _isActive ? MediaQuery.of(context).viewInsets.bottom : 0),
      curve: Curves.ease,
      child: Column(
        children: <Widget> [
          Expanded(
            flex: _isActive ? 2 : 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                profilePicture,
                buttonLogOut
              ],
            ),
          ),
          Expanded(
            flex: _isActive ? 4 : 1,
            child: containerInfoAndMyVideo,
          )
        ],
      ),
    );

    // TODO: implement build
    return Scaffold(
      //appBar: appBar,
      body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: animationPadding
      ),
    );
  }

  _changeInfoOrVideos({InfoVideos type}) {
    setState(() {
      _isActive = true;
      switch (type) {
        case InfoVideos.videos:
          _isMyVideo = true;
          break;
        case InfoVideos.info:
          _isMyVideo = false;
          break;
      }
    });
  }

  void _onFocusChange(){
    if (_isMyVideo) {

    } else {
      setState(() {
        _isActive = _focusName.hasFocus || _focusEmail.hasFocus || _focusNIK.hasFocus || _focusHP.hasFocus || _focusUsername.hasFocus || _focusPassword.hasFocus ? true : false;
      });
    }
  }

  void validation ({TypeField type, String value}) {
    setState(() {
      switch (type) {
        case TypeField.username:
          _username = value;
          _usernameValidation = _username.length >= 6 ? false : true;
          break;
        case TypeField.password:
          _password = value;
          _passwordValidation = _password.length >= 8 ? false : true;
          break;
        case TypeField.name:
          _name = value;
          _nameValidation = _name.length >= 4 ? false : true;
          break;
        case TypeField.email:
          _email = value;
          //_usernameValidation = _username.length >= 6 ? false : true;
          break;
        case TypeField.nik:
          _nik = value;
          //_usernameValidation = _username.length >= 6 ? false : true;
          break;
        case TypeField.noHp:
          _noHp = value;
          //_usernameValidation = _username.length >= 6 ? false : true;
          break;
      }
    });
  }

}

//@override
//_DashBoardState createState() => _DashBoardState();