import 'dart:async';
import 'dart:io';

import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/appbar.dart';
import 'package:easyguard/ui/widgets/main-scan.dart';
import 'package:easyguard/ui/widgets/notification-popup.dart';
import 'package:easyguard/ui/widgets/schedule.dart';
import 'package:easyguard/ui/widgets/main_resident.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easyguard/public/eieoIcons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/notification-home.dart';
import 'package:loading_overlay/loading_overlay.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _selected = 0;
  var badge = 0;
  var deviceId;
  var notificationDialogActive = false;
  var fcm = FirebaseMessaging();
  var dialog;
  var modal;
  StreamSubscription iosSubscription;
  var notificationsHome;
  List<Widget> homes = [
    MainResident(),
    Container(),
    Schedule(),
    Container(),
    MainScan(),
    Container(),
    NotificationsHome()
  ];
  @override
  void initState() {
    super.initState();

    notificationsHome = homes[6];
    initAll();
  }

  initAll() async {
    if (Platform.isIOS) {
      iosSubscription = fcm.onIosSettingsRegistered.listen((data) async {
        deviceId = await fcm.getToken();
        fcm.configure(
            onMessage: onMessage, onLaunch: onLaunch, onResume: onResume);
      });

      fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      fcm.configure(
          onMessage: onMessage, onLaunch: onLaunch, onResume: onResume);
    }
  }

  Future<dynamic> onMessage(message) async {
    setState(() {
      badge++;
    });
    if (notificationDialogActive) {
      dialog.title = message['notification']['title'];
      dialog.message = message['notification']['body'];

      setState(() {
        dialog.reload();
      });
      return;
    }
    notificationDialogActive = true;
    dialog = NotificationPopup(
      // message: SitLocalizations.of(context).haveNewNotifications(),
      title: message['notification']['title'],
      message: message['notification']['body'],
      // title: SitLocalizations.of(context)
      //     .notificationType(int.parse(message['data']['type'])),
    );
    var returned = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp)),
          child: dialog),
    );
    notificationDialogActive = false;
    if (returned) {
      // showDialog(context: context, builder: (context)=>NotificationsHome());
      notificationsHome = homes[6];
      if (_selected == 6) {
        notificationsHome.reload();
      }
      setState(() {
        badge = 0;
        _selected = 6;
      });
    }
  }

  Future<dynamic> onResume(message) async {
    if (_selected == 3) {
      notificationsHome.reload();
    }
    setState(() {
      badge = 0;
      _selected = 6;
    });
  }

  Future<dynamic> onLaunch(message) async {
    var result = await get('notifications/count', context);
    if (!result['success']) return;
    if (result['result'] == 0) return;
    setState(() {
      badge = result['result'];
    });
    dialog = NotificationPopup(
        title: '',
        message: SitLocalizations.of(context).haveNewNotifications(badge));
    notificationDialogActive = true;
    var returned = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp)),
          child: dialog),
    );
    notificationDialogActive = false;
    if (returned) {
      notificationsHome = homes[6];
      if (_selected == 6) {
        notificationsHome.reload();
      }
      setState(() {
        badge = 0;
        _selected = 6;
      });
    }
  }

  onBottomNavBarTap() {}
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var textStyle = TextStyle(fontSize: 24.sp);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: LoadingOverlay(
          isLoading: false,
          color: color_blue_weak,
          child: new Align(
              alignment: Alignment.topLeft,
              child: new SafeArea(
                bottom: true,
                top: true,
                left: true,
                right: true,
                child: home(_selected, context),
              ))),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: color_gray,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 64.sp,
              ),
              title:
                  Text(SitLocalizations.of(context).users(), style: textStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 0), title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.event, size: 60.sp),
              title: Text(SitLocalizations.of(context).schedule(),
                  style: textStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 0), title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(EieoIcons.scan, size: 40.sp),
              title:
                  Text(SitLocalizations.of(context).scan(), style: textStyle)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 0), title: Text('')),
          BottomNavigationBarItem(
            icon: new Stack(children: <Widget>[
              Icon(Icons.notifications, size: 60.sp),
              Positioned(
                  // draw a red marble
                  top: 0.0,
                  right: 0.0,
                  child: badge > 0
                      ? Container(
                          width: 28.sp,
                          height: 28.sp,
                          child: new Center(
                              child: Text("$badge",
                                  style: TextStyle(
                                      color: color_white, fontSize: 18.sp))),
                          decoration: BoxDecoration(
                              color: color_red_weak,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.sp))),
                        )
                      : Container())
            ]),
            title: Text(SitLocalizations.of(context).notifications(),
                style: textStyle),
          )
        ],
        currentIndex: _selected,
        selectedItemColor: color_main,
        onTap: onBottomTap,
      ),

      // body: EditProfile(),
    );
  }

  Widget home(index, context) {
    return Column(children: <Widget>[
      appbar(context, null),
      Expanded(child: homes.elementAt(index))
    ]);
  }

  onBottomTap(value) async {
    if (value == 6) {
      badge = 0;
    }

    if (value % 2 == 1) return;
    if (value == _selected) {
      setState(() {
        _selected = (value + 1) % 7;
      });
      await Future.delayed(Duration(milliseconds: 10));
      setState(() {
        _selected = value;
      });
    } else {
      setState(() {
        _selected = value;
      });
    }
    // controller.animateToPage(value, duration: Duration(milliseconds:500), curve: Curves.easeInOut);
  }
}
