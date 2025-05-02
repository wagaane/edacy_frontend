import 'package:flutter/material.dart';
class AddTaskTextField extends StatefulWidget {
  final hintText;
  final labelText;
  final controller;
  final maxLine;
  const AddTaskTextField({super.key, this.hintText, this.labelText, this.controller, this.maxLine});

  @override
  State<AddTaskTextField> createState() => _AddTaskTextFieldState();
}

class _AddTaskTextFieldState extends State<AddTaskTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLine,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          labelText: widget.labelText,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              )),
          border: const OutlineInputBorder()),
    );
  }
}
