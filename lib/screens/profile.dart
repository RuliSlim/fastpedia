import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final VoidCallback toChangePassword;
  final VoidCallback backToProfile;
  final bool changePassword;

  Profile({Key key, this.backToProfile, this.toChangePassword, this.changePassword}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}


class _ProfileState extends State<Profile> {
  User userData;

  // state components
  bool _isReadOnlyEmail = true;
  bool _isReadOnlyPhone = true;
  bool _changePassword = false;
  bool _isLoading = false;
  bool _emailEditing = false;
  bool _phoneEditing = false;

  // focus fields;
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusNIK = new FocusNode();
  FocusNode _focusHP = new FocusNode();

  // check if text fields is active
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

  Future<void> getUsername () async {
    User user = await UserPreferences().getUser();
    setState(() {
      userData = user;
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
      _changePassword = widget.changePassword;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.backToProfile();
    });
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
        _isReadOnlyEmail = false;
      });
    }
    //

    // do update
    void _updateFunction() async {
      setState(() {
        _isReadOnlyEmail = true;
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
        _isReadOnlyEmail = true;
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

      widget.backToProfile();
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

    Container profilePicture = Container(
        width: Responsive.width(80, context),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: CircleAvatar(
                    child: Icon(
                      Icons.person_pin,
                      size: Responsive.width(8, context),
                    ),
                    radius: Responsive.width(5, context),
                    backgroundColor: _randomColor[_colorIdx],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    _name != null ? _name.toCapitalize().toString() : "Loading",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                    ),
                    maxLines: 3,
                    maxFontSize: 30,
                    minFontSize: 20,
                  ),
                )
              ],
            ),
          ),
        )
    );

    Card buttonToChangePassword = Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          setState(() {
            _changePassword = true;
          });
          widget.toChangePassword();
        },
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                child: Icon(
                  Icons.lock,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: AutoSizeText(
                  'Ganti Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                  ),
                  minFontSize: 10,
                  maxFontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );

    Card termsAndCondition = Card(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              child: Icon(
                MaterialIcons.pages,
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: AutoSizeText(
                'Syarat & Ketentuan',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                ),
                maxFontSize: 20,
                minFontSize: 10,
              ),
            )
          ],
        ),
      ),
    );

    Card logoutButton = Card(
        child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              logoutUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    child: Icon(
                      MaterialIcons.exit_to_app,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: AutoSizeText(
                      'Logout',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                      ),
                      minFontSize: 10,
                      maxFontSize: 20,
                    ),
                  )
                ],
              ),
            )
        )
    );

    final Container cards = Container(
        width: Responsive.width(80, context),
        child: Column(
          children: [
            buttonToChangePassword,
            termsAndCondition,
            logoutButton
          ],
        )
    );

    // register components
    final emailField = CustomTextFieldsSecondary(
      textInputAction: TextInputAction.done,
      isError: _emailValidation,
      errorMessage: 'email is invalid',
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusEmail,
      label: 'email',
      hintText: 'masukan email anda',
      width: 80,
      icon: Icon(Icons.email, size: Responsive.width(4, context),),
      secret: false,
      initialValue: _email,
      readOnly: _isReadOnlyEmail,
      onFiledSubmitted: (val) {
        _focusEmail.unfocus();
        setState(() {
          _phoneEditing = false;
          _emailEditing = false;
          _isReadOnlyEmail = true;
        });
        _updateFunction();
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.email);
      },
      suffixButton: FlatButton(
        child: Text(_emailEditing ? "Simpan" : "Ubah", style: TextStyle(fontSize: Responsive.width(4, context)),),
        onPressed: () {
          if (_emailEditing) {
            setState(() {
              _emailEditing = false;
              _isReadOnlyEmail = true;
            });
            _updateFunction();
          } else {
            setState(() {
              _emailEditing = true;
              _isReadOnlyEmail = false;
            });
          }
        },
      ),
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
      icon: Icon(Icons.phone, size: Responsive.width(4, context),),
      secret: false,
      initialValue: _noHp,
      readOnly: _isReadOnlyPhone,
      onFiledSubmitted: (val) {
        _focusHP.unfocus();
        _updateFunction();
        setState(() {
          _phoneEditing = false;
          _emailEditing = false;
          _isReadOnlyPhone = true;
        });
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.noHp);
      },
      suffixButton: FlatButton(
        child: Text(_phoneEditing ? "Simpan" : "Ubah", style: TextStyle(fontSize: Responsive.width(4, context))),
        onPressed: () {
          if (_phoneEditing) {
            setState(() {
              _phoneEditing = false;
              _isReadOnlyPhone = true;
            });
            _updateFunction();
          } else {
            setState(() {
              _phoneEditing = true;
              _isReadOnlyPhone = false;
            });
          }
        },
      ),
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
      icon: Icon(Icons.verified_user, size: Responsive.width(4, context)),
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

    final oldPassword = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
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
        minWidth: Responsive.width(80, context),
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

    final Container infoFields = Container(
      width: Responsive.width(100, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          nikField,
          emailField,
          noHPField,
        ],
      ),
    );

    SingleChildScrollView changePasswordField = SingleChildScrollView(
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

    final Column animationPadding = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: profilePicture,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: infoFields,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: cards,
        ),
      ],
    );

    // TODO: implement build

    if (_email == null || _name == null || _nik == null ) {
      return loadingScreen(
        context,
        loadingType: LoadingType.JUMPING,
      );
    } else {
      return Scaffold(
          body: _isLoading ? loading : widget.changePassword ? changePasswordField : SingleChildScrollView(
            child: GestureDetector(
              child: animationPadding,
              onTap: () {
                _focusPassword.unfocus();
                _focusEmail.unfocus();
                _focusHP.unfocus();
                _focusNIK.unfocus();

                setState(() {
                  _phoneEditing = false;
                  _emailEditing = false;
                  _isReadOnlyPhone = true;
                  _isReadOnlyEmail = true;
                });
              },
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
