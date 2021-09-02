import 'package:easyguard/public/colors.dart';
import 'package:easyguard/ui/widgets/user-detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';

class UserMain extends StatefulWidget {
  final guest;
  final types;
  @override
  _UserMain createState() => _UserMain();
  UserMain({@required this.guest, @required this.types});
}

class _UserMain extends State<UserMain> with SingleTickerProviderStateMixin {
  var invitations = [];
  dynamic guest;
  dynamic types;
  var firstLoad = true;
  Locale locale;
  PageController tabController = PageController(initialPage: 0);
  _UserMain();

  var localeLoaded = false;
  @override
  void initState() {
    super.initState();
    this.fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('languageCode') == null) {
      return null;
    }
    return Locale(prefs.getString('languageCode'));
  }

  @override
  Widget build(BuildContext context) {
    if (this.localeLoaded == false) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 0.sp),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/backgroundw.png'))),
          child: CupertinoApp(
              debugShowCheckedModeBanner: false,
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                if (this.locale == null) {
                  this.locale = deviceLocale;
                }
                return this.locale;
              },
              localizationsDelegates: [
                // _localeOverrideDelegate,

                const SitLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                DefaultCupertinoLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en'),
                const Locale('es'),
              ],
              title: "user page",
              theme: CupertinoThemeData(primaryColor: color_red_weak),
              home: UserDetail(guest: widget.guest, types: widget.types),
              routes: <String, WidgetBuilder>{
                USER: (BuildContext context) =>
                    UserDetail(guest: guest, types: types)
              }));
    }
  }
}
