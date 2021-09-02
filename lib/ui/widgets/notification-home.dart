import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:easyguard/ui/widgets/notification-screen.dart';
import 'package:easyguard/ui/widgets/schedule-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationsHome extends StatefulWidget {
  var reload;

  @override
  _NotificationsHome createState() => _NotificationsHome();
  NotificationsHome();
}

class _NotificationsHome extends State<NotificationsHome> {
  _NotificationsHome();

  var localeLoaded = false;

  Locale locale;
  @override
  void initState() {
    super.initState();

    this.fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
        this.localeLoaded = true;
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
        home: NotificationsScreen(widget.reload),
        routes: <String, WidgetBuilder>{
          NOTIFICATION_HOME: (BuildContext context) =>
              new NotificationsScreen(widget.reload)
        },
      );
    }
  }
}
