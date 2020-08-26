import 'dart:math';

import 'package:commons/commons.dart';
import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/enums.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_preferences.dart';
import 'package:fastpedia/services/validation.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  User userData;
  String _username;

  // state components
  bool _isActive = false;
  bool _isMyVideo = false;
  bool _isEditing = false;
  bool _isReadOnly = true;
  bool _changePassword = false;
  bool _isLoading = false;

  // focus fields;
  FocusNode _focusName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusNIK = new FocusNode();
  FocusNode _focusHP = new FocusNode();

  // check if text fields is active
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusPasswordNew = new FocusNode();

  // state value
  String _passwordOld;
  String _passwordNew;

  String _name;
  String _email;
  String _nik;
  String _noHp;

  // states validation;
  bool _passwordValidation = false;
  bool _passwordValidationNew = false;
  bool _emailValidation = false;
  bool _noHpValidation = false;

  // random color
  int _colorIdx;
  List<Color> _randomColor = [
    Colors.black,
    Colors.grey,
    Colors.blue,
    Colors.pinkAccent,
    Colors.green,
    Colors.yellow
  ];

  void getUsername () async {
    User user = await UserPreferences().getUser();
    setState(() {
      userData = user;
      _username = user.username;
      _name = user.name;
      _email = user.email;
      _nik = user.nik;
      _noHp = user.phone;
    });
  }

  random(min, max){
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  void logoutUser () {
    UserPreferences().removeUser();
  }

  @override
  void initState() {
    super.initState();
    getUsername();

    setState(() {
      _colorIdx = random(0, _randomColor.length - 1);
    });

    // focus comp
    _focusUsername.addListener(_onFocusChange);
    _focusPassword.addListener(_onFocusChange);
    _focusPasswordNew.addListener(_onFocusChange);

    // register components focus
    _focusName.addListener(_onFocusChange);
    _focusEmail.addListener(_onFocusChange);
    _focusNIK.addListener(_onFocusChange);
    _focusHP.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    // PROVIDERS
    WebService webService = Provider.of<WebService>(context);
    //

    // METHODS
    // change to edit
    void _changeToEdit() {
      setState(() {
        _isEditing = true;
        _isReadOnly = false;
      });
    }
    //

    // do update
    void _updateFunction() async {
      setState(() {
        _isReadOnly = true;
        _isEditing = false;
        _changePassword = false;
        _isLoading = true;
      });

      Map<String, dynamic> response =  await webService.update(name: _name, email: _email, phone: _noHp, nik: _nik);

      if (response['status']) {
        successDialog(context, response['message']);
      } else {
        errorDialog(context, response['message']);
      }

      setState(() {
        _isLoading = false;
      });

      getUsername();
    }

    void _changePasswordFunction() async {
      setState(() {
        _isReadOnly = true;
        _isEditing = false;
        _changePassword = false;
        _isLoading = true;
      });

      if (_passwordValidationNew || _passwordValidation || _passwordOld == null || _passwordNew == null || _passwordNew.length <= 1 || _passwordOld.length <= 1) {
        errorDialog(context, "password tidak valid");
        setState(() {
          _isLoading = false;
        });
        return null;
      }

      Map<String, dynamic> response = await webService.updatePassword(newPassword: _passwordNew, oldPassword: _passwordOld);

      if (response['status']) {
        successDialog(context, response['message']);
      } else {
        errorDialog(context, response['message']);
      }

      setState(() {
        _isLoading = false;
      });

      getUsername();
    }
    //

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

    Padding profilePicture = Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                child: Icon(
                  Icons.person_pin,
                  size: 50,
                ),
                radius: 30,
                backgroundColor: _randomColor[_colorIdx],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  '$_username',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 30
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );

//    Row profilePicture = Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Column(
//            children: <Widget>[
//              CircleAvatar(
//                child: Icon(Icons.person),
//                radius: 40,
//              ),
//              Text(
//                '$_username',
//                style: TextStyle(
//                    color: Hexcolor("#1E3B2A"),
//                    fontWeight: FontWeight.w900,
//                    fontSize: 20
//                ),
//              )
//            ]
//        ),
//      ],
//    );

    ButtonTheme buttonLogOut = ButtonTheme(
        minWidth: Responsive.width(60, context),
        child: RaisedButton(
          onPressed: () {
            logoutUser();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            'Logout',
            style: TextStyle(
                color: Hexcolor("#1E3B2A"),
                fontWeight: FontWeight.w900,
                fontSize: 20
            ),
          ),
          padding: EdgeInsets.all(8),
          textColor: Colors.white,
          color: Hexcolor("#0B8B53"),
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.black)
          ),
        )
    );

    // box container
    Row buttonInfoOrVideo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: Text("Infoku",
            style: TextStyle(
                color: Hexcolor("#1E3B2A"),
                fontWeight: FontWeight.w900,
                fontSize: 20
            ),
          ),
          onPressed: () {
            _changeInfoOrVideos(type: InfoVideos.info);
          },
        ),
      ],
    );

    // register components
    final nameField = CustomTextFieldsSecondary(
      textInputAction: TextInputAction.next,
      isError: false,
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

    final emailField = CustomTextFieldsSecondary(
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
      readOnly: _isReadOnly,
      onFiledSubmitted: (val) {
        _focusEmail.unfocus();
        FocusScope.of(context).requestFocus(_focusHP);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.email);
      },
    );

    final emailFieldEdit = CustomTextFields(
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
      readOnly: _isReadOnly,
      onFiledSubmitted: (val) {
        _focusEmail.unfocus();
        FocusScope.of(context).requestFocus(_focusHP);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.email);
      },
    );

    final nikField = CustomTextFieldsSecondary(
      textInputAction: TextInputAction.next,
      isError: false,
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

    final noHPField = CustomTextFieldsSecondary(
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
      readOnly: _isReadOnly,
      onFiledSubmitted: (val) {
        _focusHP.unfocus();
        FocusScope.of(context).requestFocus(_focusUsername);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.noHp);
      },
    );

    final noHPFieldEdit = CustomTextFields(
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
      readOnly: _isReadOnly,
      onFiledSubmitted: (val) {
        _focusHP.unfocus();
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.noHp);
      },
    );

    final oldPassword = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      hintText: 'Masukan Password Lama',
      icon: Icon(Icons.lock),
      width: 80,
      label: 'password lama',
      onChanged: (val) => validation(type: TypeField.password, value: val),
      focusNode: _focusPassword,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _focusPassword.unfocus();
        FocusScope.of(context).requestFocus(_focusPasswordNew);
      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: "password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.",
      isError: _passwordValidation,
    );

    final newPassword = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      hintText: 'masukan password baru',
      icon: Icon(Icons.lock),
      width: 80,
      label: 'password baru',
      onChanged: (val) => validation(type: TypeField.passwordNew, value: val),
      focusNode: _focusPasswordNew,
      autoCorrect: false,
      onFiledSubmitted: (val) {

      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: "password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.",
      isError: _passwordValidationNew,
    );

    final ButtonTheme updateOrInsertVideo = ButtonTheme(
      minWidth: Responsive.width(80, context),
      child: RaisedButton(
        child: Text(
          _isMyVideo ? "Add Video" : _isEditing ? _changePassword ? "Update Password" : "Update" : "Edit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        padding: EdgeInsets.all(8),
        textColor: Colors.white,
        color: Hexcolor("#0B8B53"),
        splashColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black)
        ),
        onPressed: () {
          _isMyVideo ? null : _isEditing ? _changePassword ? _changePasswordFunction() : _updateFunction() : _changeToEdit();
        },
      ),
    );

    final ButtonTheme changePassword = ButtonTheme(
        minWidth: Responsive.width(80, context),
        child: RaisedButton(
          child: Text('Ganti Password',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            setState(() {
              _changePassword = true;
            });
          },
          padding: EdgeInsets.all(8),
          textColor: Colors.white,
          color: Hexcolor("#0B8B53"),
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.black)
          ),
        )
    );

    final SingleChildScrollView infoFields = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? 0 : 10),
              child: _isEditing ? null : nikField,
            ),
            Padding(
              padding: EdgeInsets.only(top: _changePassword ? 0 : 10),
              child: _isEditing ? _changePassword ? null : emailFieldEdit : emailField,
            ),
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? _changePassword ? 0 : 10 : 10),
              child: _isEditing ? _changePassword ? null : noHPFieldEdit : noHPField,
            ),
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? 10 : 0),
              child: _isEditing ? _changePassword ? oldPassword : changePassword : null,
            ),
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? _changePassword ? 10 : 0 : 0),
              child: _isEditing ? _changePassword ? newPassword : null : null,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _isActive ? updateOrInsertVideo : null,
            )
          ],
        ),
      ),
    );

    final Column containerFields =  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget> [
        buttonInfoOrVideo,
        Expanded(child: infoFields)
      ],
    );

    final AnimatedContainer containerInfoAndMyVideo = AnimatedContainer(
        duration: Duration(seconds: 1),
        curve: Curves.ease,
        decoration: BoxDecoration(
            color: Hexcolor("#ADE7D6"),
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            )
        ),
        child: _isActive ? containerFields : buttonInfoOrVideo
    );

    final AnimatedPadding animationPadding = AnimatedPadding(
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
      body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: _isLoading ? loading : animationPadding
      ),
    );
  }

  _changeInfoOrVideos({InfoVideos type}) {
    setState(() {
      _isActive = true;
      _isEditing = false;
      _changePassword = false;
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
        _isActive = _focusName.hasFocus || _focusEmail.hasFocus || _focusNIK.hasFocus || _focusHP.hasFocus || _focusUsername.hasFocus || _focusPassword.hasFocus || _focusPasswordNew.hasFocus ? true : false;
      });
    }
  }

  void validation ({TypeField type, String value}) {
    setState(() {
      switch (type) {
        case TypeField.username:
          break;
        case TypeField.password:
          _passwordOld = value;
          _passwordValidation = validatePassword(password: value);
          break;
        case TypeField.passwordNew:
          _passwordNew = value;
          _passwordValidationNew = validatePassword(password: value);
          break;
        case TypeField.name:
          _name = value;
          break;
        case TypeField.email:
          _email = value;
          _emailValidation = validateEmail(email: value);
          break;
        case TypeField.nik:
          _nik = value;
          break;
        case TypeField.noHp:
          _noHp = value;
          _noHpValidation = validatePhone(phone: value);
          break;
      }
    });
  }

}
