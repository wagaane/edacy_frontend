import 'package:flutter/material.dart';

class ColorHelper{
  static var gradiant =  const LinearGradient(
    colors: [
      Colors.yellow,
      Colors.white,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static var yelloColor = Colors.yellow;
  static var whiteColor = Colors.white;
  static var blackColor = Colors.black;
  static var blackWithOpacity06 = Colors.black.withOpacity(0.6);
  static var redWithOpacity06 = Colors.red.withOpacity(0.6);

}