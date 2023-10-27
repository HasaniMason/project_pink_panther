import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatefulWidget {

  Color? iconColor;
  String hintText;
  TextEditingController controller;

  InputTextFieldWidget(
      {super.key,
       required this.controller,
        required this.hintText,
        this.iconColor});

  @override
  State<InputTextFieldWidget> createState() =>
      _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends State<InputTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 8.0, bottom: 8.0),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: widget.hintText,
            suffixStyle: TextStyle(color: Theme.of(context).primaryColor),
            iconColor: widget.iconColor ?? Theme.of(context).primaryColor,  //use selected color. If not specified use primary app color
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary,width: 9),
                borderRadius: BorderRadius.circular(24))),
      ),
    );
  }
}