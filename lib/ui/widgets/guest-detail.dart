import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/eieoIcons.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-alert.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/http.dart';
import 'package:intl/intl.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestDetail extends StatefulWidget {
  final guest;
  final status;
  @override
  _GuestDetail createState() => _GuestDetail();
  GuestDetail({@required this.guest, @required this.status});
}

class _GuestDetail extends State<GuestDetail>
    with SingleTickerProviderStateMixin {
  var invitations = [];
  dynamic guest;
  var firstLoad = true;
  var status;
  var colors = [
    color_main,
    color_blue,
    color_green,
    color_red_weak,
    color_blue_weak,
  ];
  PageController tabController = PageController(initialPage: 0);
  _GuestDetail();
  @override
  void initState() {
    super.initState();
    guest = widget.guest;
    status = widget.status;
  }

  reload() {
    firstLoad = true;
    setState(() {});
  }

  loadInvitations() async {
    var result = await post('guest/invitations',
        {'guest': guest['_id'], 'status': status}, context);
    if (result['success']) {
      invitations = result['result']['invitations'];
      guest = result['result']['guest'];
    } else {
      invitations = [];
      guest = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: body(),
      floatingActionButton: SizedBox(
          width: 80.sp,
          child: FloatingActionButton(
            backgroundColor: color_red_weak,
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  Widget body() {
    return Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.sp))),
        child: Column(
          children: <Widget>[
            title(),
            tabBar(),
            Expanded(child: invitationsMain())
          ],
        ));
  }

  Widget invitationsMain() {
    return FutureBuilder(
        future: loadInvitations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return invitationList();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget title() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 32.sp),
      // height: 80.sp,
      // width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Image(
                  image: AssetImage('assets/images/easylogo.png'),
                  width: 40.sp,
                  fit: BoxFit.fitWidth,
                )),
            Text(
              SitLocalizations.of(context).invitations(),
              style: TextStyle(color: color_main, fontSize: 40.sp),
            )
          ]),
          Text(
            guest['full_name'],
            style: TextStyle(color: color_blue, fontSize: 36.sp),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          tab(visitus(context, 4), () {
            onTapBar(4);
          }, status == 4),
          tab(visitus(context, 0), () {
            onTapBar(0);
          }, status == 0),
          tab(visitus(context, 1), () {
            onTapBar(1);
          }, status == 1),
          tab(visitus(context, 2), () {
            onTapBar(2);
          }, status == 2),
          tab(visitus(context, 3), () {
            onTapBar(3);
          }, status == 3),
        ]));
  }

  Widget tab(title, onTap, selected) {
    var color = selected ? colors[status] : color_gray;
    return Expanded(
      flex: 1,
      child: InkWell(
        child: Container(
            padding: EdgeInsets.only(bottom: 18.sp),
            alignment: Alignment.bottomCenter,
            height: 80.sp,
            decoration: BoxDecoration(
                border: selected
                    ? Border(
                        top: BorderSide(color: color, width: 8.sp),
                        // left: BorderSide(color: color, width: 2.sp),
                        // right: BorderSide(color: color, width: 2.sp),
                      )
                    : Border(
                        // top: BorderSide(color: color_red_weak, width: 8.sp),
                        // left: BorderSide(color: color_red_weak, width: 2.sp),
                        // bottom:BorderSide(color: colors[status], width: 2.sp)
                        )),
            child: Text(
              title,
              style: TextStyle(color: color, fontSize: 30.sp),
              textAlign: TextAlign.center,
            )),
        onTap: onTap,
      ),
    );
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

  onTapBar(index) {
    setState(() {
      status = index;
    });
  }

  refresh() async {
    setState(() {
      firstLoad = true;
    });
  }

  readAll() async {
    // var result = await post('notifications/readall', token, {});
    // if (result['success']) {
    //   setState(() {
    //     for (var i = 0; i < notifications.length; i++) {
    //       notifications[i]['read'] = true;
    //     }
    //   });
    // }
  }

  clearAll() async {
    // var result = await delete('notifications', token);
    // if (result['success']) {
    //   setState(() {
    //     notifications.clear();
    //   });
    // }
  }

  Widget invitationList() {
    return invitations.length != 0
        ? ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: invitations.length,
            itemBuilder: (context, index) {
              return row(index);
            },
          )
        : Center(
            child: Text(
            SitLocalizations.of(context).noInvitations(),
            style: TextStyle(fontSize: 40.sp, color: color_gray),
          ));
  }

  List<Widget> getRows() {
    List<Widget> rows = [];
    for (var i = 0; i < invitations.length; i++) {
      rows.add(row(i));
    }
    return rows;
  }

  Widget row(index) {
    var item = invitations[index];
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: color_blue_weak_half_trans,
          onTap: () {
            onRowTap(item['_id'], item['status'], item['invitor_id']['_id']);
          },
          child: Container(
              height: 160.sp,
              padding: EdgeInsets.only(
                  top: 12.sp, bottom: 12.sp, right: 24.sp, left: 24.sp),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: color_gray, width: 1.sp)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                    item['invitor_id']['img_url'] == ''
                        ? CircleAvatar(
                            radius: 54.sp,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                          )
                        : CircleAvatar(
                            radius: 54.sp,
                            backgroundImage: AdvancedNetworkImage(
                                item['invitor_id']['img_url'],
                                fallbackAssetImage:
                                    'assets/images/person.png')),
                    Container(
                      margin: EdgeInsets.only(left: 48.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item['invitor_id']['full_name'],
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: color_green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            getTimePeriod(item['startTime'], item['endTime']),
                            style:
                                TextStyle(color: color_main, fontSize: 24.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: <Widget>[
                              getNotificationIcon(
                                  item['event'] ? 0 : item['service'] ? 2 : 1),
                              Text(
                                item['event']
                                    ? SitLocalizations.of(context).event()
                                    : item['service']
                                        ? SitLocalizations.of(context).service()
                                        : SitLocalizations.of(context).visit(),
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
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.sp, horizontal: 12.sp),
                    child: Text(
                      visitus(context, item['status']),
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: color_white,
                          fontSize: 20.sp),
                    ),
                    decoration: BoxDecoration(
                        color: colors[item['status']],
                        borderRadius: BorderRadius.all(Radius.circular(6.sp))),
                  )
                ],
              )),
        ));
  }

  void onRowTap(invite, status, invitorId) async {
    if (status == 0) {
      var dialog = Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.sp)),
          child: CustomMsgBox(
            data: SitLocalizations.of(context).passMsg(),
            success: SitLocalizations.of(context).succeded(),
            failure: SitLocalizations.of(context).failed(),
            initialState: NORMAL,
          ));
      var result = await showDialog(context: context, child: dialog);
      if (result) {
        var res = await post(
            'guest/setstate',
            {'invite_id': invite, 'visitor_id': guest['_id'], 'status': 1},
            context);
        setState(() {});
        if (res['success'] && res['result']['notify']) {
          await post(
              'resident/notify',
              {
                'booth': '',
                'message': preDefinedMessages(10),
                'resident_id': res['result']['resident_id'],
                'type': 10,
                'img': guest['img_url'],
                'is_img': false,
                'other': guest['full_name'],
                'is_service': false,
                'is_event': res['is_event'],
                'is_favorite': false
              },
              context);
        }
      }
      return;
    }

    if (status == 1) {
      var dialog = Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.sp)),
          child: CustomMsgBox(
            data: SitLocalizations.of(context).end(),
            success: SitLocalizations.of(context).succeded(),
            failure: SitLocalizations.of(context).failed(),
            initialState: NORMAL,
          ));
      var result = await showDialog(context: context, child: dialog);
      if (result) {
        var res = await post(
            'guest/setstate',
            {'invite_id': invite, 'visitor_id': guest['_id'], 'status': 2},
            context);
        if (res['success']) {
          setState(() {});
        }
      }
      return;
    }

    if (status == 3) {
      var dialog = Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.sp)),
          child: CustomMsgBox(
            data: SitLocalizations.of(context).end(),
            success: SitLocalizations.of(context).succeded(),
            failure: SitLocalizations.of(context).failed(),
            initialState: NORMAL,
          ));
      var result = await showDialog(context: context, child: dialog);
      if (result) {
        var res = await post(
            'guest/setstate',
            {'invite_id': invite, 'visitor_id': guest['_id'], 'status': 2},
            context);
        if (res['success']) {
          setState(() {});
        }
      } else {
        var alert = Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: CustomAlert(data: {
              'invite': invite,
              'invitor': invitorId,
              'visitor': guest
            }));
        var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => alert,
        );
        if (result['success']) {
          if (result['type'] == EXTEND) {
            setState(() {});
          }
        }
      }
      return;
    }
  }

  getTimeFromDate(String date) {
    final dateTime = DateTime.parse(date);
    DateFormat format = DateFormat('HH:mm');
    final localtime = dateTime.toLocal();
    return format.format(localtime);
  }

  getTimePeriod(String from, String to) {
    return getDateTimeShortName(from) + ' - ' + getDateTimeShortName(to);
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

  getDateTimeShortName(String time) {
    final utc = DateTime.parse(time);
    final local = utc.toLocal();
    final now = DateTime.now();
    final today = new DateTime(now.year, now.month, now.day);
    final tomorrow = new DateTime(now.year, now.month, now.day + 1);
    String res;
    DateFormat format = DateFormat('HH:mm');
    res = format.format(local);
    if (!(local.isAfter(today) && local.isBefore(tomorrow))) {
      res = local.day.toString() +
          ' ' +
          monthAbbr(context, local.month) +
          ' ' +
          res;
    }
    return res;
  }

  Widget getNotificationIcon(index) {
    var iconData;
    var size;
    switch (index) {
      case 0:
        iconData = Icons.event_note;
        size = 28.sp;
        break;
      case 1:
        iconData = Icons.people;
        size = 32.sp;
        break;
      case 2:
        iconData = EieoIcons.service;
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
