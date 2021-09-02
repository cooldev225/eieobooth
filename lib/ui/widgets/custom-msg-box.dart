import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/constants.dart';

class CustomMsgBox extends StatefulWidget {
  final data;
  final success;
  final failure;
  var initialState;
  set stateSet(state) {
    initialState = state;
  }

  var setState;
  @override
  _CustomMsgBox createState() => _CustomMsgBox();
  CustomMsgBox(
      {@required this.data,
      @required this.success,
      @required this.failure,
      @required this.initialState});
}

class _CustomMsgBox extends State<CustomMsgBox>
    with SingleTickerProviderStateMixin {
  var state;
  _CustomMsgBox();
  @override
  void initState() {
    super.initState();
    widget.setState = setModalState;
    state = widget.initialState;
  }

  setModalState(state) {
    setState(() {
      this.state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        color: color_white);
    var titleStyle =
        TextStyle(color: color_main, fontSize: 32.sp, height: 3.sp);
    return WillPopScope(
      child: Container(
          height: 280.sp,
          width: 640.sp,
          decoration: decoration,
          padding: EdgeInsets.symmetric(vertical: 24.sp, horizontal: 24.sp),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Text(
                    state == NORMAL
                        ? widget.data
                        : state == SUCCESS
                            ? widget.success
                            : state == FAILURE
                                ? widget.failure
                                : SitLocalizations.of(context)
                                    .sendingNotification(),
                    textAlign: TextAlign.center,
                    style: titleStyle,
                  ),
                  // margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                ),
                buttonArea()
              ])),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget buttonArea() {
    return Container(
        padding: EdgeInsets.only(top: 16.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: state == NORMAL
              ? <Widget>[
                  sendButton(context, SitLocalizations.of(context).yes(),
                      color_white, color_blue, 200.sp, 32.sp, onYes),
                  sendButton(context, SitLocalizations.of(context).no(),
                      color_white, color_red_weak, 200.sp, 32.sp, onNo),
                ]
              : state == SUCCESS || state == FAILURE
                  ? [
                      sendButton(context, SitLocalizations.of(context).retur(),
                          color_white, color_blue, 200.sp, 32.sp, onReturn)
                    ]
                  : [CircularProgressIndicator()],
        ));
  }

  void onYes() async {
    Navigator.of(context).pop(true);
  }

  void onNo() async {
    Navigator.of(context).pop(false);
  }

  void onReturn() async {
    Navigator.of(context).pop();
  }
}
