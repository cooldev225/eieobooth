import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEndBox extends StatefulWidget {
  final message;
  @override
  _CustomEndBox createState() => _CustomEndBox(data: message);
  CustomEndBox({@required this.message});
}

class _CustomEndBox extends State<CustomEndBox>
    with SingleTickerProviderStateMixin {
  dynamic data;
  _CustomEndBox({@required this.data});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    var decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.sp)),
        color: color_white);
    var titleStyle = TextStyle(color: color_main, fontSize: 32.sp);
    return Container(
        height: 280.sp,
        width: 800.sp,
        decoration: decoration,
        padding: EdgeInsets.only(
            top: 24.sp, bottom: 12.sp, left: 10.sp, right: 10.sp),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  data,
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 0, left: 10.sp, right: 10.sp),
              ),
              buttonArea()
            ]));
  }

  Widget buttonArea() {
    return Container(
        padding: EdgeInsets.only(top: 12.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            sendButton(context, SitLocalizations.of(context).endVisit(),
                color_white, color_blue, 160.sp, 28.sp, onEnd),
            sendButton(context, SitLocalizations.of(context).comeback(),
                color_white, color_blue, 160.sp, 28.sp, onGoout),
            sendButton(context, SitLocalizations.of(context).cancel(),
                color_white, color_red_weak, 140.sp, 28.sp, onReturn),
          ],
        ));
  }

  void onReturn() async {
    return Navigator.of(context).pop(0);
  }

  void onGoout() async {
    return Navigator.of(context).pop(1);
  }

  void onEnd() async {
    return Navigator.of(context).pop(2);
  }
}
