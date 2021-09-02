import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPopup extends StatefulWidget {
  var title;
  var message;
  var reload;
  NotificationPopup({this.title, this.message});
  _NotificationPopup createState() => _NotificationPopup();
}

class _NotificationPopup extends State<NotificationPopup> {
  @override
  initState() {
    super.initState();
    widget.reload = reload;
  }

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Container(
          width: 600.sp,
          height: 240.sp,
          decoration: BoxDecoration(color: color_white),
          margin: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(widget.title,
                  style: TextStyle(color: color_main, fontSize: 32.sp)),
              Text(
                widget.message,
                style: TextStyle(color: color_green, fontSize: 28.sp),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    sendButton(context, SitLocalizations.of(context).show(),
                        color_white, color_blue, 180.sp, 28.sp, () {
                      return Navigator.of(context).pop(true);
                    }),
                    sendButton(context, SitLocalizations.of(context).retur(),
                        color_white, color_red_weak, 180.sp, 28.sp, () {
                      return Navigator.of(context).pop(false);
                    })
                  ])
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pop(false);
          return false;
        });
  }
}
