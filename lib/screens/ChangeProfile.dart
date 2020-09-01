import 'dart:async';

import 'package:commons/commons.dart';
import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/enums.dart';
import 'package:fastpedia/services/validation.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ChangeProfile extends StatefulWidget {
  @override
  _ChangeProfile createState() => _ChangeProfile();
}

class _ChangeProfile extends State<ChangeProfile> {
  // check if text fields is active
  FocusNode _focusPassword = new FocusNode();
  FocusNode _focusPasswordNew = new FocusNode();

  Timer timer;

  // state value
  String _passwordOld;
  String _passwordNew;

  bool _loading = false;

  // states validation;
  bool _passwordValidation = false;
  bool _passwordValidationNew = false;
  bool _emailValidation = false;
  bool _noHpValidation = false;

  @override
  void dispose() {
    super.dispose();
    timer != null ? timer.cancel() : null;
  }


  @override
  Widget build(BuildContext context) {
    WebService webService = Provider.of<WebService>(context);

    final  Map<String, Object> receiveData = ModalRoute.of(context).settings.arguments;

    void _changePasswordFunction() async {
      setState(() {
        _loading = true;
      });

      if (_passwordValidationNew || _passwordValidation || _passwordOld == null || _passwordNew == null || _passwordNew.length <= 1 || _passwordOld.length <= 1) {
        errorDialog(context, "password tidak valid");
        setState(() {
          _loading = false;
        });
        return null;
      }

      Map<String, dynamic> response = await webService.updatePassword(newPassword: _passwordNew, oldPassword: _passwordOld);

      if (response['status']) {
        successDialog(context, response['message']);
      } else {
        errorDialog(context, response['message']);
        return null;
      }

      setState(() {
        _loading = false;
      });

      timer = Timer(Duration(seconds: 2), () => Navigator.pushNamed(context, "/home", arguments: {"type": "profile"}));
    }

    final oldPassword = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      borderColor: "#4EC24C",
      hintText: 'Masukan Password Lama',
      icon: Icon(Icons.lock, size: Responsive.width(4, context)),
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
      borderColor: "#4EC24C",
      hintText: 'masukan password baru',
      icon: Icon(Icons.lock, size: Responsive.width(4, context)),
      width: 80,
      label: 'password baru',
      onChanged: (val) => validation(type: TypeField.passwordNew, value: val),
      focusNode: _focusPasswordNew,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _changePasswordFunction();
      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: "password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.",
      isError: _passwordValidationNew,
    );

    final ButtonTheme changePasswordButton = ButtonTheme(
        minWidth: Responsive.width(90, context),
        child: RaisedButton(
          child: Text('Ganti Password',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            _changePasswordFunction();
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

    final SingleChildScrollView changePasswordField = SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: oldPassword,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: newPassword,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: changePasswordButton,
            ),
          ],
        ),
      ),
    );

    final AppBar appBar = AppBar(
      title: Text(
        "Ganti Password",
        style: TextStyle(
            color: Hexcolor("#FFFFFF"),
            fontSize: 20,
            fontWeight: FontWeight.w700
        ),
      ),
      centerTitle: false,
      backgroundColor: Hexcolor("#4EC24C"),
    );

    // TODO: implement build
    if (receiveData["type"] == "password") {
      return Scaffold(
        appBar: appBar,
        body: Container(
          color: Hexcolor("#F6FAF5"),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _loading ? loadingScreen(context, loadingType: LoadingType.JUMPING) : changePasswordField,
            ),
          ),
        )
      );
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
          break;
        case TypeField.email:
          _emailValidation = validateEmail(email: value);
          break;
        case TypeField.nik:
          break;
        case TypeField.noHp:
          _noHpValidation = validatePhone(phone: value);
          break;
      }
    });
  }




}