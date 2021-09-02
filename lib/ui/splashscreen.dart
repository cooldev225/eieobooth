import 'dart:async';
import 'package:easyguard/http.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/home.dart';
import 'package:easyguard/ui/loginscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/public/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    return new Timer(Duration(seconds: 2), toNextPage);
  }

  toNextPage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token');
    if (token != '' && token != null) {
      var result = await post('loginjwt', {'user': {}}, context);
      if (result['success']) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('token', result['result']['token']);
        sp.setDouble('latitude', result['result']['latitude']);
        sp.setDouble('longitude', result['result']['longitude']);
        WidgetsFlutterBinding.ensureInitialized();
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        WidgetsFlutterBinding.ensureInitialized();
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: body(context)));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget body(context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset('assets/images/logo.png',
                width: 250, height: 250, fit: BoxFit.fitWidth)
          ])
    ]);
  }
}
