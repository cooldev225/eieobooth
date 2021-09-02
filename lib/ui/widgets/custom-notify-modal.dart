import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNotify extends StatefulWidget {
  final message;
  @override
  _CustomNotifyState createState() => _CustomNotifyState(data: message);
  CustomNotify({@required this.message});
}

class _CustomNotifyState extends State<CustomNotify>
    with SingleTickerProviderStateMixin {
  dynamic data;
  _CustomNotifyState({@required this.data});
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
        height: 300.sp,
        width: 600.sp,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            sendButton(context, SitLocalizations.of(context).retur(),
                color_white, color_blue, 120.sp, 32.sp, onReturn),
          ],
        ));
  }

  void onReturn() async {
    return Navigator.of(context).pop();
  }
}
