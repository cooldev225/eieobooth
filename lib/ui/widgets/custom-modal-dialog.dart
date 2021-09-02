import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-alert.dart';
import 'package:easyguard/ui/widgets/send-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomModal extends StatefulWidget {
  final inviteData;
  @override
  _CustomModalState createState() => _CustomModalState(inviteData: inviteData);
  CustomModal({@required this.inviteData});
}

class _CustomModalState extends State<CustomModal>
    with SingleTickerProviderStateMixin {
  double _width;
  double _height;
  dynamic inviteData;
  var reload = false;
  _CustomModalState({@required this.inviteData});
  @override
  void initState() {
    super.initState();
  }

  load() async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    var decoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        color: color_white);
    var commentDecoration = BoxDecoration(
        color: color_white,
        borderRadius: BorderRadius.all(Radius.circular(12.sp)),
        boxShadow: [
          BoxShadow(
              blurRadius: 6.sp, color: color_gray, offset: Offset(0, 4.sp))
        ]);
    var titleStyle = TextStyle(color: color_main, fontSize: 54.sp);
    var nameStyle = TextStyle(color: color_main, fontSize: 36.sp);
    var timeStyle = TextStyle(color: color_main, fontSize: 32.sp);
    var commentStyle = TextStyle(color: color_main, fontSize: 32.sp);
    var headerTitles = [
      SitLocalizations.of(context).visitor(),
      SitLocalizations.of(context).status(),
      SitLocalizations.of(context).gate()
    ];
    return WillPopScope(
      child: FutureBuilder(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var time = getTimeFromDate(inviteData['startTime']) +
                  '    ' +
                  getTimeFromDate(inviteData['endTime']);

              return Container(
                  height: _height * 0.8,
                  width: _width * 0.76,
                  decoration: decoration,
                  padding: EdgeInsets.only(
                      top: 16.sp,
                      bottom: 8.sp,
                      left: _width * .06,
                      right: _width * .06),
                  child: Column(children: <Widget>[
                    Container(
                      child: Text(
                        inviteData['title'],
                        style: titleStyle,
                      ),
                      margin:
                          EdgeInsets.only(top: 0, left: 16.sp, right: 16.sp),
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    Container(
                      child: Text(
                        inviteData['invitor_id']['full_name'],
                        style: nameStyle,
                      ),
                      margin: EdgeInsets.only(
                          top: 16.sp, left: 16.sp, right: 16.sp),
                      width: _width,
                    ),
                    Container(
                        child: Text(
                          time,
                          style: timeStyle,
                        ),
                        margin: EdgeInsets.only(
                            top: 16.sp, left: 16.sp, right: 16.sp),
                        width: _width),
                    // ],),
                    Container(
                        padding: EdgeInsets.all(16.sp),
                        height: _height * 0.12,
                        width: _width,
                        margin: EdgeInsets.only(
                            top: 10, left: 0, right: 0, bottom: 16.sp),
                        decoration: commentDecoration,
                        child: SingleChildScrollView(
                            child: Text(
                          inviteData['comment'],
                          style: commentStyle,
                        ))),
                    customDatatable(headerTitles, inviteData['visitors']),
                    buttonArea()
                  ]));
            } else {
              return Container(
                  height: _height * 0.8,
                  width: _width * 0.76,
                  decoration: decoration,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  )));
            }
          }),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget buttonArea() {
    return Container(
      child: sendButton(context, SitLocalizations.of(context).retur(),
          color_white, color_blue, 280.sp, 32.sp, onTap),
    );
  }

  Widget customContainer(width, double height, text, textColor) {
    var dec =
        BoxDecoration(border: Border.all(color: color_white, width: 1.sp));
    return new Container(
        decoration: dec,
        padding: EdgeInsets.only(left: 6.sp, right: 6.sp),
        margin: EdgeInsets.all(0),
        width: width * _width,
        height: height,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 24.sp),
                overflow: TextOverflow.ellipsis,
              )
            ]));
  }

  Widget customRow(color, cells) {
    return Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        color: color,
        child: Row(children: cells));
  }

  Widget customDatatable(List<String> headers, List<dynamic> rows) {
    var headerHeight = 72.sp;
    var rowHeight = 60.sp;
    List<Widget> header = [];
    List<double> widthFactor = [.32, .16, .16];
    int i = 0;
    for (var e in headers) {
      header
          .add(customContainer(widthFactor[i++], headerHeight, e, color_white));
    }
    i = 0;
    var headerRow = customRow(color_blue, header);
    List<Widget> rowsContainer = [];

    bool flag = true;
    for (int i = 0; i < rows.length; i++) {
      var row = rows[i];
      List<Widget> cells = [];
      Color color = flag ? color_blue_weak : color_gray_weak;
      flag = !flag;
      Color textColor = color_main;
      if (row['status'] == 3) {
        color = color_red_weak;
        textColor = color_white;
      }
      String names = row['id']['full_name'];
      String status = visitus(context, row['status']);
      String gate = '';
      if (row['status'] != 0) {
        gate = row['booth']['full_name'];
      }
      cells.add(customContainer(widthFactor[0], rowHeight, names, textColor));
      cells.add(customContainer(widthFactor[1], rowHeight, status, textColor));
      cells.add(customContainer(widthFactor[2], rowHeight, gate, textColor));
      Widget rowCell = GestureDetector(
        child: customRow(color, cells),
        onTap: () {
          onRowTap(i);
        },
      );

      rowsContainer.add(rowCell);
    }
    i = 0;
    return Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 0, right: 0, bottom: 12.sp),
            child: Column(
              children: <Widget>[
                headerRow,
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: rowsContainer,
                )))
              ],
            )));
  }

  void onRowTap(index) async {
    if (inviteData['visitors'][index]['status'] == 3) {
      var dialog = Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: CustomAlert(data: {
            'invite': inviteData['_id'],
            'invitor': inviteData['invitor_id'],
            'visitor': inviteData['visitors'][index],
          }));
      var result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog,
      );
      if (result['success']) {
        if (result['type'] == EXTEND) {
          reload = true;
          inviteData = result['result'];
          setState(() {});
        }
      }
    }
  }

  void onTap() async {
    Navigator.of(context).pop(reload);
  }

  getTimeFromDate(String date) {
    final dateTime = DateTime.parse(date);
    DateFormat format = DateFormat('HH:mm');
    final localtime = dateTime.toLocal();
    return format.format(localtime);
  }
}
