import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:easyguard/ui/widgets/username.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:easyguard/http.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:easyguard/ui/widgets/custom-notify-modal.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/ui/widgets/back-button.dart';

class SendMessage extends StatefulWidget {
  final resident;
  SendMessage({@required this.resident});
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  var _resident;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    this._resident = widget.resident;
  }

  load() async {
    _resident = widget.resident;
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                user(context, _resident['user_id']['full_name'],
                    _resident['house_id']),
                messageArea(context)
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: color_blue_weak_half_trans,
            ));
          }
        });
  }

  Widget messageArea(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
      children: <Widget>[
        message(context),
        sendButton(context, SitLocalizations.of(context).send(), color_white,
            color_blue, 360.sp, 32.sp, onTapButton)
      ],
    ))));
  }

  Widget message(BuildContext context) {
    return Container(
      height: 800.h,
      decoration: BoxDecoration(
        color: color_white,
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        boxShadow: [
          BoxShadow(
              blurRadius: 6.sp, color: color_gray, offset: Offset(0, 4.sp))
        ],
      ),
      padding: EdgeInsets.all(16.sp),
      margin:
          EdgeInsets.only(top: 36.sp, left: 36.sp, right: 36.sp, bottom: 24.sp),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
            borderRadius: BorderRadius.circular(24.sp),
          ),
          contentPadding:
              new EdgeInsets.symmetric(vertical: 0, horizontal: 16.sp),
          hintText: SitLocalizations.of(context).typeMessageHere(),
          // border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(12.0),
          //     borderSide: BorderSide(width: 0, color: color_white)),
        ),
      ),
    );
  }

  void onTapButton() async {
    var message = controller.text;
    if (message.length == 0) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
              child: CustomNotify(
                  message: SitLocalizations.of(context).messageEmpty()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.sp))));
      return;
    }
    if (message.length > 200) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
              child: CustomNotify(
                  message: SitLocalizations.of(context).messageLengthExceed()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.sp))));
      return;
    }
    var msgBox;
    var dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: msgBox = CustomMsgBox(
          data: userNotifyMsg(context, 5, _resident['user_id']['full_name']),
          success: SitLocalizations.of(context).notificationSentSuccessful(),
          failure: SitLocalizations.of(context).notificationSentFailure(),
          initialState: NORMAL),
    );
    var returned = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );
    if (!returned) return;
    msgBox.initialState = PENDING;
    dialog = Dialog(
      child: msgBox,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog);
    var result = await post(
        'resident/notify',
        {
          'booth': '',
          'message': preDefinedMessages(5),
          'resident_id': _resident['user_id']['_id'],
          'type': 5,
          'other': message,
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
    Navigator.of(context).pop();
  }
}
