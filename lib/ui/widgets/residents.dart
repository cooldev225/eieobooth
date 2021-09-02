import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:easyguard/ui/widgets/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Residents extends StatefulWidget {
  Residents();
  @override
  _ResidentsState createState() => _ResidentsState();
}

class _ResidentsState extends State<Residents>
    with SingleTickerProviderStateMixin {
  var first = true;
  List<dynamic> residents = [];
  List<ImageProvider> avatars = [];
  List<int> shows = [];
  var searching = false;
  var loading = false;
  DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
  }

  Future<void> loadResidents() async {
    if (!first) return;
    var result = await post('residents', {}, context);
    if (result['success']) {
      residents = result['result'];
      shows = [];
      for (var i = 0; i < residents.length; i++) shows.add(i);
    } else {
      residents = [];
      shows = [];
    }
    await loadImages();
    first = false;
  }

  loadEmpty() async {
    searching = false;
  }

  Future<void> loadImages() async {
    for (var i = 0; i < (residents).length; i++) {
      String url = residents[i]['user_id']['img_url'];
      ImageProvider image;
      if (url != '') {
        try {
          image = AdvancedNetworkImage(
            url,
            fallbackAssetImage: "assets/images/person.png",
          );
        } catch (e) {
          image = AssetImage('assets/images/person.png');
        }
        avatars.add(image);
      } else {
        avatars.add(null);
      }
    }
  }

  void searchName(name) {
    searching = true;
    List<int> tmp = [];
    for (var i = 0; i < residents.length; i++) {
      if (residents[i]['user_id']['full_name']
              .toLowerCase()
              .indexOf(name.toLowerCase()) >
          -1) {
        tmp.add(i);
      }
    }
    setState(() {
      shows = tmp;
    });
  }

  void gotoProfile(index) async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                Profile(resident: residents[index]['user_id']['_id'])));
  }

  void gotoNotification(index) async {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Notifications(resident: residents[index])));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(SitLocalizations().exitMessage());
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Column(
        children: <Widget>[search(), residentsForm(context)],
      ),
      onWillPop: onWillPop,
    );
  }

  Widget residentsForm(BuildContext context) {
    return first
        ? FutureBuilder(
            future: searching ? loadEmpty() : loadResidents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (shows.length == 0) {
                  return Expanded(
                      child: Center(
                          child: Text(
                              SitLocalizations.of(context).noResidents(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40.sp, color: color_red_weak))));
                } else {
                  return residentList();
                }
              } else {
                return Expanded(
                    child: Center(child: CircularProgressIndicator()));
              }
            })
        : residentList();
  }

  Widget residentList() {
    return Expanded(child: residentListMain());
  }

  Widget residentListMain() {
    return Container(
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: shows.length,
            itemBuilder: (context, index) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[customListTile(index)]);
            }));
  }

  Widget searchTextFormField() {
    return Container(
        decoration: BoxDecoration(
          color: color_white,
        ),
        height: 60.sp,
        child: TextFormField(
          onChanged: (value) {
            searchName(value);
          },
          style: TextStyle(fontSize: 32.sp, color: color_main),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.text,
          cursorColor: color_gray,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search, color: color_gray, size: 44.sp),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(48.sp),
                  borderSide: BorderSide(color: color_main, width: 1.sp)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: color_main),
                  borderRadius: BorderRadius.circular(48.sp)),
              contentPadding:
                  new EdgeInsets.only(top: 0, bottom: 6.sp, left: 100.sp),
              hintText: SitLocalizations.of(context).search(),
              hintStyle: TextStyle(fontSize: 36.sp)),
        ));
  }

  Widget search() {
    return Container(
      color: color_white,
      margin:
          EdgeInsets.only(top: 12.sp, bottom: 12.sp, left: 240.w, right: 240.w),
      child: Form(
        child: Column(
          children: <Widget>[searchTextFormField()],
        ),
      ),
    );
  }

  Widget customListTile(int index) {
    return GestureDetector(
        onTap: () {
          gotoProfile(shows[index]);
        },
        child: Container(
          height: 120.sp,
          padding: EdgeInsets.only(
              top: 12.sp, bottom: 12.sp, right: 24.sp, left: 24.sp),
          decoration: BoxDecoration(
              // color: color_white,
              border: Border.all(color: color_gray, width: 1.sp)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Row(children: <Widget>[
                avatars[shows[index]] == null
                    ? CircleAvatar(
                        radius: 40.sp,
                        backgroundImage: AssetImage('assets/images/person.png'),
                      )
                    : CircleAvatar(
                        radius: 40.sp, backgroundImage: avatars[shows[index]]),
                Container(
                  margin: EdgeInsets.only(left: 48.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        residents[shows[index]]['user_id']['full_name'],
                        style: TextStyle(fontSize: 36.sp, color: color_green),
                      ),
                      Text(
                        residents[shows[index]]['house_id'],
                        style: TextStyle(color: color_gray, fontSize: 24.sp),
                      ),
                    ],
                  ),
                )
              ])),
              GestureDetector(
                  onTap: () {
                    gotoNotification(index);
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.notifications,
                        size: 64.sp,
                        color: color_green,
                      )))
            ],
          ),
        ));
  }
}
