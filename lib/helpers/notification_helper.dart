import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color_helper.dart';

class NotificationHelper{
  static Future<bool?> showNotification(msg,{position = ToastGravity.TOP,status = 'OK'}){
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity:   position,
        timeInSecForIosWeb: 1,
        backgroundColor: status == 'OK' ? ColorHelper.blackWithOpacity06 : ColorHelper.redWithOpacity06,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}