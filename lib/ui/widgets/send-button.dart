import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

Widget sendButton(BuildContext context, caption, textColor, color, double width,
    fontSize, onTap) {
  return RaisedButton(
    color: color,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    onPressed: onTap,
    textColor: textColor,
    child: Container(
      alignment: Alignment.center,
      width: width,
      padding:
          EdgeInsets.only(top: 0.sp, bottom: 0.sp, left: 8.sp, right: 8.sp),
      child: Text(caption, style: TextStyle(fontSize: fontSize)),
    ),
  );
}
