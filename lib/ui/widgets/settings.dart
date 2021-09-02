import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/appbar.dart';
import 'package:easyguard/ui/widgets/back-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  int dropdownValue = 0;
  _SettingsState();
  var localeLoaded = false;
  String locale = 'en';
  @override
  void initState() {
    super.initState();
    loadLocale();
  }

  loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    locale = prefs.getString('languageCode');
    if (locale == null) {
      dropdownValue = 0;
      locale = 'en';
      setState(() {});
      return;
    }
    setState(() {
      dropdownValue = locale == 'en' ? 0 : 1;
    });
  }

  changeLanguage(value) async {
    setState(() {
      dropdownValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: null,
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/backgroundw.png'))),
          child: Column(
            children: <Widget>[clipShape(context, false), settingForm()],
          )),
    ));
  }

  Widget settingForm() {
    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          backButton(context),
          Container(
              padding: EdgeInsets.only(left: 120.w, top: 200.h),
              child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(bottom: 48.sp),
                    alignment: Alignment.centerLeft,
                    child: Text(SitLocalizations.of(context).language(),
                        style: TextStyle(color: color_main, fontSize: 36.sp))),
                Row(children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 36.sp),
                      child: Image.asset(
                        dropdownValue == 0
                            ? 'icons/flags/png/us.png'
                            : 'icons/flags/png/mx.png',
                        package: 'country_icons',
                        width: 84.sp,
                      )),
                  DropdownButton(
                      itemHeight: 200.sp,
                      value: dropdownValue,
                      iconSize: 64.sp,
                      style: TextStyle(fontSize: 54.sp, color: color_green),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: color_green,
                      ),
                      underline: Container(
                        height: 2.sp,
                        color: color_main,
                      ),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                          changeLanguage(value);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                            value: 0,
                            child: Container(
                                margin: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text('English (USA)'))),
                        DropdownMenuItem(
                            value: 1,
                            child: Container(
                                margin: EdgeInsets.only(top: 8, bottom: 8),
                                child: Text('Español (MEX)')))
                      ])
                ]),
                Container(
                    margin: EdgeInsets.only(top: 54.sp),
                    alignment: Alignment.centerLeft,
                    child: (Row(children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 36.sp),
                          child: (Image.asset(
                            'assets/images/logout.png',
                            width: 72.sp,
                          ))),
                      GestureDetector(
                          onTap: logout,
                          behavior: HitTestBehavior.translucent,
                          child: Text(SitLocalizations.of(context).logout(),
                              style: TextStyle(
                                  color: color_green, fontSize: 54.sp)))
                    ])))
              ])),
          Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: dropdownValue != (locale == 'en' ? 0 : 1)
                      ? Container(
                          height: 80.sp,
                          child: RaisedButton(
                              color: color_blue,
                              onPressed: saveChange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              textColor: Colors.white,
                              child: Text(
                                  SitLocalizations.of(context).saveChange(),
                                  style: TextStyle(fontSize: 48.sp))),
                          margin: EdgeInsets.only(bottom: 80.sp),
                        )
                      : Container()))
        ]));
  }

  saveChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', dropdownValue == 0 ? 'en' : 'es');
    Phoenix.rebirth(context);
  }

  logout() async {
    var result = await showDialog(
        barrierDismissible: false,
        context: context,
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.sp)),
          child: CustomMsgBox(
              data: SitLocalizations.of(context).wantLogout(),
              success: '',
              failure: '',
              initialState: NORMAL),
        ));
    if (result) {
      var result = await post('logout', {}, context);
      if (result['success']) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('token', '');
        Phoenix.rebirth(context);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(LOGIN, (Route<dynamic> route) => false);
      }
    } else {}
  }
}
