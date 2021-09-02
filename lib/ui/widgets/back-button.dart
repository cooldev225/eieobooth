import 'package:easyguard/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

Widget backButton(context, {onPressed}) {
  return Platform.isIOS
      ? Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.only(left: 20.sp, top: 8.sp, right: 20.sp),
              width: 64.sp,
              height: 64.sp,
              child: RaisedButton(
                  padding: EdgeInsets.all(0),
                  color: color_blue_weak,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  elevation: 1,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 44.sp,
                  ),
                  onPressed: () => onPressed == null
                      ? Navigator.pop(context)
                      : onPressed())))
      : Container();
}
