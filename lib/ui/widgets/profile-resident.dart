import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileResident extends StatefulWidget {
  final resident;
  final add;
  ProfileResident({@required this.resident, @required this.add});
  @override
  _ProfileResidentState createState() => _ProfileResidentState();
}

class _ProfileResidentState extends State<ProfileResident>
    with SingleTickerProviderStateMixin {
  LatLng _center;
  GoogleMapController _controller;
  final Set<Marker> _markers = new Set();
  var _resident;
  var _avatar;
  var _additional;
  var lat, lng;
  _ProfileResidentState();

  @override
  void initState() {
    super.initState();
  }

  load() async {
    _resident = widget.resident;
    _additional = widget.add;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    lat = sharedPreferences.getDouble('latitude');
    lng = sharedPreferences.getDouble('longitude');
    _markers.add(Marker(
        markerId: MarkerId('residential'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarker));
    _markers.add(Marker(
        markerId: MarkerId('resident'),
        position: LatLng(_resident['latitude'].toDouble(),
            _resident['longitude'].toDouble()),
        icon: BitmapDescriptor.defaultMarker));
    _center = LatLng(
        (lat + _resident['latitude']) / 2, (lng + _resident['longitude']) / 2);
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: <Widget>[profileForm()],
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: color_blue_weak_half_trans,
          ));
        }
      },
    );
  }

  Widget profileForm() {
    var visitor = false;
    if (_additional != null) {
      visitor = _additional['visitor'];
    }
    return Expanded(
        child: Stack(children: <Widget>[
      SingleChildScrollView(
          child: Column(children: <Widget>[
        avatar(),
        visitor
            ? other(SitLocalizations.of(context).resident(), Icons.person,
                _resident['user_id']['full_name'])
            : Container(),
        other(SitLocalizations.of(context).houseID(), Icons.home,
            _resident['house_id']),
        map()
      ])),
      Align(
          alignment: Alignment.bottomRight,
          child: new GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            Notifications(resident: _resident)));
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 24.sp, right: 24.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(64.sp)),
                    color: color_green,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: color_white,
                    size: 72.sp,
                  )))),
      Align(
          alignment: Alignment.topLeft,
          child: new GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 16.sp, left: 16.sp),
                  child: Text('< ' + SitLocalizations.of(context).retur(),
                      style: TextStyle(
                          fontSize: 40.sp,
                          color: color_main,
                          decorationStyle: TextDecorationStyle.solid)))))
    ]));
  }

  Widget avatar() {
    var visitor = false;
    if (_additional != null) {
      visitor = _additional['visitor'];
    }
    _avatar = null;
    var url = visitor
        ? _additional['visitor_img_url']
        : _resident['user_id']['img_url'];
    if (url != '') {
      try {
        _avatar = AdvancedNetworkImage(
          url,
          fallbackAssetImage: "assets/images/person.png",
        );
      } catch (e) {
        _avatar = null;
      }
    }
    return Container(
        padding: EdgeInsets.only(top: 24.h, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
                backgroundImage: _avatar == null
                    ? AssetImage('assets/images/person.png')
                    : _avatar,
                radius: 120.sp),
            Text(
              visitor
                  ? _additional['visitor_name']
                  : _resident['user_id']['full_name'],
              style: TextStyle(fontSize: 48.sp, color: color_main),
            ),
            Text(
              visitor
                  ? SitLocalizations.of(context).guest()
                  : SitLocalizations.of(context).resident(),
              style: TextStyle(fontSize: 40.sp, color: color_green),
            )
          ],
        ));
  }

  Widget other(title, icon, content) {
    return Container(
      padding: EdgeInsets.only(left: 120.w, right: 120.w, top: 24.sp),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 16.sp),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 32.sp,
                color: color_main,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 64.sp,
                color: color_main,
              ),
              Container(
                alignment: Alignment.topLeft,
                width: 740.w,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2.sp, color: color_main))),
                margin: EdgeInsets.only(left: 12.sp),
                child: Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: color_green,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget direction() {
    return Container(
      margin: EdgeInsets.only(left: 120.w, right: 120.w, top: 24.sp),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 16.sp),
            child: Text(
              SitLocalizations.of(context).direction(),
              style: TextStyle(
                fontSize: 32.sp,
                color: color_main,
              ),
              textAlign: TextAlign.left,
            ),
          ),
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
              style: TextStyle(
                fontSize: 24.sp,
                color: color_green,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget map() {
    return Container(
      padding:
          EdgeInsets.only(left: 120.w, right: 120.w, top: 24.sp, bottom: 48.sp),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 16.sp),
            child: Text(
              SitLocalizations.of(context).userLocations(),
              style: TextStyle(
                fontSize: 36.sp,
                color: color_main,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 480.h,
            decoration: BoxDecoration(
                border: Border.all(color: color_gray, width: 2.sp),
                borderRadius: BorderRadius.all(Radius.circular(12.sp))),
            child: GoogleMap(
              markers: _markers,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
