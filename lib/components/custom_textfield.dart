import 'package:fastpedia/main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomTextFields extends StatefulWidget {
  final TextInputAction textInputAction;
  final String label;
  final String hintText;
  final Widget icon;
  final bool autoCorrect;
  final Function onFiledSubmitted;
  final Function onChanged;
  final FocusNode focusNode;
  final double width;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final String borderColor;
  String errorMessage;
  bool secret;
  bool isHidePassword;
  bool autoFocus;
  bool isError;
  String initialValue;
  bool readOnly;

  CustomTextFields({
    @required
    this.textInputAction,
    this.label,
    this.hintText,
    this.icon,
    this.secret,
    this.autoCorrect,
    this.onFiledSubmitted,
    this.onChanged,
    this.focusNode,
    this.width,
    this.keyboardType,
    this.textCapitalization,
    this.isError,
    this.controller,
    this.errorMessage,
    this.autoFocus,
    this.isHidePassword = false,
    this.initialValue,
    this.readOnly = false,
    this.borderColor
  });

  @override
  _CustomTextFieldsState createState() => _CustomTextFieldsState();
}

class _CustomTextFieldsState extends State<CustomTextFields> {
  double bottomToError = 12;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: Responsive.width(widget.width, context),
      child: TextFormField(
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        obscureText: widget.secret,
        autocorrect: widget.autoCorrect,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        onChanged: widget.onChanged,
        autofocus: null == bool ? widget.autoFocus : false,
        onFieldSubmitted: widget.onFiledSubmitted,
        controller: null == TextEditingController ? widget.controller : null,
        initialValue: widget.initialValue != null ? widget.initialValue : null,
        readOnly: widget.readOnly ? widget.readOnly : false,
        decoration: InputDecoration(
            prefixIcon: widget.icon,
            errorMaxLines: 5,
            suffixIcon: widget.label == "password" || widget.label == "password lama" || widget.label == "password baru" ? GestureDetector(
              child: Icon(
                widget.isHidePassword ? Icons.visibility_off : Icons.visibility,
                color: widget.borderColor != null ? Hexcolor(widget.borderColor) : Colors.white,
              ),
              onTap: () {
                setState(() {
                  widget.isHidePassword = !widget.isHidePassword;
                  widget.secret = !widget.secret;
                });
              },
            ) : null,
            labelText: widget.label,
            labelStyle: TextStyle(
              color: widget.borderColor != null ? Hexcolor(widget.borderColor) : Colors.white
            ),
            border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: widget.borderColor != null ? Hexcolor(widget.borderColor) : Colors.white,
                  width: 3
              ),
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                style: BorderStyle.solid,
                color: widget.borderColor != null ? Hexcolor(widget.borderColor) : Colors.white,
                width: 3
              )
            ),
            focusedBorder: new OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: widget.borderColor != null ? Hexcolor(widget.borderColor) : Colors.white,
                    width: 3
                )
            ),
            hintStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            errorText: widget.isError ? widget.errorMessage : null,
        ),
      ),
    );
  }
}

class CustomTextFieldsSecondary extends StatefulWidget{
  final TextInputAction textInputAction;
  final String label;
  final String hintText;
  final Widget icon;
  final bool autoCorrect;
  final Function onFiledSubmitted;
  final Function onChanged;
  final FocusNode focusNode;
  final double width;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  String errorMessage;
  bool secret;
  bool isHidePassword;
  bool autoFocus;
  bool isError;
  String initialValue;
  bool readOnly;
  FlatButton suffixButton;

  CustomTextFieldsSecondary({
    @required
    this.textInputAction,
    this.label,
    this.hintText,
    this.icon,
    this.secret,
    this.autoCorrect,
    this.onFiledSubmitted,
    this.onChanged,
    this.focusNode,
    this.width,
    this.keyboardType,
    this.textCapitalization,
    this.isError,
    this.controller,
    this.errorMessage,
    this.autoFocus,
    this.isHidePassword = false,
    this.initialValue,
    this.readOnly = false,
    this.suffixButton
  });

  @override
  _CustomTextFieldsStateSecondary createState() => _CustomTextFieldsStateSecondary();
}

class _CustomTextFieldsStateSecondary extends State<CustomTextFieldsSecondary> {
  double bottomToError = 12;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: Responsive.width(widget.width, context),
      child: TextFormField(
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        obscureText: widget.secret,
        autocorrect: widget.autoCorrect,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        onChanged: widget.onChanged,
        autofocus: null == bool ? widget.autoFocus : false,
        onFieldSubmitted: widget.onFiledSubmitted,
        controller: null == TextEditingController ? widget.controller : null,
        initialValue: widget.initialValue != null ? widget.initialValue : null,
        readOnly: widget.readOnly ? widget.readOnly : false,
        style: TextStyle(
          fontSize: Responsive.width(4, context),
          color: Hexcolor("#4EC24C")
        ),
        decoration: InputDecoration(
            prefixIcon: widget.icon,
            errorMaxLines: 5,
            suffixIcon: widget.suffixButton != null ? widget.suffixButton : null,
            labelText: widget.label,
            hintStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            errorText: widget.isError ? widget.errorMessage : null
        ),
      ),
    );
  }
}