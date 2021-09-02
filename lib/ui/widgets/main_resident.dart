import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/profile.dart';
import 'package:easyguard/ui/widgets/residents.dart';
import 'package:easyguard/ui/widgets/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easyguard/ui/widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainResident extends StatefulWidget {
  @override
  _MainResident createState() => _MainResident();
}

class _MainResident extends State<MainResident> {
  var localeLoaded = false;
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
      return Container(
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
            title: "Residents page",
            home: Residents(),
            routes: <String, WidgetBuilder>{
              RESIDENTS: (BuildContext context) => new Residents(),
              // PROFILE_PAGE: (BuildContext context) => new Profile(),
            },
          ));
    }
  }
}
