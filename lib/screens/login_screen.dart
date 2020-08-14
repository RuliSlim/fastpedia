import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  String _username, _password;
  bool _usernameValidation = false;
  bool _passwordValidation = false;

  // states
  bool _isLogin = true;
  bool _isActive = false;
  bool _isLogging = false;

  // check if text fields is active
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  // focus node register
  FocusNode _focusName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusNIK = new FocusNode();
  FocusNode _focusHP = new FocusNode();

  @override
  void initState() {
    super.initState();

    // focus comp
    _focusUsername.addListener(_onFocusChange);
    _focusPassword.addListener(_onFocusChange);

    // register components focus
    _focusName.addListener(_onFocusChange);
    _focusEmail.addListener(_onFocusChange);
    _focusNIK.addListener(_onFocusChange);
    _focusHP.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    setState(() {
      _isActive = _focusPassword.hasFocus || _focusUsername.hasFocus ? true : false;
    });
  }

  // end check text field

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebService webService = Provider.of<WebService>(context);

    // methods
    // Login function when pressed
    var doLogin = () {
      setState(() {
        _isLogging = true;
        _isActive = false;
      });

      final Future<Map<String, dynamic>> successfulMessage =
      webService.signIn(username: _username, password: _password);

      successfulMessage.then((response) {
        if (response['status']) {
          setState(() {
            _isLogging = false;
          });
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _isLogging = false;
          });
          Flushbar(
            title: "Failed Login",
            message: response['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

    // validation username and password
    void validation ({String type, String value}) {
      setState(() {
        if (type == 'username') {
          _username = value;
          _usernameValidation = _username.length >= 6 ? false : true;
        } else {
          _password = value;
          _passwordValidation = _password.length >= 8 ? false : true;
          print(_passwordValidation);
        }
      });
    }

    // fields everything
    final usernameField = CustomTextFields(
      textInputAction: TextInputAction.next,
      secret: false,
      hintText: 'Input your username',
      icon: Icon(Icons.person),
      width: 80,
      label: 'username',
      onChanged: (val) => validation(type: 'username', value: val),
      focusNode: _focusUsername,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _focusUsername.unfocus();
        FocusScope.of(context).requestFocus(_focusPassword);
      },
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      errorMessage: 'username at least 6 char',
      isError: _usernameValidation,
    );

    final passwordField = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      hintText: 'Input Your password',
      icon: Icon(Icons.lock),
      width: 80,
      label: 'password',
      onChanged: (val) => validation(type: 'password', value: val),
      focusNode: _focusPassword,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _focusPassword.unfocus();
        doLogin();
      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: 'password at least 8 char',
      isError: _passwordValidation,
    );


    // loading components
    var loading = Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Authenticating ... Please Wait')
          ],
        )
    );

    // ModernDesign
    Row textLoginOrRegister = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            setState(() {
              _isLogin = true;
            });
          },
          child: Text('Login',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: _isLogin ? Colors.white : Colors.grey
            ),
          ),
        ),
        Text('|'),
        FlatButton(
          onPressed: () {
            setState(() {
              _isLogin = false;
            });
          },
          child: Text('Register',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: _isLogin ? Colors.grey : Colors.white
            ),
          ),
        )
      ],
    );

    ButtonTheme buttonSignInOrSignUp = ButtonTheme(
        minWidth: Responsive.width(80, context),
        child: RaisedButton(
          child: Text(
              _isLogin ? 'Sign In' : ' Sign Up',
            style: TextStyle(
              fontSize: 16
            ),
          ),
          padding: EdgeInsets.all(8.0),
          textColor: Colors.white,
          color: Colors.blue,
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.black)
          ),
          onPressed: () {
            doLogin();
          },
        )
    );

    Column loginOrRegister = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: textLoginOrRegister,
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: usernameField,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: passwordField,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: _isActive ? buttonSignInOrSignUp : null,
        )
      ],
    );

    Column registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        textLoginOrRegister,
        Text('Register')
      ],
    );

    AnimatedContainer fields = AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      curve: Curves.ease,
      child: _isLogin ? loginOrRegister : registerFields,
      decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          )
      ),
    );

    AnimatedPadding modernDesign = AnimatedPadding(
      duration: Duration(seconds: 1),
      padding: EdgeInsets.only(bottom: _isActive ? MediaQuery.of(context).viewInsets.bottom : 0),
      curve: Curves.ease,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          fields,
        ],
      ),
    );

    // WIDGET BODY
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: new GestureDetector(
          child: _isLogging ? loading : modernDesign,
          onTap: () {
            _focusPassword.unfocus();
            _focusUsername.unfocus();
          },
        )
    );
  }
}
