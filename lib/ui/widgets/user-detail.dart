import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/eieoIcons.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/ui/widgets/guest-detail.dart';
import 'package:easyguard/ui/widgets/provider-detail.dart';
import 'package:easyguard/ui/widgets/favorite-detail.dart';
import 'package:easyguard/ui/widgets/resident-detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetail extends StatefulWidget {
  final guest;
  final types;
  @override
  _UserDetail createState() => _UserDetail();
  UserDetail({@required this.guest, @required this.types});
}

class _UserDetail extends State<UserDetail>
    with SingleTickerProviderStateMixin {
  var trans = false;
  var invitations = [];
  dynamic guest;
  dynamic types;
  var firstLoad = true;
  PageController tabController = PageController(initialPage: 0);
  _UserDetail();
  @override
  void initState() {
    super.initState();
    guest = widget.guest;
    types = widget.types;
  }

  reload() {
    firstLoad = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.sp))),
          child: Column(
            children: <Widget>[title(), Expanded(child: itemList(types))],
          )),
      // floatingActionButton: SizedBox(
      //     width: 80.sp,
      //     child: FloatingActionButton(
      //       backgroundColor: color_red_weak,
      //       child: Icon(Icons.arrow_back),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //     )),
    );
  }

  Widget title() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 32.sp),
      // height: 80.sp,
      // width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Center(
                  child: CircleAvatar(
                      backgroundImage: guest['img_url'] == ''
                          ? AssetImage('assets/images/person.png')
                          : AdvancedNetworkImage(guest['img_url'],
                              fallbackAssetImage: 'assets/images/person.png'),
                      radius: 64.sp))),
          Expanded(
              flex: 9,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      guest['full_name'],
                      style: TextStyle(color: color_blue, fontSize: 36.sp),
                      textAlign: TextAlign.left,
                    ),
                    Row(children: <Widget>[
                      Expanded(
                        child: Text(
                          // "jli",
                          SitLocalizations.of(context).userDetail(),
                          style: TextStyle(color: color_main, fontSize: 28.sp),
                          textAlign: TextAlign.left,
                          // maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ])
                  ]))
        ],
      ),
    );
  }

  Widget itemList(types) {
    return ListView.builder(
      itemCount: types.length,
      itemBuilder: (context, index) {
        return item(types[index], () {
          onItemTap(types[index]);
        });
      },
    );
  }

  Widget item(type, onTap) {
    var title = userType(context, type);
    var style = TextStyle(color: color_main, fontSize: 36.sp);
    var icon, iconColor, iconSize;
    if (type == 0) {
      icon = Icons.person;
      iconColor = color_green;
      iconSize = 80.sp;
    } else if (type == 1) {
      icon = Icons.star;
      iconColor = color_red_weak;
      iconSize = 80.sp;
    } else if (type == 2) {
      icon = EieoIcons.service;
      iconColor = color_blue;
      iconSize = 64.sp;
    } else {
      icon = Icons.people;
      iconColor = color_gray;
      iconSize = 80.sp;
    }
    return InkWell(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 24.sp),
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 24.sp),
            decoration: BoxDecoration(
                // color: Colors.white,
                // borderRadius: BorderRadius.all(Radius.circular(12.sp)),
                border:
                    Border(bottom: BorderSide(color: color_gray, width: 1.sp))
                // boxShadow: [
                //   BoxShadow(
                //       blurRadius: 4.sp,
                //       offset: Offset(3.sp, 0),
                //       color: color_gray_weak)
                // ]
                ),
            child: Row(children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: iconColor,
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Text(
                    title,
                    style: style,
                    textAlign: TextAlign.left,
                  ))
            ])));
  }

  onItemTap(type) async {
    var builder;
    switch (type) {
      case 0:
        builder = ResidentDetail(
          resident: guest['_id'],
        );
        break;
      case 1:
        builder = FavoriteDetail(guest: guest);
        break;
      case 2:
        builder = ProviderDetail(
          guest: guest,
          status: 4,
        );
        break;
      default:
        builder = GuestDetail(
          guest: guest,
          status: 4,
        );
        break;
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: builder,
      ),
    );
  }
}
