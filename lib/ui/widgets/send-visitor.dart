import 'dart:convert';
import 'dart:io';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/camera-form.dart';
import 'package:easyguard/ui/widgets/custom-notify-modal.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/ui/widgets/username.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/ui/widgets/back-button.dart';

class SendVisitor extends StatefulWidget {
  final resident;
  SendVisitor({@required this.resident});
  @override
  _SendVisitorState createState() => _SendVisitorState();
}

class _SendVisitorState extends State<SendVisitor> {
  var _resident;
  var controller = TextEditingController();
  String imageB64;
  var cameraForm;
  var cameras;
  @override
  void initState() {
    super.initState();
    imageB64 = '';
    loadCameras();
  }

  returned() {}

  loadCameras() async {
    cameras = await availableCameras();
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
                sendArea()
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

  Widget sendArea() {
    return Expanded(
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
      camera(),
      nameArea(),
      sendButton(context, SitLocalizations.of(context).send(), color_white,
          color_blue, 360.sp, 32.sp, onSendButton),
    ])));
  }

  Widget nameArea() {
    return Container(
      height: 72.sp,
      margin:
          EdgeInsets.only(left: 48.sp, right: 48.sp, bottom: 48.sp, top: 40.sp),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        cursorColor: color_gray,
        style: TextStyle(
          color: color_main,
        ),
        decoration: InputDecoration(
          contentPadding: new EdgeInsets.only(top: 0.sp, bottom: 40.sp),
          hintText: SitLocalizations.of(context).addGuestName(),
        ),
      ),
    );
  }

  Widget camera() {
    return Container(
        height: 1000.h,
        // decoration:
        //     BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12))),
        // margin: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 8),
        child: Stack(children: [
          Container(
            child: cameraForm = CameraForm(
              returned: returned,
              camera: cameras.first,
            ),
            margin: EdgeInsets.only(left: 48.sp, right: 48.sp, top: 36.sp),
          ),
          // Text("dfsef")
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  margin: EdgeInsets.only(right: 72.sp, bottom: 18.sp),
                  child: FloatingActionButton(
                    heroTag: "takePicture",
                    backgroundColor: color_red_weak,
                    child: Icon(
                      Icons.photo_camera,
                      color: color_white,
                      size: 54.sp,
                    ),
                    onPressed: onTakeButton,
                  )))
        ]));
  }

  void onTakeButton() async {
    try {
      String path = await cameraForm.takePicture();
      await cameraForm.pictureTaken();
      List<int> imageBytes = await File(path).readAsBytes();
      imageB64 = base64Encode(imageBytes);
    } catch (e) {
      imageB64 = '';
    }
  }

  void onSendButton() async {
    if (controller.text == '') {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
              child: CustomNotify(
                  message: SitLocalizations.of(context).guestNameEmpty()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.sp))));
      return;
    }
    if (imageB64 == '') {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
              child: CustomNotify(
                  message: SitLocalizations.of(context).guestImageEmpty()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.sp))));
      return;
    }
    var msgBox;
    var dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: msgBox = CustomMsgBox(
          data: userNotifyMsg(context, 6, _resident['user_id']['full_name']),
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
    await Future.delayed(Duration(seconds: 1));
    var result = await post(
        'resident/notify',
        {
          'booth': '',
          'message': preDefinedMessages(6),
          'resident_id': _resident['user_id']['_id'],
          'type': 6,
          'img': imageB64,
          'is_img': true,
          'other': controller.text,
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
