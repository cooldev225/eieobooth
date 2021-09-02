import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/lang.dart';

class CustomAlert extends StatefulWidget {
  final data;
  @override
  _CustomAlertState createState() => _CustomAlertState(data: data);
  CustomAlert({@required this.data});
}

class _CustomAlertState extends State<CustomAlert>
    with SingleTickerProviderStateMixin {
  dynamic data;

  var status;
  var action;
  var inviteData;
  _CustomAlertState({@required this.data});
  @override
  void initState() {
    super.initState();
    status = NORMAL;
    action = EXTEND;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        color: color_white);
    var titleStyle = TextStyle(color: color_main, fontSize: 36.sp);
    return WillPopScope(
        child: Stack(
          children: <Widget>[
            Container(
                height: 320.sp,
                width: 720.sp,
                decoration: decoration,
                padding: EdgeInsets.only(
                    top: 40.sp, bottom: 32.sp, left: 12.sp, right: 12.sp),
                child: status == PROCESSING
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Container(
                              child: Text(
                                status == NORMAL
                                    ? SitLocalizations.of(context)
                                        .visitTimeExpired()
                                    : status == PENDING
                                        ? action == NOTIFY
                                            ? userNotifyMsg(context, 8,
                                                data['invitor']['full_name'])
                                            : SitLocalizations.of(context)
                                                .confirmExtendVisit()
                                        : status == SUCCESS
                                            ? SitLocalizations.of(context)
                                                .succeded()
                                            : status == FAILURE
                                                ? SitLocalizations.of(context)
                                                    .failed()
                                                : '',
                                style: titleStyle,
                                textAlign: TextAlign.center,
                              ),
                              // margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                            ),
                            buttonArea()
                          ])),
            Positioned(
              top: 8.sp,
              right: 8.sp,
              child: GestureDetector(
                  onTap: onReturn,
                  child: Container(
                    padding: EdgeInsets.all(6.sp),
                    child: Icon(
                      Icons.close,
                      color: color_white,
                      size: 36.sp,
                    ),
                    decoration: BoxDecoration(
                        color: color_gray,
                        borderRadius: BorderRadius.all(Radius.circular(32.sp))),
                  )),
            )
          ],
        ),
        onWillPop: () async {
          return false;
        });
  }

  Widget buttonArea() {
    return Container(
        padding: EdgeInsets.only(top: 16.sp),
        child: (status == SUCCESS || status == FAILURE)
            ? sendButton(context, SitLocalizations.of(context).retur(),
                color_white, color_blue, 240.sp, 32.sp, onReturn)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  sendButton(
                      context,
                      status == PENDING
                          ? SitLocalizations.of(context).yes()
                          : SitLocalizations.of(context).extendVisit(),
                      status == PENDING ? color_white : color_gray,
                      status == PENDING ? color_blue : color_white,
                      240.sp,
                      32.sp,
                      onExtend),
                  sendButton(
                      context,
                      status == PENDING
                          ? SitLocalizations.of(context).no()
                          : SitLocalizations.of(context).notifyResident(),
                      color_white,
                      status == PENDING ? color_red_weak : color_blue,
                      240.sp,
                      32.sp,
                      onNotify),
                ],
              ));
  }

  onReturn() async {
    Navigator.of(context).pop({
      'success': status == SUCCESS ? true : false,
      'type': action,
      'result': inviteData
    });
    // return false;
  }

  notify() async {
    await Future.delayed(Duration(milliseconds: 500));
    var result = await post(
        'resident/notify',
        {
          'message':
              data['visitor']['id']['full_name'] + ' exceeded visit time.',
          'type': '8',
          'resident_id': data['invitor']['_id'],
          'visitor': data['visitor'],
          'img': data['visitor']['id']['img_url'],
          'is_img': false,
          'is_event': false,
          'is_service': false,
          'is_favorite': false
        },
        context);
    status = FAILURE;
    if (result['success']) {
      status = SUCCESS;
    }
    setState(() {});
    // Navigator.of(context).pop({'success': result['success'], 'type': 'notify'});
  }

  extend() async {
    await Future.delayed(Duration(milliseconds: 500));
    var result =
        await post('visit/extend', {'invite_id': data['invite']}, context);
    status = FAILURE;
    if (result['success']) {
      status = SUCCESS;
      inviteData = result['result'];
    }
    setState(() {});
    // Navigator.of(context).pop({'success': result['success'], 'type': 'extend'});
  }

  void onNotify() async {
    if (status == NORMAL) {
      setState(() {
        action = NOTIFY;
        status = PENDING;
      });
      return;
    } else if (status == PENDING) {
      setState(() {
        status = NORMAL;
      });
      return;
    }
  }

  void onExtend() async {
    if (status == NORMAL) {
      setState(() {
        action = EXTEND;
        status = PENDING;
      });
      return;
    } else if (status == PENDING) {
      setState(() {
        status = PROCESSING;
      });
      if (action == EXTEND) {
        await extend();
      } else if (action == NOTIFY) {
        await notify();
      }
    }
  }
}
