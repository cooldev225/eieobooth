import 'package:easyguard/public/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/back-button.dart';

Widget user(BuildContext context, String userName, String houseId) {
  return Container(
    // decoration: BoxDecoration(border: Border.all(width: 1)),
    padding: EdgeInsets.only(left: 18.sp, top: 12.sp, bottom: 12.sp),
    // height: height * 0.0,
    child: Row(
      children: <Widget>[
        backButton(context),
        Icon(
          Icons.home,
          size: 84.sp,
          color: color_main,
        ),
        Padding(
          padding: EdgeInsets.only(left: 24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(fontSize: 32.sp, color: color_main),
              ),
              Text(
                houseId,
                style: TextStyle(
                  fontSize: 32.sp,
                  color: color_green,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
