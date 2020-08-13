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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  String _username, _password;

  // states
  bool isLogin = true;
  bool isActive = false;
  bool isLoging = false;

  // check if text fields is active
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusPassword = new FocusNode();

  @override
  void initState() {
    super.initState();
    _focusUsername.addListener(_onFocusChange);
    _focusPassword.addListener(_onFocusChange);
  }

  void _onFocusChange(){
    debugPrint("Focus: "+_focusUsername.hasFocus.toString());
    setState(() {
      isActive = _focusPassword.hasFocus || _focusUsername.hasFocus ? true : false;
    });
  }

  // end check text field

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WebService webService = Provider.of<WebService>(context);

    // methods
    // Login function when pressed
    var doLogin = () {
      final form = formKey.currentState;
      setState(() {
        isLoging = true;
      });

      final Future<Map<String, dynamic>> successfulMessage =
      webService.signIn(username: _username, password: _password);

      successfulMessage.then((response) {
        if (response['status']) {
          setState(() {
            isLoging = false;
          });
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            isLoging = false;
          });
          Flushbar(
            title: "Failed Login",
            message: response['message'].toString(),
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    };

    final usernameField = Container(
        width: Responsive.width(80, context),
        child: TextFormField(
          focusNode: _focusUsername,
          obscureText: false,
          autofocus: false,
          autocorrect: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
          onSaved: (value) => _username = value.toUpperCase(),
          onChanged: (value) => _username = value.toUpperCase(),
          onFieldSubmitted: (term) {
            _focusUsername.unfocus();
            FocusScope.of(context).requestFocus(_focusPassword);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
            labelText: 'username',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          ),
        )
    );

    final passwordField = Container(
      width: Responsive.width(80, context),
      child: TextFormField(
        focusNode: _focusPassword,
        textInputAction: TextInputAction.done,
        obscureText: true,
        autofocus: false,
        autocorrect: false,
        onSaved: (value) => _password = value,
        onChanged: (value) => _password = value,
        onFieldSubmitted: (term) {
          _focusPassword.unfocus();
          doLogin();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'password',
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        ),
      ),
    );

    var loading = Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text('Authenticating ... Please Wait')
          ],
        )
    );

    Column loginStandard = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          color: Color.fromRGBO(32, 150, 83, 1),
          height: Responsive.height(15, context),
          width: Responsive.width(100, context),
        ),
        Container(
          height: Responsive.height(30, context),
          width: Responsive.width(100, context),
          padding: EdgeInsets.all(20),
          child: Image(
            image: AssetImage('Fast-logo.png'),
          ),
        ),
        Container(
            width: Responsive.width(80, context),
            height: Responsive.height(5, context),
            child:
            usernameField
        ),
        Container(
            width: Responsive.width(80, context),
            height: Responsive.height(5, context),
            child:
            passwordField
        ),
        Container(
          width: Responsive.width(80, context),
          height: Responsive.height(5, context),
          child: RaisedButton(
            onPressed: () {
              doLogin();
            },
            child: Text('Login'),
          ),
        ),
        Container(
            color: Color.fromRGBO(32, 150, 83, 1),
            height: Responsive.height(25, context),
            width: Responsive.width(100, context)
        )
      ],
    );

    // ModernDesign
    Row textLoginOrRegister = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            setState(() {
              isLogin = true;
            });
          },
          child: Text('Login',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isLogin ? Colors.white : Colors.grey
            ),
          ),
        ),
        Text('|'),
        FlatButton(
          onPressed: () {
            setState(() {
              isLogin = false;
            });
          },
          child: Text('Register',
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: isLogin ? Colors.grey : Colors.white
            ),
          ),
        )
      ],
    );

    ButtonTheme buttonSignInOrSignUp = ButtonTheme(
        minWidth: Responsive.width(80, context),
        child: RaisedButton(
          child: Text(isLogin ? 'Sign In' : ' Sign Up'),
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
        textLoginOrRegister,
        usernameField,
        passwordField,
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: buttonSignInOrSignUp,
        )
      ],
    );

    Column loginOrRegisterNotActive = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        textLoginOrRegister,
        usernameField,
        passwordField,
      ],
    );

    AnimatedContainer fields = AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      curve: Curves.ease,
      height: isActive ? 550 : 200,
      child: isActive ? loginOrRegister : loginOrRegisterNotActive,
      decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          )
      ),
    );

    Column modernDesign = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        fields,
      ],
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: isLoging ? loading : modernDesign
    );
  }
}