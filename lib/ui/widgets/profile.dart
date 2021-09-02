import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:easyguard/ui/widgets/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/ui/widgets/back-button.dart';

class Profile extends StatefulWidget {
  final resident;
  Profile({@required this.resident});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  LatLng _center;
  GoogleMapController _controller;
  final Set<Marker> _markers = new Set();
  var _resident;
  var _avatar;
  var lat, lng;

  @override
  void initState() {
    super.initState();
  }

  load() async {
    var result = await get('resident/' + widget.resident, context);
    if (result['success']) {
      _resident = result['result'];

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      lat = sharedPreferences.getDouble('latitude');
      lng = sharedPreferences.getDouble('longitude');
      _markers.add(Marker(
          markerId: MarkerId('residential'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarker));
      _markers.add(Marker(
          markerId: MarkerId('resident'),
          position:
              LatLng(1.0 * _resident['latitude'], 1.0 * _resident['longitude']),
          icon: BitmapDescriptor.defaultMarker));
      _center = LatLng((lat + _resident['latitude']) / 2,
          (lng + _resident['longitude']) / 2);
      await Future.delayed(Duration(seconds: 1));
    } else {
      Navigator.pop(context);
    }
  }

  loadAvatar() async {
    _avatar = null;
    var url = _resident['user_id']['img_url'];
    if (url == '') return;
    try {
      _avatar = AdvancedNetworkImage(
        url,
        fallbackAssetImage: "assets/images/person.png",
      );
    } catch (e) {
      _avatar = AssetImage('assets/images/person.png');
    }
  }

  gotoNotification() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => Notifications(resident: _resident)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(children: <Widget>[
              Scaffold(
                  backgroundColor: Colors.transparent,
                  body: profileForm(),
                  floatingActionButton: SizedBox(
                      width: 80.sp,
                      child: FloatingActionButton(
                          backgroundColor: color_green,
                          child: Icon(Icons.notifications, size: 64.sp),
                          onPressed: () {
                            gotoNotification();
                          }))),
              backButton(context)
            ]);
          } else {
            return Center(
                child: CircularProgressIndicator(
                    backgroundColor: color_blue_weak_half_trans));
          }
        });
  }

  Widget profileForm() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 80.sp, vertical: 0.sp),
        child: SingleChildScrollView(
            child: Column(
                children: <Widget>[avatar(), house(), direction(), map()])));
  }

  Widget avatar() {
    return Container(
        margin: EdgeInsets.only(top: 24.h, bottom: 0),
        // height: _height * 0.25,
        // decoration: BoxDecoration(border: Border.all(width: 1)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: _resident['user_id']['img_url'] == ''
                    ? AssetImage('assets/images/person.png')
                    : AdvancedNetworkImage(_resident['user_id']['img_url'],
                        fallbackAssetImage: 'assets/images/person.png'),
                radius: 120.sp,
              ),
              Text(_resident['user_id']['full_name'],
                  style: TextStyle(fontSize: 48.sp, color: color_main))
            ]));
  }

  Widget house() {
    return Container(
        padding: EdgeInsets.only(top: 24.sp),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 16.sp),
                alignment: Alignment.topLeft,
                child: Text(
                  SitLocalizations.of(context).houseID(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: color_main,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.home,
                      size: 64.sp,
                      color: color_main,
                    )),
                Expanded(
                    flex: 10,
                    child: Container(
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 2.sp, color: color_main))),
                        margin: EdgeInsets.only(left: 12.sp),
                        child: Text(_resident['house_id'],
                            style: TextStyle(
                                fontSize: 40.sp, color: color_green))))
              ])
            ]));
  }

  Widget direction() {
    return Container(
        margin: EdgeInsets.only(top: 24.sp),
        child: Column(children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 16.sp),
              child: Text(SitLocalizations.of(context).direction(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    color: color_main,
                  ),
                  textAlign: TextAlign.left)),
          Container(
              alignment: Alignment.topLeft,
              height: 200.sp,
              decoration: BoxDecoration(
                  color: color_white,
                  border: Border.all(color: color_gray, width: 2.sp),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              padding: EdgeInsets.all(16.sp),
              child: Text(
                  _resident['comment'] != ''
                      ? _resident['comment']
                      : SitLocalizations.of(context).noDirection(),
                  style: TextStyle(fontSize: 24.sp, color: color_green)))
        ]));
  }

  Widget map() {
    return Container(
        margin: EdgeInsets.only(top: 24.sp, bottom: 48.sp),
        child: Column(children: <Widget>[
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 16.sp),
              child: Text(SitLocalizations.of(context).userLocations(),
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: color_main,
                  ),
                  textAlign: TextAlign.left)),
          Container(
              height: 480.h,
              decoration: BoxDecoration(
                  border: Border.all(color: color_gray, width: 2.sp),
                  borderRadius: BorderRadius.all(Radius.circular(12.sp))),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                  child: GoogleMap(
                      markers: _markers,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      })))
        ]));
  }
}
