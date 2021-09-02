import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:easyguard/ui/home.dart';
import 'package:easyguard/ui/loginscreen.dart';
import 'package:easyguard/ui/splashscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';

void main() => runApp(Phoenix(child: Easyguard()));

class Easyguard extends StatefulWidget {
  Easyguard({Key key}) : super(key: key);
  @override
  _Easyguard createState() => _Easyguard();
}

class _Easyguard extends State<Easyguard> {
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
      return Locale('en');
    }
    return Locale(prefs.getString('languageCode'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else {
      return new MaterialApp(
        title: 'Easyguard',
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          if (this.locale == null) {
            this.locale = deviceLocale;
          }
          return this.locale;
        },
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          const SitLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('es'),
          const Locale('it'),
          const Locale('mx'),
          const Locale('de'),
          const Locale('cn'),
        ],
        routes: <String, WidgetBuilder>{
          SPLASH: (BuildContext context) => new SplashScreen(),
          LOGIN: (BuildContext context) => new LoginScreen(),
          DASHBOARD: (BuildContext context) => new Dashboard(),
        },
        initialRoute: SPLASH,
      );
    }
  }
}
