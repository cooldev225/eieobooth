import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-modal-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/ui/widgets/toast.dart';
import 'package:easyguard/ui/widgets/schedule-screen.dart';

import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/ui/widgets/custom-alert.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool localeLoaded = false;
  Locale locale;
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
      return CupertinoApp(
          debugShowCheckedModeBanner: false,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (this.locale == null) {
              this.locale = deviceLocale;
            }
            return this.locale;
          },
          localizationsDelegates: [
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
          home: ScheduleScreen(),
          routes: <String, WidgetBuilder>{
            SCHEDULE_HOME: (BuildContext context) => new ScheduleScreen()
          });
    }
  }
}
