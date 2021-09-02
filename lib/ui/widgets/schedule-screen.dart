import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localization_delegate.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/custom-modal-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/ui/widgets/toast.dart';

import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/ui/widgets/custom-alert.dart';
import 'package:easyguard/public/lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    var now = DateTime.now();
    var year = now.year;
    var month = now.month.toString().length == 1
        ? ('0' + now.month.toString())
        : now.month;
    var day =
        now.day.toString().length == 1 ? ('0' + now.day.toString()) : now.day;
    selectedDate = DateTime.parse('$year-$month-$day 00:00:00');
    super.initState();
  }

  var _width;
  DateTime selectedDate;
  List<dynamic> _visitors;
  List<double> widthFactor = [.12, .12, .14, .2, .18, .1, .1];
  DateTime currentBackPressTime;

  getSchedule(DateTime date) async {
    var result =
        await post('schedule/', {"date": date.toUtc().toString()}, context);
    if (result['success']) {
      _visitors = result['result'];
    } else {
      _visitors = [];
    }
  }

  DateTime getCurDate() {
    return selectedDate;
  }

  String getDate(DateTime time) {
    return time.toIso8601String().substring(0, 10);
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
    _width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/backgroundw.png'))),
          child: Column(
            children: <Widget>[
              dateArea(),
              headerArea(context),
              tableArea(context)
            ],
          )),
      onWillPop: onWillPop,
    );
  }

  Widget dateArea() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 6.sp),
        height: 54.sp,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: toPreviousDay,
              child: Container(
                child: Icon(
                  Icons.chevron_left,
                  size: 54.sp,
                  color: color_gray,
                ),
              ),
            ),
            new GestureDetector(
              onTap: () async {
                DateTime newDateTime = await showRoundedDatePicker(
                  context: context,
                  barrierDismissible: false,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                  borderRadius: 16.sp,
                );
                this.setState(() {
                  if (newDateTime != null) {
                    selectedDate = newDateTime;
                  }
                });
              },
              child: Text(
                getCurDate().toString().substring(0, 10),
                style: TextStyle(color: color_gray, fontSize: 36.sp),
              ),
            ),
            new GestureDetector(
              onTap: toNextDay,
              child: Container(
                child: Icon(
                  Icons.chevron_right,
                  size: 54.sp,
                  color: color_gray,
                ),
              ),
            ),
          ],
        ));
  }

  Widget headerArea(BuildContext context) {
    List<Widget> header = [];
    var headerHeight = 84.sp;
    int i = 0;
    List<String> headers = [];
    headers = [
      SitLocalizations.of(context).arrival(),
      SitLocalizations.of(context).departure(),
      SitLocalizations.of(context).resident(),
      SitLocalizations.of(context).visitor(),
      SitLocalizations.of(context).status(),
      SitLocalizations.of(context).type(),
      SitLocalizations.of(context).gate()
    ];
    for (var e in headers) {
      header
          .add(customContainer(widthFactor[i++], headerHeight, e, color_white));
    }
    i = 0;
    var headerRow = customRow(color_blue, header);
    return headerRow;
  }

  toNextDay() {
    setState(() {
      selectedDate = selectedDate.add(new Duration(days: 1));
    });
  }

  toPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(new Duration(days: 1));
    });
  }

  Widget tableArea(c) {
    return Expanded(
        child: Dismissible(
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd)
                toPreviousDay();
              else if (direction == DismissDirection.endToStart) toNextDay();
            },
            key: Key(getCurDate().toString()),
            child: FutureBuilder(
                future: getSchedule(getCurDate()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _visitors.length == 0
                        ? Center(
                            child: Text(
                            SitLocalizations.of(c).noSchedule(),
                            style:
                                TextStyle(fontSize: 40.sp, color: color_gray),
                          ))
                        : customDatatable(_visitors);
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Oops!\n' +
                          SitLocalizations.of(context).somethingWentWrong(),
                      style: TextStyle(color: color_red_weak, fontSize: 36.sp),
                    ));
                  }
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
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
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: textColor, fontSize: 24.sp),
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

  Widget customDatatable(List<dynamic> rows) {
    var rowHeight = 72.sp;

    List<Widget> rowsContainer = [];

    bool flag = true;

    for (int j = 0; j < rows.length; j++) {
      try {
        var row = rows[j];
        List<Widget> cells = [];
        Color color = flag ? color_blue_weak : color_gray_weak;
        flag = !flag;
        Color textColor = color_main;
        if (row['visitors'].length == 1 && row['visitors'][0]['status'] == 3) {
          color = color_red_weak;
          textColor = color_white;
        }
        String names = '';
        for (var visitor in row['visitors']) {
          names = names + ', ' + visitor['id']['full_name'];
        }
        names = names.substring(2);
        if (row['event_id'] != null) {
          color = color_main;
          textColor = color_white;
          // names = SitLocalizations.of(context).event();
        }
        String status = '';
        if (row['visitors'].length == 1)
          status = visitus(context, row['visitors'][0]['status']);
        String type = '';
        if (row['event']) {
          type = SitLocalizations.of(context).event();
        } else if (row['service']) {
          type = SitLocalizations.of(context).service();
        } else {
          type = SitLocalizations.of(context).guest();
        }
        String gate = '';
        if (row['visitors'].length == 1 && row['visitors'][0]['status'] != 0) {
          gate = row['visitors'][0]['booth']['full_name'];
        }
        cells.add(customContainer(widthFactor[0], rowHeight,
            getTimeFromDate(row['startTime']), textColor));
        cells.add(customContainer(widthFactor[1], rowHeight,
            getTimeFromDate(row['endTime']), textColor));
        cells.add(customContainer(widthFactor[2], rowHeight,
            row['invitor_id']['full_name'], textColor));
        cells.add(customContainer(widthFactor[3], rowHeight, names, textColor));
        cells
            .add(customContainer(widthFactor[4], rowHeight, status, textColor));
        cells.add(customContainer(widthFactor[5], rowHeight, type, textColor));
        cells.add(customContainer(widthFactor[6], rowHeight, gate, textColor));
        Widget rowCell = GestureDetector(
          child: customRow(color, cells),
          onTap: () {
            onRowTap(j);
          },
        );
        rowsContainer.add(rowCell);
      } catch (e) {
        continue;
      }
    }
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: rowsContainer.length,
      itemBuilder: (context, index) {
        return rowsContainer[index];
      },
    );
  }

  void onTap() async {}
  void onRowTap(index) async {
    var cnt = _visitors[index]['visitors'].length;
    if (cnt == 1) {
      if (_visitors[index]['visitors'][0]['status'] == 3) {
        var dialog = Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: CustomAlert(data: {
              'invite': _visitors[index]['_id'],
              'invitor': _visitors[index]['invitor_id'],
              'visitor': _visitors[index]['visitors'][0],
            }));
        var result = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => dialog,
        );
        if (result['success']) {
          if (result['type'] == EXTEND) {
            setState(() {});
          }
        }
        return;
      }
    } else {
      var dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
        child: CustomModal(
          inviteData: _visitors[index],
        ),
      );
      var result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog,
      );
      if (result) {
        setState(() {});
      }
    }
  }

  getTimeFromDate(String date) {
    final dateTime = DateTime.parse(date);
    DateFormat format = DateFormat('HH:mm');
    final localtime = dateTime.toLocal();
    // var formatTomorrow = DateFormat('yyyy-mm-dd 23:59:00');
    // var tomorrow = DateTime.now();
    // var tomorrowStr = formatTomorrow.format(tomorrow);
    // tomorrow = DateTime.parse(tomorrowStr);
    // if (localtime.compareTo(tomorrow) < 0) {
    //   format = DateFormat('dd HH:mm');
    // }
    return format.format(localtime);
  }
}
