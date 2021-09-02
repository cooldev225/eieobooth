import 'package:easyguard/public/colors.dart';
import 'package:easyguard/ui/widgets/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget appbar(BuildContext context, bool showButton) {
  return clipShape(context, showButton);
}

Widget clipShape(context, showButton) {
  ScreenUtil.init(context);
  return Container(
      height: 240.h,
      child: Stack(children: <Widget>[
        Container(
            height: 240.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/header2.png")),
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 18.sp),
                    height: 200.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image:
                                AssetImage("assets/images/easylogowhite.png"))),
                  ),
                  Text('EASY IN EASY OUT',
                      style: TextStyle(fontSize: 80.sp, color: color_white),
                      textAlign: TextAlign.right)
                ])),
        showButton == null
            ? Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => Settings()));
                    },
                    child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(top: 20.sp, left: 20.sp),
                        child: Icon(Icons.settings,
                            color: color_white, size: 60.sp))))
            : Container()
      ]));
}
