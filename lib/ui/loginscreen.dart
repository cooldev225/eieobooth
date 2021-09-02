import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/home.dart';
import 'package:easyguard/ui/widgets/textformfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/ui/widgets/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  bool isLoading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseMessaging fcm = FirebaseMessaging();
  GlobalKey<FormState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/background.png"))),
            padding: EdgeInsets.only(bottom: 8),
            child: SafeArea(
                child: Container(
                    child: Column(children: <Widget>[
              clipShape(),
              form(),
              SizedBox(height: 100.sp),
              !isLoading ? button() : Center(child: CircularProgressIndicator())
            ])))));
  }

  Widget clipShape() {
    ScreenUtil.init(context);
    return Stack(children: <Widget>[
      Container(
          height: 240.h,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/header1.png")),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                margin: EdgeInsets.only(right: 16),
                height: 200.h,
                width: 80.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/images/easylogo.png")))),
            Text('EASY IN EASY OUT',
                style: TextStyle(fontSize: 80.sp, color: color_main),
                textAlign: TextAlign.right)
          ]))
    ]);
  }

  Widget form() {
    return Container(
        margin: EdgeInsets.only(left: 240.w, right: 240.w, top: 200.h),
        child: Form(
            key: _key,
            child: Column(children: <Widget>[
              usernameTextFormField(),
              SizedBox(height: 30.sp),
              passwordTextFormField()
            ])));
  }

  Widget usernameTextFormField() {
    return CustomTextField(
        icon: Icons.person,
        hint: SitLocalizations.of(context).hintUsername(),
        textEditingController: usernameController,
        textStyle: TextStyle(fontSize: 28.sp));
  }

  Widget passwordTextFormField() {
    return CustomTextField(
        textEditingController: passwordController,
        icon: Icons.lock,
        obscureText: true,
        hint: SitLocalizations.of(context).hintPassword(),
        textStyle: TextStyle(fontSize: 28.sp));
  }

  Widget button() {
    return RaisedButton(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.sp)),
        onPressed: loginPressed,
        textColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        child: Container(
            alignment: Alignment.center,
            width: 300.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: color_blue),
            padding: const EdgeInsets.all(12.0),
            child: Text(SitLocalizations.of(context).login(),
                style: TextStyle(fontSize: 32.sp))));
  }

  loginPressed() async {
    setState(() {
      isLoading = true;
    });
    var deviceId = await fcm.getToken();
    var body = {
      'username': usernameController.text.trim().replaceAll('0', ''),
      'password': passwordController.text.trim().replaceAll('0', ''),
      'deviceId': deviceId
    };
    var result = await post('login', body, context);
    if (result['success']) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('token', result['result']['token']);
      sp.setDouble('latitude', result['result']['latitude']);
      sp.setDouble('longitude', result['result']['longitude']);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      showToast(SitLocalizations.of(context).invalidLogin());
    }
    setState(() {
      isLoading = false;
    });
  }
}
