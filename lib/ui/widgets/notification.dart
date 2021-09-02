import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/eieoIcons.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:easyguard/ui/widgets/send-visitor.dart';
import 'package:easyguard/ui/widgets/send-message.dart';
import 'package:easyguard/ui/widgets/username.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  final resident;
  Notifications({@required this.resident});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  var _resident;
  var onTap;

  @override
  void initState() {
    super.initState();
  }

  load() async {
    _resident = widget.resident;
    // await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(children: <Widget>[
              user(context, _resident['user_id']['full_name'],
                  _resident['house_id']),
              notifyArea()
            ]);
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: color_blue_weak_half_trans,
            ));
          }
        });
  }

  Widget notifyArea() {
    List<dynamic> widgetList = [
      {
        "title": SitLocalizations.of(context).transport(),
        "icon": EieoIcons.transport,
        "index": 0
      },
      {
        "title": SitLocalizations.of(context).parcel(),
        "icon": EieoIcons.parcel,
        "index": 1
      },
      {
        "title": SitLocalizations.of(context).food(),
        "icon": EieoIcons.food,
        "index": 2
      },
      {
        "title": SitLocalizations.of(context).pet(),
        "icon": Icons.pets,
        "index": 3
      },
      {
        "title": SitLocalizations.of(context).health(),
        "icon": EieoIcons.health,
        "index": 4
      },
      {
        "title": SitLocalizations.of(context).message(),
        "icon": Icons.message,
        "index": 5
      },
      {
        "title": SitLocalizations.of(context).guest(),
        "icon": Icons.group,
        "index": 6
      },
      {
        "title": SitLocalizations.of(context).service(),
        "icon": EieoIcons.service,
        "index": 7
      },
    ];
    return Expanded(
        child: Container(
            child: GridView.count(
      crossAxisCount: 3,
      padding:
          EdgeInsets.only(left: 80.w, right: 80.w, top: 64.sp, bottom: 64.sp),
      crossAxisSpacing: 80.w,
      mainAxisSpacing: 80.h,
      primary: true,
      children: widgetList
          .map((e) => notifyButton(e["title"], e["icon"], e["index"]))
          .toList(),
    )));
  }

  Widget notifyButton(String title, IconData icon, index) {
    return new GestureDetector(
        onTap: () {
          onTapButton(index);
        },
        child: Container(
          // height: 120.sp,
          decoration: BoxDecoration(
            color: color_white,
            borderRadius: BorderRadius.circular(16.sp),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 4.sp), //(x,y)
                blurRadius: 4.sp,
              ),
            ],
          ),
          padding: EdgeInsets.all(6.sp),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // padding: EdgeInsets.only(bottom: 18, top: 18),
                Icon(
                  icon,
                  color: color_green,
                  size: 100.w,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 32.sp, color: color_green),
                )
              ]),
        ));
  }

  onTapButton(index) {
    switch (index) {
      case 0:
        sendResidentNotify(0);
        break;
      case 1:
        sendResidentNotify(1);
        break;
      case 2:
        sendResidentNotify(2);
        break;
      case 3:
        sendResidentNotify(3);
        break;
      case 4:
        sendResidentNotify(4);
        break;
      case 5:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SendMessage(resident: _resident)));

        break;
      case 6:
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SendVisitor(resident: _resident)));

        break;
      case 7:
        sendResidentNotify(7);
        break;
      default:
        break;
    }
  }

  sendResidentNotify(type) async {
    var msgBox;
    var dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: msgBox = CustomMsgBox(
          data: userNotifyMsg(context, type, _resident['user_id']['full_name']),
          success: SitLocalizations.of(context).notificationSentSuccessful(),
          failure: SitLocalizations.of(context).notificationSentFailure(),
          initialState: NORMAL),
    );
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );
    if (!result) {
      return;
    }
    msgBox.initialState = PENDING;
    dialog = Dialog(
      child: msgBox,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog);

    result = await post(
        'resident/notify',
        {
          'message': preDefinedMessages(type),
          'type': type,
          'resident_id': _resident['user_id']['_id'],
          'other': '',
          'is_img': false,
          'img': '',
          'is_service': false,
          'is_event': false,
          'is_favorite': false
        },
        context);
    if (result['success']) {
      msgBox.setState(SUCCESS);
    } else {
      msgBox.setState(FAILURE);
    }
  }
}
