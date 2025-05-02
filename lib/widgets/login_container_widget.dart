import 'package:flutter/material.dart';
class LoginContainerWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final controller;
  final prefixIcon;
  final obscureText;
  const LoginContainerWidget({super.key, required this.labelText, required this.hintText, this.prefixIcon, this.controller, this.obscureText = false});

  @override
  State<LoginContainerWidget> createState() => _LoginContainerWidgetState();
}

class _LoginContainerWidgetState extends State<LoginContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child:  TextField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
            labelText: widget.labelText,
            hintText: widget.hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black,width: 2)
            ),
            border:  const OutlineInputBorder(

            )
        ),
      ),
    );
  }
}
