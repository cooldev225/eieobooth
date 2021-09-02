import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/eieoIcons.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/ui/widgets/toast.dart';

import 'package:intl/intl.dart';
import 'package:easyguard/public/lang.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  var reload;
  NotificationsScreen(reload);
  @override
  _NotificationsScreen createState() => _NotificationsScreen();
}

class _NotificationsScreen extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    widget.reload = reload;
    reload();
  }

  var isLoading = false;

  var notifications = [];
  DateTime currentBackPressTime;
  loadNotifications() async {
    var ns;
    var result = await post('notifications', {}, context);
    if (result['success']) {
      ns = result['result'];
    } else {
      ns = [];
    }
    return ns;
  }

  reload() async {
    setState(() {
      isLoading = true;
    });
    loadNotifications().then((value) {
      setState(() {
        notifications = value;
        isLoading = false;
      });
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(SitLocalizations().exitMessage());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: LoadingOverlay(
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 0.sp),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/backgroundw.png'))),
                child: body(context)),
            isLoading: isLoading,
            color: color_blue_weak,
            opacity: 0,
            progressIndicator: CircularProgressIndicator()),
        onWillPop: onWillPop,
      ),
    );
  }

  Widget body(context) {
    var unread = 0;
    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i]['read']) unread++;
    }
    var total = notifications.length;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
          height: 80.sp,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                SitLocalizations.of(context).notifications(),
                style: TextStyle(color: color_main, fontSize: 36.sp),
              ),
              Row(children: <Widget>[
                button(context, SitLocalizations.of(context).refresh(),
                    color_white, color_green, 140.sp, 24.sp, reload),
                button(
                    context,
                    SitLocalizations.of(context).readAll(),
                    color_white,
                    unread == 0 ? color_gray : color_blue,
                    160.sp,
                    24.sp,
                    unread == 0 ? () {} : readAll),
                button(
                    context,
                    SitLocalizations.of(context).clearAll(),
                    color_white,
                    total == 0 ? color_gray : color_red_weak,
                    160.sp,
                    24.sp,
                    total == 0 ? () {} : clearAll),
              ])
            ],
          ),
        ),
        Expanded(
          child: notificationsList(context),
        )
      ],
    );
    // Container(child: Text(SitLocalizations.of(context).notifications(),style: titleStyle,),margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16.sp),),
  }

  Widget button(context, title, colorText, colorBack, width, fontSize, onTap) {
    return InkWell(
        splashColor: color_blue,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.sp),
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.sp)),
              color: colorBack),
          width: width,
          child: Text(
            title,
            style: TextStyle(color: colorText, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ));
  }

  readAll() async {
    var result = await post('notifications/readall', {}, context);
    if (result['success']) {
      setState(() {
        for (var i = 0; i < notifications.length; i++) {
          notifications[i]['read'] = true;
        }
      });
    }
  }

  clearAll() async {
    var result = await delete('notifications', context);
    if (result['success']) {
      setState(() {
        notifications.clear();
      });
    }
  }

  Widget notificationsList(context) {
    return notifications.length != 0
        ? ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(notifications[index]['_id']),
                child: row(index),
                onDismissed: (direction) {
                  removeOne(index);
                },
              );
            },
          )
        : Center(
            child: Text(
            SitLocalizations.of(context).noNotificationsRecent(),
            style: TextStyle(fontSize: 40.sp, color: color_gray),
          ));
  }

  List<Widget> getRows() {
    List<Widget> rows = [];
    for (var i = 0; i < notifications.length; i++) {
      rows.add(row(i));
    }
    return rows;
  }

  Widget buttonArea() {
    return Container(
      child: sendButton(context, SitLocalizations.of(context).retur(),
          color_white, color_blue, 280.sp, 32.sp, onReturn),
    );
  }

  Widget row(index) {
    var item = notifications[index];
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: color_blue_weak_half_trans,
          onTap: () {
            makeAsRead(index);
          },
          child: Container(
              height: 160.sp,
              // margin: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 24.sp),
              padding: EdgeInsets.only(
                  top: 12.sp, bottom: 12.sp, right: 24.sp, left: 24.sp),
              decoration: BoxDecoration(
                // color: item['read'] ? Colors.transparent : color_white,
                border:
                    //Border(bottom: BorderSide(color: color_gray, width: 1.sp)),
                    Border.all(color: color_gray, width: 1.sp),
                // borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 3.sp,
                //       offset: Offset(0.sp, 3.sp),
                //       color: color_gray,
                //       spreadRadius: 0.sp)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                    item['user']['img_url'] == ''
                        ? CircleAvatar(
                            radius: 54.sp,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                          )
                        : CircleAvatar(
                            radius: 54.sp,
                            backgroundImage: AdvancedNetworkImage(
                                item['user']['img_url'],
                                fallbackAssetImage:
                                    'assets/images/person.png')),
                    Container(
                      margin: EdgeInsets.only(left: 48.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: color_green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['body'],
                            style:
                                TextStyle(color: color_main, fontSize: 24.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: <Widget>[
                              getNotificationIcon(item['type']),
                              Text(
                                item['type'] == 6
                                    ? item['other']
                                    : notificationType(context, item['type']),
                                // item['user']['full_name'],
                                style: TextStyle(
                                    color: color_gray, fontSize: 30.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ])),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          item['read']
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 0.sp, horizontal: 12.sp),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.sp, horizontal: 12.sp),
                                  child: Text(
                                    SitLocalizations.of(context).unread(),
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: color_white,
                                        fontSize: 24.sp),
                                  ),
                                  decoration: BoxDecoration(
                                      color: color_blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.sp))),
                                ),
                          GestureDetector(
                              onTap: () {
                                removeOne(index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.sp, horizontal: 4.sp),
                                child: Icon(
                                  Icons.close,
                                  color: color_white,
                                  size: 30.sp,
                                ),
                                decoration: BoxDecoration(
                                    color: color_red_weak,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(28.sp))),
                              )),
                        ],
                      ),
                      Container(
                        // padding:
                        // EdgeInsets.symmetric(vertical: 4.sp, horizontal: 12.sp),
                        child: Text(
                          getTimeShortName(item['created']),
                          style: TextStyle(color: color_gray, fontSize: 24.sp),
                        ),
                        decoration: BoxDecoration(
                            // color: color_gray,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.sp))),
                      ),
                      // Container(
                      //     height: 54.sp,
                      //     child: sendButton(
                      //         context,
                      //         SitLocalizations.of(context).remove(),
                      //         color_white,
                      //         color_red_weak,
                      //         120.sp,
                      //         28.sp,
                      //         () {}))
                    ],
                  )
                ],
              )),
        ));
  }

  void removeOne(index) async {
    var id = notifications[index]['_id'];
    var result = await delete('notifications/$id', context);
    if (result['success']) {
      setState(() {
        notifications.removeAt(index);
      });
    }
  }

  void makeAsRead(index) async {
    if (!notifications[index]['read']) {
      var result = await post('notifications/makeread',
          {'id': notifications[index]['_id']}, context);
      if (!result['success']) return;
      setState(() {
        notifications[index]['read'] = true;
      });
    }
  }

  void onRemove(index) async {}
  void onReturn() {}
  void onDetail() async {
    Navigator.of(context).pop();
  }

  getTimeFromDate(String date) {
    final dateTime = DateTime.parse(date);
    DateFormat format = DateFormat('HH:mm');
    final localtime = dateTime.toLocal();
    return format.format(localtime);
  }

  getTimeShortName(String time) {
    final dateTime = DateTime.parse(time);
    var localTime = dateTime.toLocal();
    DateFormat format = DateFormat('YYYY-MM-DD HH:mm');
    var now = DateTime.now();
    var diff = now.difference(localTime);
    var diffMinute = diff.inMinutes;
    var diffHour = diff.inHours;
    var diffDay = diff.inDays;
    if (diffMinute < 1) {
      return 'Just now';
    } else if (diffMinute == 1) {
      return '1 minute ago';
    } else if (diffMinute < 60) {
      return '$diffMinute minutes ago';
    } else if (diffMinute == 60) {
      return '1 hour ago';
    } else if (diffHour < 24) {
      return '$diffHour hours ago';
    } else if (diffHour < 48) {
      return 'yesterday';
    } else if (diffDay < 7) {
      return '$diffDay days ago';
    } else {
      return format.format(localTime);
    }
  }

  Widget getNotificationIcon(index) {
    var iconData;
    var size;
    switch (index) {
      case 0:
        iconData = EieoIcons.transport;
        size = 28.sp;
        break;
      case 1:
        iconData = EieoIcons.parcel;
        size = 32.sp;
        break;
      case 2:
        iconData = EieoIcons.food;
        size = 30.sp;
        break;
      case 3:
        iconData = Icons.pets;
        size = 30.sp;
        break;
      case 4:
        iconData = EieoIcons.health;
        size = 24.sp;
        break;
      case 5:
        iconData = Icons.message;
        size = 30.sp;
        break;
      case 6:
        iconData = Icons.people;
        size = 32.sp;
        break;
      case 7:
        iconData = EieoIcons.service;
        size = 28.sp;
        break;
      case 8:
        iconData = Icons.event;
        size = 32.sp;
        break;
      default:
        iconData = null;
        size = 24.sp;
    }
    return new Padding(
        padding: EdgeInsets.only(right: 8.sp),
        child: Icon(
          iconData,
          size: size,
          color: color_gray,
        ));
  }
}
