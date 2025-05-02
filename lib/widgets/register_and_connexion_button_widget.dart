import 'package:flutter/material.dart';
class RegisterAndConnexionButtonWidget extends StatefulWidget {
  final textButton;
  final backgroundButton;
  final textColor;
  final fontSize;
  const RegisterAndConnexionButtonWidget({super.key, this.textButton, this.backgroundButton, this.textColor, this.fontSize = 18.0});

  @override
  State<RegisterAndConnexionButtonWidget> createState() => _RegisterAndConnexionButtonWidgetState();
}

class _RegisterAndConnexionButtonWidgetState extends State<RegisterAndConnexionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration:  BoxDecoration(color: widget.backgroundButton, borderRadius: const BorderRadius.all(Radius.circular(10))),
      child:  Center(child: Text(widget.textButton.toString(), style:  TextStyle(color: widget.textColor, fontSize: widget.fontSize,),),),
    );
  }
}
