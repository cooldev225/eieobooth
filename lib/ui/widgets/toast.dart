import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/public/colors.dart';
showToast(msg) {
   Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: color_red_weak,
          textColor: Colors.white,
          fontSize: 16.0);
}