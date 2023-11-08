import 'package:flutter/material.dart';

class TextFieldWithSuffixIcon extends StatefulWidget {
  Icon suffixIcon;
  Color? iconColor;
  String hintText;
  TextEditingController textEditingController;
  bool passwordText;

  TextFieldWithSuffixIcon(
      {super.key,
      required this.suffixIcon,
      required this.hintText,
      this.iconColor,
      required this.textEditingController,
      required this.passwordText});

  @override
  State<TextFieldWithSuffixIcon> createState() =>
      _TextFieldWithSuffixIconState();
}

class _TextFieldWithSuffixIconState extends State<TextFieldWithSuffixIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
      child: TextField(
        obscureText: widget.passwordText,
        controller: widget.textEditingController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
            suffixIcon: widget.suffixIcon,
            iconColor: widget.iconColor ?? Theme.of(context).primaryColor,  //use selected color. If not specified use primary app color
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(24))),
      ),
    );
  }
}
