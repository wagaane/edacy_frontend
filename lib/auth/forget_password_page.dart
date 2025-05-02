import 'package:flutter/material.dart';

import '../helpers/color_helper.dart';
class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(gradient: ColorHelper.gradiant),));
  }
}
