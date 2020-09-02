import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:commons/commons.dart';
import 'package:fastpedia/components/custom_textfield.dart';
import 'package:fastpedia/main.dart';
import 'package:fastpedia/model/enums.dart';
import 'package:fastpedia/model/points.dart';
import 'package:fastpedia/services/number_extension.dart';
import 'package:fastpedia/services/validation.dart';
import 'package:fastpedia/services/web_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class Transfer extends StatefulWidget {
  @override
  _Transfer createState() => _Transfer();
}

class _Transfer extends State<Transfer> {
  String _title = "Pilih Jenis Transfer";
  String _type;
  bool _isAmount = false;
  bool _amountError = false;
  bool _passwordError = false;
  String _password;
  bool _finish = false;
  String _amount;
  FocusNode _focusAmount = new FocusNode();
  FocusNode _focusPassword = new FocusNode();

  double _pedPoint;
  double _voucher;

  bool _isLoading = false;
  Timer _timer;


  void getData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WebService webService = Provider.of<WebService>(context, listen: false);
      Map<String, dynamic> response = await webService.getPoint();

      final Points points = response['data'];

      setState(() {
        _pedPoint = points.peds;
        _voucher = points.evoucher;
      });
    });
  }

  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    WebService webService = Provider.of<WebService>(context);

    final  Map<String, Object> receiveData = ModalRoute.of(context).settings.arguments;

    void transferFunction () async {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> response = await webService.transfer(password: _password, nominal: _amount, receiver: receiveData["username"], tipe: _type);

      if (response['status']) {
        successDialog(context, "Transfer Berhasil");

        if (_timer == null) {
          _timer = Timer(Duration(seconds: 2), () => Navigator.pop(context));
        } else {
          _timer.cancel();
          _timer = Timer(Duration(seconds: 2), () => Navigator.pop(context));
        }
      } else {
        errorDialog(context, response["message"]);
      }

      setState(() {
        _isLoading = false;
      });
    }

    final AppBar appBar = AppBar(
      title: Text(
        _title,
        style: TextStyle(
            color: Hexcolor("#FFFFFF"),
            fontSize: 20,
            fontWeight: FontWeight.w700
        ),
      ),
      centerTitle: false,
      backgroundColor: Hexcolor("#4EC24C"),
    );

    final ButtonTheme transferButton = ButtonTheme(
        minWidth: Responsive.width(90, context),
        height: Responsive.width(10, context),
        child: RaisedButton(
          child: Text(_finish ? _title : "Selanjutnya",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            if (_amount.toDouble() == 0.0) {
              errorDialog(context, "Nominal minimal 0.1");
              return null;
            }

            if (_type == "peds" && _amount.toDouble() > _pedPoint) {
              errorDialog(context, "Nominal melebihi ped point anda!");
              return null;
            }

            if (_type == "evoucher" && _amount.toDouble() > _voucher) {
              errorDialog(context, "Nominal melebihi voucher anda!");
              return null;
            }

            if (!_finish) {
              setState(() {
                _finish = true;
              });
            } else {
             confirmationDialog(
               context,
               "Dengan ini saya menyadari bahwa aksi ini tidak dapat dikembalikan!",
               positiveText: 'Setuju',
               positiveAction: () {
                 transferFunction();
               },
             );
            }
          },
          padding: EdgeInsets.all(8),
          textColor: Colors.white,
          color: Hexcolor("#4EC24C"),
          splashColor: Colors.green,
          animationDuration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.black)
          ),
        )
    );

    final Container containerCard = Container(
      width: Responsive.width(90, context),
      height: Responsive.height(15, context),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setState(() {
              _type = "peds";
              _isAmount = true;
              _title = "Transfer Point";
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("ped_poin_icon.png"),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText("Transfer Point",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      maxFontSize: 30,
                      minFontSize: 20,
                    ),
                    AutoSizeText("Ped Point Anda: ${_pedPoint != null ? Delimiters(_pedPoint).pointDelimiters() : "0.0"}",
                      maxFontSize: 20,
                      minFontSize: 16,
                    )
                  ],
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );

    final Container containerVoucherCard = Container(
      width: Responsive.width(90, context),
      height: Responsive.height(15, context),
      child: Card(
        elevation: 5,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setState(() {
              _type = "evoucher";
              _isAmount = true;
              _title = "Transfer Voucher";
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image: AssetImage("voucher_icon.png"),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoSizeText("Transfer Voucher",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                      maxFontSize: 30,
                      minFontSize: 20,
                    ),
                    AutoSizeText("Voucher Anda: ${_voucher != null ? Delimiters(_voucher).pointDelimiters() : "0.0"}",
                      maxFontSize: 20,
                      minFontSize: 16,
                    )
                  ],
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
      ),
    );

    final CustomTextFieldsSecondary amountField = CustomTextFieldsSecondary(
      textInputAction: TextInputAction.done,
      width: 80,
      autoFocus: true,
      secret: false,
      label: "",
      isError: _amountError,
      errorMessage: 'Nominal minimal 0.1',
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.none,
      autoCorrect: false,
      focusNode: _focusAmount,
      readOnly: false,
      onFiledSubmitted: (val) {
        _focusAmount.unfocus();
        setState(() {
          _amount = val;
        });
      },
      onChanged: (val) {
        setState(() {
          _amount = val;
        });
      },
    );

    final CustomTextFields passwordField = CustomTextFields(
      textInputAction: TextInputAction.done,
      secret: true,
      borderColor: "#4EC24C",
      hintText: 'Masukan Password',
      icon: Icon(Icons.lock, size: Responsive.width(4, context)),
      width: 80,
      label: 'password',
      onChanged: (val) => validation(type: TypeField.password, value: val),
      focusNode: _focusPassword,
      autoCorrect: false,
      onFiledSubmitted: (val) {
        _focusPassword.unfocus();
      },
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.text,
      errorMessage: "password harus mengandung minimal 8 karakter, satu huruf besar, satu huruf kecil, satu angka, dan satu simbol.",
      isError: _passwordError,
    );

    final Container containerAmount = Container(
      width: Responsive.width(90, context),
      height: _passwordError ? Responsive.height(27, context) : Responsive.height(20, context),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: AutoSizeText(_finish ? "Masukan Password" : "Masukan Jumlah Transfer",
                  style: TextStyle(fontWeight: FontWeight.w700),
                  maxFontSize: 25,
                  minFontSize: 20,
                ),
              ),
              Expanded(
                flex: 1,
                child: _finish ? passwordField : amountField
              ),
            ],
          ),
        ),
      ),
    );

    // TODO: implement build
    return Scaffold(
      appBar: appBar,
      body: _isLoading ? loadingScreen(context, loadingType: LoadingType.JUMPING) : _isAmount ? Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: containerAmount,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: transferButton,
            )
          ],
        ),
      ) : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            containerCard,
            containerVoucherCard
          ],
        ),
      ),
      backgroundColor: Hexcolor("#F6FAF5"),
    );
  }

  void validation ({TypeField type, String value}) {
    setState(() {
      switch (type) {
        case TypeField.password:
          _password = value;
          _passwordError = validatePassword(password: value);
          break;
      }
    });
  }
}