import 'package:auto_size_text/auto_size_text.dart';
import 'package:commons/commons.dart';
import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/enums.dart';
import 'package:fastpedia/model/user.dart';
import 'package:fastpedia/services/user_provider.dart';
import 'package:fastpedia/services/validation.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // login components
  String _username, _password;
  bool _usernameValidation = false;
  bool _passwordValidation = false;
  List<String> _validateMessageError = [];

  // states login
  bool _isLogin = true;
  bool _isActive = false;
  bool _isLogging = false;

  // states register
  String _name, _email, _nik, _noHp;
  bool _nameValidation = false;
  bool _emailValidation = false;
  bool _nikValidation = false;
  bool _noHpValidation = false;

  // check if text fields is active
  FocusNode _focusUsername = new FocusNode();
  FocusNode _focusPassword = new FocusNode();

  // focus node register
  FocusNode _focusName = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusNIK = new FocusNode();
  FocusNode _focusHP = new FocusNode();

  bool _keyboardVisible = false;

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
      if (_isLogin) {
        _isActive = _focusPassword.hasFocus || _focusUsername.hasFocus ? true : false;
      } else {
        _isActive = _focusName.hasFocus || _focusEmail.hasFocus || _focusNIK.hasFocus || _focusHP.hasFocus || _focusUsername.hasFocus || _focusPassword.hasFocus ? true : false;
      }
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
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    // function register call
    var doRegister = () {
      if (_nameValidation || _emailValidation || _nikValidation || _noHpValidation || _usernameValidation || _passwordValidation || _name == null || _email == null || _nik == null || _noHp == null || _username == null || _password == null) {
        errorDialog(context, "Form tidak valid!");
        return;
      }

      setState(() {
        _isLogging = true;
        _isActive = false;
      });

      final Future<Map<String, dynamic>> response = webService.register(name: _name, email: _email, nik: _nik, phone: _noHp, username: _username, password: _password);
      response.then((res) {
        if (res['status']) {
          successDialog(context, res['message'].toString(),
              title: "Register Sukses"
          );
        } else {
          errorDialog(context, res['message'].toString(),
            title: "Register Gagal",
          );
        }

        setState(() {
          _isLogging = false;
          _isLogin = true;
        });
      });
    };

    // Login function when pressed
    var doLogin = () {
      if (_usernameValidation || _passwordValidation || _username == null || _password == null) {
        errorDialog(context, "Form tidak valid!");
        return;
      }

      setState(() {
        _isLogging = true;
        _isActive = false;
      });

      final Future<Map<String, dynamic>> successfulMessage = webService.signIn(username: _username, password: _password);

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

          errorDialog(context, response['message'].toString(),
              title: "Login Gagal"
          );
        }
      });
    };

    void registerWrappingFunction() {
      if(_usernameValidation || _passwordValidation || _nameValidation || _emailValidation || _nikValidation || _noHpValidation) {
        String showErrorMessage = "";

        setState(() {
          if(_usernameValidation) {
            _validateMessageError.add("username at least 6 char");
          }
          if (_passwordValidation) {
            _validateMessageError.add("password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.");
          }
          if (_nameValidation) {
            _validateMessageError.add("masukan nama sesua ktp");
          }
          if (_emailValidation) {
            _validateMessageError.add("email tidak valid");
          }
          if (_nikValidation) {
            _validateMessageError.add("nik tidak valid");
          }
          if (_noHpValidation) {
            _validateMessageError.add("no hp tidak valid");
          }
        });

        _validateMessageError.asMap().forEach((index, value) {
          showErrorMessage += "${1 + index }. $value.\n";
        });

        errorDialog(context, showErrorMessage,
          title: "Register Gagal",
          textAlign: TextAlign.start,
          negativeText: "Coba Lagi",
        );
      } else {
        confirmationDialog(
            context,
            """
1.Definisi
1.A Aplikasi Fastpedia adalah aplikasi perangkat lunak yang menyediakan layanan edukasi digital, yang dapat
digunakan oleh masyarakat umum.


2.Pendaftaran Akun
2.A Sebelum pengguna menggunakan Aplikasi Fastpedia, pengguna diwajibkan untuk melakukan pendaftaran melalui Aplikasi Fastpedia. Pengguna diwajibkan mengisi data Nama sesuai dengan identitas diri, Email, NIK, Nomor Telepon, Nama Pengguna, dan Password.

2.B Dengan mendaftar di Aplikasi Fastpedia, pengguna telah menyetujui semua kebijakan yang telah ditetapkan oleh developer Aplikasi Fastpedia

2.C Perubahan data hanya untuk memperbaharui informasi sesuai dengan akurasi data yang dimiliki pengguna. Perubahan data hanya bisa dilakukan untuk perubahan data Email, Nomor Telepon, dan Password.

2.D Pengguna dilarang untuk mengungkapkan informasi login kepada pihak ketiga atau manapun. Developer Aplikasi Fastpedia tidak pernah meminta informasi data login pengguna melalui media cetak maupun elektronik

2.E Pengguna dilarang untuk memperjual belikan akun kepada pihak ketiga atau pihak manapun.


3. Ketentuan Penggunaan Aplikasi
3.A Fastpedia memberikan beberapa layanan, diantaranya Mining Ads, History, Wallet, dan Transfer Scan Barcode.

3.B Layanan tersebut dapat berubah dari waktu ke waktu, selama developer aplikasi memperbaharui, memperbaiki, memodifikasi, dan menambahkan fitur pada Aplikasi Fastpedia.

3.C Pengguna dapat menggunakan layanan tersebut ketika pengguna telah berhasil dan terdaftar pada Aplikasi Fastpedia.

3.D Pengguna wajib menginformasikan kepada kami, jika pengguna tidak lagi memiliki kontrol terhadap akun Aplikasi Fastpedia, atau terkait peretasan (Hack Acccount), sehingga kami dapat membekukan akun pengguna sampai benar-benar kami memverifikasi kebenaran akun yang dimiliki.

3. EPada fitur Mining Ads, anda diwajibkan Menonton dan Men-Subcribe pengguna lainnya. Pengguna akan diminta untuk melakukan login akun Youtube.

3.F Login akun Youtube telah kami buat secara penghubungan langsung antara Youtube dengan Pengguna

3.G Pengguna telah mengatahui, bahwa Developer Aplikasi tidak pernah mengetahui segala aktifitas Akun Youtube pengguna setelah melakukan Login Akun Youtube yang dilakukan pada Aplikasi Fastpedia.


4. Tanggung Jawab
4.A Pengguna bertanggung jawab atas segala aktifitas pada Aplikasi Fastpedia, meskipun akun tersebut disalahgunakan oleh orang lain

4.B Pengguna bertanggung jawab atas akurasi data yang di isi oleh pengguna, pada "Form Register" Aplikasi Fastpedia.

4.C Pengguna bertanggung jawab atas kelangsungan aktivasi akun yang terhubung dengan pihak ketiga pada aplikasi Fastpedia

5. Ganti Rugi
5.A Dengan melakukan pendaftaran pada Aplikasi Fastpedia, pengguna telah mengetahui dan menyetujui bahwa Developer Aplikasi Fastpedia tidak bertanggung jawab terhadap aktivasi dan pemblokiran akun Youtube diluar kendali Developer Aplikasi Fastpedia.
                  """,
            title: "Syarat dan Ketentuan!",
            textAlign: TextAlign.start,
            positiveText: 'Setuju',
            positiveAction: () {
              doRegister();
            },
            negativeText: "Tidak",
            confirmationText: "saya setuju atas semua pernyataan tsb..",
            showNeutralButton: false
        );
      }
    }

    void validation ({TypeField type, String value}) {
      setState(() {
        switch (type) {
          case TypeField.username:
            _username = value;
            _usernameValidation = _isLogin ? _username.length >= 3 ? false : true : _username.length >= 6 ? false : true;
            break;
          case TypeField.password:
            _password = value;
            _passwordValidation = validatePassword(password: value);
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

    // fields everything
    final usernameField = CustomTextFields(
      textInputAction: TextInputAction.next,
      secret: false,
      hintText: 'Input your username',
      icon: Icon(Icons.person, color: Colors.white,),
      width: 80,
      label: 'username',
      onChanged: (val) => validation(type: TypeField.username, value: val),
      focusNode: _focusUsername,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _focusUsername.unfocus();
        FocusScope.of(context).requestFocus(_focusPassword);
      },
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      errorMessage: 'username at least ${_isLogin ? '3' : '6'} char',
      isError: _usernameValidation,
    );

    final passwordField = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      hintText: 'Input Your password',
      icon: Icon(Icons.lock, color: Colors.white,),
      width: 80,
      label: 'password',
      onChanged: (val) => validation(type: TypeField.password, value: val),
      focusNode: _focusPassword,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        if (_isLogin) {
          _focusPassword.unfocus();
          doLogin();
        } else {
          setState(() {
            _isActive = true;
          });
          registerWrappingFunction();
        }
      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: "password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.",
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            setState(() {
              _isActive = false;
              _isLogin = true;
            });
            _focusName.unfocus();
            _focusEmail.unfocus();
            _focusNIK.unfocus();
            _focusHP.unfocus();
            _focusUsername.unfocus();
            _focusPassword.unfocus();
          },
        ),
        FlatButton(
          child: Text(_isLogin ? 'Login' : 'Register',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white
            ),
          ),
        ),
      ],
    );

    ButtonTheme buttonSignInOrSignUp = ButtonTheme(
        minWidth: Responsive.width(80, context),
        height: 56,
        child: RaisedButton(
          child: Text(
            _isLogin ? 'Login' : 'Register',
            style: TextStyle(
                fontSize: 16,
                color: Hexcolor("#4EC24C"),
                letterSpacing: 0.3
            ),
          ),
          padding: EdgeInsets.all(8.0),
          color: Hexcolor("#FFFFFF"),
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onPressed: () async {
            if (_isLogin) {
              doLogin();
            } else {
              registerWrappingFunction();
            }
          },
        )
    );

    SingleChildScrollView loginOrRegister = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: usernameField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: passwordField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: buttonSignInOrSignUp,
            )
          ],
        ),
      ),
    );

    final Column loginFields = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: textLoginOrRegister,
        ),
        Expanded(
          child: loginOrRegister,
        ),
        Visibility(
          visible: !_keyboardVisible,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                "Belum mempunyai akun?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300
                ),
                maxFontSize: 16,
                minFontSize: 10,
              ),
              FlatButton(
                child: AutoSizeText(
                  "Register Sekarang",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline
                  ),
                  maxFontSize: 16,
                  minFontSize: 10,
                ),
                onPressed: () {
                  setState(() {
                    _isLogin = false;
                    _isActive = true;
                  });
                  FocusScope.of(context).requestFocus(_focusName);
                },
              )
            ],
          ),
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
      icon: Icon(
        Icons.person,
        color: Colors.white,
      ),
      secret: false,
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
      icon: Icon(
        Icons.email,
        color: Colors.white,
      ),
      secret: false,
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
      errorMessage: 'masukan NIK anda yang valid',
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusNIK,
      label: 'NIK',
      width: 80,
      icon: Icon(
        MaterialCommunityIcons.file_document_outline,
        color: Colors.white,
      ),
      secret: false,
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
      errorMessage: 'no hp tidak valid, 08xxxxxxxxxx',
      keyboardType: TextInputType.phone,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusHP,
      label: 'phone number',
      width: 80,
      icon: Icon(
        Icons.phone_android,
        color: Colors.white,
      ),
      secret: false,
      onFiledSubmitted: (val) {
        _focusHP.unfocus();
        FocusScope.of(context).requestFocus(_focusUsername);
      },
      onChanged: (val) {
        validation(value: val, type: TypeField.noHp);
      },
    );

    SingleChildScrollView filedForRegister = SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
              padding: EdgeInsets.only(top: 10),
              child: usernameField,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: passwordField,
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: buttonSignInOrSignUp
            )
          ],
        ),
      ),
    );


    Column registerFields = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: textLoginOrRegister,
        ),
        Expanded(
          child: filedForRegister,
        )
      ],
    );

    Column buttonLoginRegister = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ButtonTheme(
          minWidth: Responsive.width(80, context),
          height: 56,
          child: RaisedButton(
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: 0.3
              ),
            ),
            padding: EdgeInsets.all(8),
            textColor: Colors.white,
            color: Hexcolor("#4EC24C"),
            splashColor: Colors.green,
            animationDuration: Duration(seconds: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Hexcolor("#FFFFFF"), width: 3)
            ),
            onPressed: () {
              setState(() {
                _isLogin = true;
                _isActive = true;
              });
              FocusScope.of(context).requestFocus(_focusUsername);
            },
          ),
        ),
        ButtonTheme(
          minWidth: Responsive.width(80, context),
          height: 56,
          child: RaisedButton(
            child: Text(
              "Register",
              style: TextStyle(
                  color: Hexcolor("#4EC24C"),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 0.3
              ),
            ),
            padding: EdgeInsets.all(8),
            color: Hexcolor("#FFFFFF"),
            splashColor: Colors.green,
            animationDuration: Duration(seconds: 1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Hexcolor("#4EC24C"))
            ),
            onPressed: () {
              setState(() {
                _isLogin = false;
                _isActive = true;
              });
              FocusScope.of(context).requestFocus(_focusName);
            },
          ),
        )
      ],
    );

    AnimatedContainer fields = AnimatedContainer(
      duration: Duration(milliseconds: 1500),
      curve: Curves.ease,
      child: _isActive ? _isLogin ? loginFields : registerFields : buttonLoginRegister,
      width: Responsive.width(100, context),
      decoration: BoxDecoration(
          color: Hexcolor("#4EC24C"),
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
      child: Stack(
        children: [
          Image(
            image: AssetImage('bg-login.png'),
            height: Responsive.height(100, context),
            width: Responsive.width(100, context),
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image(image: AssetImage('fast-logo-fix.png'),),
                ),
                flex: _isActive ? 1 : 3,
              ),
              Expanded(
                  flex: _isActive ? _isLogin ? 1 : 3 : 1,
                  child: fields
              ),
            ],
          )],
      ),
    );

    // WIDGET BODY
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: _isLogging ? loading : modernDesign
    );
  }
}