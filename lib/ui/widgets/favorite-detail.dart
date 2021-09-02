import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-msg-box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteDetail extends StatefulWidget {
  final guest;
  @override
  _FavoriteDetail createState() => _FavoriteDetail();
  FavoriteDetail({@required this.guest});
}

class _FavoriteDetail extends State<FavoriteDetail>
    with SingleTickerProviderStateMixin {
  var favorites = [];
  dynamic guest;
  var firstLoad = true;
  var status;
  var colors = [
    color_main,
    color_blue,
    color_green,
    color_red_weak,
    color_blue_weak,
  ];
  PageController tabController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();

    guest = widget.guest;
  }

  reload() {
    firstLoad = true;
    setState(() {});
  }

  loadFavorites() async {
    var result =
        await post('guest/favorites', {'guest': guest['_id']}, context);
    if (result['success']) {
      favorites = result['result']['favorites'];
      guest = result['result']['guest'];
    } else {
      favorites = [];
      guest = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: body(),
      floatingActionButton: SizedBox(
          width: 80.sp,
          child: FloatingActionButton(
            backgroundColor: color_red_weak,
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  Widget body() {
    return Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.sp))),
        child: Column(
          children: <Widget>[title(), Expanded(child: favoritesMain())],
        ));
  }

  Widget favoritesMain() {
    return FutureBuilder(
        future: loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return favoriteList();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget title() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 40.sp, vertical: 32.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Image(
                  image: AssetImage('assets/images/easylogo.png'),
                  width: 40.sp,
                  fit: BoxFit.fitWidth,
                )),
            Text(
              SitLocalizations.of(context).favorites(),
              style: TextStyle(color: color_main, fontSize: 40.sp),
            )
          ]),
          Text(
            guest['full_name'],
            style: TextStyle(color: color_blue, fontSize: 36.sp),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  refresh() async {
    setState(() {
      firstLoad = true;
    });
  }

  Widget favoriteList() {
    return favorites.length != 0
        ? ListView.builder(
            padding: EdgeInsets.all(0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return row(index);
            },
          )
        : Center(
            child: Text(
            SitLocalizations.of(context).noFavorites(),
            style: TextStyle(fontSize: 40.sp, color: color_gray),
          ));
  }

  List<Widget> getRows() {
    List<Widget> rows = [];
    for (var i = 0; i < favorites.length; i++) {
      rows.add(row(i));
    }
    return rows;
  }

  Widget row(index) {
    var item = favorites[index];
    return Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: color_blue_weak_half_trans,
          onTap: () {
            sendNotification(item);
            // onRowTap(item['_id'], item['status'], item['invitor_id']['_id']);
          },
          child: Container(
              height: 160.sp,
              padding: EdgeInsets.only(
                  top: 12.sp, bottom: 12.sp, right: 24.sp, left: 24.sp),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: color_gray, width: 1.sp)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(children: <Widget>[
                    item['user_id']['img_url'] == ''
                        ? CircleAvatar(
                            radius: 54.sp,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                          )
                        : CircleAvatar(
                            radius: 54.sp,
                            backgroundImage: AdvancedNetworkImage(
                                item['user_id']['img_url'],
                                fallbackAssetImage:
                                    'assets/images/person.png')),
                    Container(
                      margin: EdgeInsets.only(left: 48.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item['user_id']['full_name'],
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: color_green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['house_id'],
                            style:
                                TextStyle(color: color_main, fontSize: 24.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ])),
                ],
              )),
        ));
  }

  sendNotification(_resident) async {
    var msgBox;
    var dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: msgBox = CustomMsgBox(
          data: userNotifyMsg(context, 9, _resident['user_id']['full_name']),
          success: SitLocalizations.of(context).notificationSentSuccessful(),
          failure: SitLocalizations.of(context).notificationSentFailure(),
          initialState: NORMAL),
    );
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => dialog,
    );
    if (!result) {
      return;
    }
    msgBox.initialState = PENDING;
    dialog = Dialog(
      child: msgBox,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog);
    result = await post(
        'resident/notify',
        {
          'message': preDefinedMessages(9),
          'type': 9,
          'resident_id': _resident['user_id']['_id'],
          'other': guest['full_name'],
          'is_img': false,
          'img': guest['img_url'],
          'is_service': false,
          'is_event': false,
          'is_favorite': true
        },
        context);
    if (result['success']) {
      msgBox.setState(SUCCESS);
    } else {
      msgBox.setState(FAILURE);
    }
  }
}
