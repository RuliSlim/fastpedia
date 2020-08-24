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
import 'package:provider/provider.dart';

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
  bool _isEditing = false;
  bool _isReadOnly = true;
  bool _changePassword = false;

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
  String _username;
  String _passwordOld;
  String _passwordNew;

  String _name;
  String _email;
  String _nik;
  String _noHp;

  // states validation;
  bool _usernameValidation = false;
  bool _passwordValidation = false;
  bool _passwordValidationNew = false;
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
    void _updateFunction() {
      setState(() {
        _isReadOnly = true;
        _isEditing = false;
        _changePassword = false;
      });

      final Future<Map<String, dynamic>> server = webService.update(name: _name, email: _email, phone: _noHp, nik: _nik);
      server.then((response) {
        print([response, 'SADSADSMA>DSAMD>SAMD>SAM>DMS']);
        if (response['status']) {
          successDialog(context, response['message']);
        } else {
          errorDialog(context, response['message']);
        }
      });

      getUsername();
    }
    //
    
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
      ],
    );

    // register components
    final nameField = CustomTextFieldsSecondary(
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
        FocusScope.of(context).requestFocus(_focusNIK);
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
        FocusScope.of(context).requestFocus(_focusNIK);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.email);
      },
    );

    final nikField = CustomTextFieldsSecondary(
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
        FocusScope.of(context).requestFocus(_focusUsername);
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

    ButtonTheme updateOrInsertVideo = ButtonTheme(
      minWidth: Responsive.width(80, context),
      child: RaisedButton(
        child: Text(
          _isMyVideo ? "Add Video" : _isEditing ? "Update" : "Edit",
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
        onPressed: () {
          _isMyVideo ? null : _isEditing ? _updateFunction() : _changeToEdit();
        },
      ),
    );

    FlatButton changePassword = FlatButton(
      child: Text('ganti password',
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
    );

    SingleChildScrollView infoFields = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: _isEditing ? null : nameField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _isEditing ? emailFieldEdit : emailField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _isEditing ? null : nikField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: _isEditing ? noHPFieldEdit : noHPField,
            ),
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? 10 : 0),
              child: _isEditing ? _changePassword ? oldPassword : changePassword : null,
            ),
            Padding(
              padding: EdgeInsets.only(top: _isEditing ? 10 : 0),
              child: _isEditing ? _changePassword ? newPassword : null : null,
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
          _username = value;
          _usernameValidation = _username.length >= 6 ? false : true;
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
          _nameValidation = _name.length >= 4 ? false : true;
          break;
        case TypeField.email:
          _email = value;
          _emailValidation = validateEmail(email: value);
          break;
        case TypeField.nik:
          _nik = value;
          _nikValidation = validateNIK(nik: value);
          break;
        case TypeField.noHp:
          _noHp = value;
          _noHpValidation = validatePhone(phone: value);
          break;
      }
    });
  }

}
