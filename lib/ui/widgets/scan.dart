import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:easyguard/http.dart';
import 'package:easyguard/public/colors.dart';
import 'package:easyguard/public/constants.dart';
import 'package:easyguard/public/lang/sit_localizations.dart';
import 'package:easyguard/ui/widgets/camera-form.dart';
import 'package:easyguard/ui/widgets/profile-resident.dart';
import 'package:easyguard/ui/widgets/custom-end-box.dart';
import 'package:easyguard/ui/widgets/user-main.dart';
import 'package:easyguard/ui/widgets/qr-form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easyguard/ui/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/lang.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easyguard/ui/widgets/back-button.dart';

class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  var takePicture;
  var cameras;
  double _width;
  double _height;
  static const NONE = 0x0000;
  static const QR_SCAN = 0x0001;
  static const BIO_SCAN = 0x0002;
  static const PLATE_SCAN = 0x0003;
  bool PLATE_SCAN_ADD = false;

  int scanMode = NONE;
  bool isLoading = false;
  // static var take;
  var plateFilePath, faceFilePath;
  bool scanning;
  bool scanSuccess;
  bool scanned;
  var messageTop;
  var messageBottom;
  var userId;

  var cameraForm;
  var qrForm;

  qrResumed() {
    setState(() {
      scanning = true;
      scanned = false;
      scanSuccess = false;
    });
  }

  void setScanState(scanning, scanned, scanSuccess, message) {
    setState(() {
      this.scanning = scanning;
      this.scanned = scanned;
      this.scanSuccess = scanSuccess;
      this.messageTop = message;
    });
  }

  returned() {
    setScanState(false, false, false, '');
    if (scanMode == PLATE_SCAN) {
      setState(() {
        deassociate = false;
      });
    }
  }

  deassociatePlate() async {
    var res = await post('removeplate', {'id': userId}, context);
    if (res['success']) {
      setScanState(
          false, true, true, SitLocalizations.of(context).plateDeAssociated());
      setState(() {
        deassociate = false;
      });
    } else {
      setScanState(false, true, false,
          SitLocalizations.of(context).plateDeAssociatedFail());
    }
  }

  DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();

    setScanState(false, false, false, '');
    loadCameras();
  }

  loadCameras() async {
    cameras = await availableCameras();
  }

  var deassociate = false;
  @override
  void dispose() {
    super.dispose();
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

  Future<bool> onPop() async {
    if (scanning) {
      if (scanMode == QR_SCAN) {
        setState(() {
          scanning = false;
          scanned = false;
          scanSuccess = false;
          scanMode = NONE;
        });
        return false;
      } else
        return false;
    }
    setState(() {
      scanning = false;
      scanned = false;
      scanSuccess = false;
    });
    if (scanMode == NONE) {
      onWillPop();
    } else {
      scanMode = NONE;
      setState(() {
        scanMode = NONE;
        deassociate = false;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return new WillPopScope(
        child: LoadingOverlay(
          child: Container(
              child: Stack(children: [
            Scaffold(
                backgroundColor: Colors.transparent,
                body: form(),
                floatingActionButton: deassociate
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 120.sp),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FloatingActionButton(
                                  backgroundColor: color_red_weak,
                                  onPressed: deassociatePlate,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/plate-trans.png'),
                                      height: 140.sp,
                                      width: 140.sp)),
                              Padding(
                                  padding: EdgeInsets.only(top: 10.sp),
                                  child: Text(
                                      SitLocalizations.of(context)
                                          .deassociate(),
                                      style: TextStyle(color: color_red_weak),
                                      textAlign: TextAlign.center))
                            ]))
                    : Container()),
            scanMode == NONE
                ? Container()
                : backButton(context, onPressed: onPop),
          ])),
          isLoading: isLoading,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
        ),
        onWillPop: onPop);
  }

  Widget optionForm() {
    return Column(children: <Widget>[
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 16.sp, bottom: 16.sp),
          child: Text(
            SitLocalizations.of(context).scanMode(),
            textAlign: TextAlign.center,
            style: TextStyle(color: color_green, fontSize: 48.sp),
          ),
        ),
        option("assets/images/qr.png", SitLocalizations.of(context).qrcode(),
            onQR),
        option("assets/images/face.png", SitLocalizations.of(context).bio(),
            onBio),
        option("assets/images/plate-outline.png",
            SitLocalizations.of(context).plate(), onPlate)
      ])))
    ]);
  }

  Widget option(image, caption, onTap) {
    var decoration = BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
        ),
        border: Border.all(width: 2.sp, color: color_main),
        borderRadius: BorderRadius.all(Radius.circular(_width / 4)));
    var style = TextStyle(color: color_main, fontSize: 36.sp);
    return GestureDetector(
        onTap: onTap,
        child: Container(
            child: Column(children: <Widget>[
          Container(
            height: _width / 3,
            width: _width / 3,
            decoration: decoration,
          ),
          Container(
              padding: EdgeInsets.only(top: 12.sp, bottom: 12.sp),
              child: Text(caption, style: style))
        ])));
  }

  Widget form() {
    switch (scanMode) {
      case NONE:
        scanning = false;
        return optionForm();
        break;
      case QR_SCAN:
        return scanForm();
      case BIO_SCAN:
        return scanForm();
      case PLATE_SCAN:
        return scanForm();
      default:
        return CircularProgressIndicator();
    }
  }

  Widget scanForm() {
    // print('displaying...');
    // if (scanMode == QR_SCAN) {
    //   cameraForm = null;
    // } else {
    //   qrForm = null;
    // }
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.all(32.sp),
                child: Stack(children: [
                  Column(children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                      onTap: scanMode == BIO_SCAN || scanMode == PLATE_SCAN
                          ? takeImage
                          : () {},
                      child: scanMode == QR_SCAN
                          ? (qrForm = QrForm(
                              sendString: qrCaptured,
                              resumed: qrResumed,
                            ))
                          : (scanMode == BIO_SCAN) || (scanMode == PLATE_SCAN)
                              ? (cameraForm = CameraForm(
                                  takePicture: takePicture,
                                  returned: returned,
                                  camera: cameras.first,
                                ))
                              : Container(),
                    )),
                    bottomMessageBar()
                  ]),
                  topMessageBar()
                ])))
      ],
    );
  }

  Widget bottomMessageBar() {
    var borderRadius = BorderRadius.all(Radius.circular(16.sp));
    var title = SitLocalizations.of(context).scanning();
    var showAddPlate = false;
    var color = color_blue;
    if (scanMode != NONE) {
      if (!scanning) {
        if (scanned) {
          color = scanSuccess ? color_green : color_red_weak;
          switch (scanMode) {
            case QR_SCAN:
              title = scanSuccess
                  ? SitLocalizations.of(context).validCode()
                  : SitLocalizations.of(context).invalidCode();
              break;
            case BIO_SCAN:
              title = scanSuccess
                  ? SitLocalizations.of(context).validUser()
                  : SitLocalizations.of(context).invalidUser();
              break;
            case PLATE_SCAN:
              color = scanSuccess ? color_blue : color_red_weak;
              title = scanSuccess
                  ? messageBottom
                  : SitLocalizations.of(context).invalidPlate();
              break;
          }
        } else {
          title = SitLocalizations.of(context).readyPleaseTapToScan();
        }
      } else {
        color = color_gray;
        title = SitLocalizations.of(context).scanning();
      }
    }
    if (scanMode == QR_SCAN || scanMode == BIO_SCAN) {
      if (!scanning && scanSuccess) {
        showAddPlate = true;
      }
    }
    return Container(
        margin: EdgeInsets.only(top: 32.sp),
        child: Row(children: [
          Expanded(
              child: GestureDetector(
                  onTap: onProfile,
                  child: Container(
                      alignment: Alignment.center,
                      height: 100.sp,
                      decoration: BoxDecoration(
                          borderRadius: borderRadius, color: color),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: color_white, fontSize: 48.sp),
                      )))),
          showAddPlate
              ? Container(
                  height: 100.sp,
                  width: 200.sp,
                  child: GestureDetector(
                      onTap: onAddPlate,
                      child: Column(children: [
                        // Icon(
                        //   EieoIcons.plate,
                        //   color: color_main,
                        //   size: 68.sp,
                        // ),
                        Image(
                          image: AssetImage('assets/images/plate.png'),
                          width: 64.sp,
                          fit: BoxFit.fitWidth,
                        ),
                        Text(
                          SitLocalizations.of(context).addPlate(),
                          style: TextStyle(color: color_main, fontSize: 26.sp),
                        )
                      ])),
                )
              : Container(),
        ]));
  }

  Widget topMessageBar() {
    if (messageTop != '' && scanned) {
      return Align(
          alignment: Alignment.topCenter,
          child: Container(
              margin: EdgeInsets.only(top: 0),
              width: 800.w,
              height: 100.sp,
              decoration: BoxDecoration(
                  color: color_white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.sp),
                      bottomRight: Radius.circular(16.sp))),
              child: Center(
                  child: Text(messageTop,
                      style: TextStyle(color: color_blue, fontSize: 48.sp)))));
    } else {
      return new Container();
    }
  }

  qrCaptured(qr) async {
    var body = <String, dynamic>{
      'qr': qr,
      'gte': getToday(),
      'lte': getTomorrow(),
      'now': getNow()
    };
    try {
      var result = await post('scan/qr', body, context);

      print('scanned........');

      if (result['success']) {
        userId = result['result']['id'];
        messageBottom = SitLocalizations.of(context).validCode();
        setScanState(
            false,
            true,
            true,
            SitLocalizations.of(context).welcome() +
                ' ' +
                result['result']['full_name']);
        validateResult(result['result']);
      } else {
        messageBottom = SitLocalizations.of(context).invalidCode();
        setScanState(false, true, false, '');
      }
    } catch (e) {
      setScanState(false, true, false, '');
    }
  }

  takeImage() async {
    if (scanned && !scanning) return;
    if (scanning) return;
    setScanState(true, false, false, '');

    print('taking....');
    faceFilePath = await cameraForm.takePicture();
    List<int> string = File(faceFilePath).readAsBytesSync();
    String base64 = base64Encode(string);
    var subUrl = scanMode == BIO_SCAN
        ? 'scan/face'
        : scanMode == QR_SCAN
            ? 'scan/qr'
            : PLATE_SCAN_ADD ? 'addplate' : 'scan/plate';
    var id = PLATE_SCAN_ADD ? userId : '';
    var body = <String, dynamic>{
      'img': base64,
      'id': id,
      'gte': getToday(),
      'lte': getTomorrow()
    };

    try {
      var result = await post(subUrl, body, context);
      cameraForm.pictureTaken();
      print('scanned........');

      if (result['success']) {
        var msg;
        userId = result['result']['id'];
        if (scanMode == PLATE_SCAN) {
          messageBottom = result['result']['full_name'];

          msg = PLATE_SCAN_ADD
              ? SitLocalizations.of(context).plateAssociated()
              : '';
          setState(() {
            deassociate = true;
          });
          setScanState(false, true, true, msg);
        } else {
          msg = SitLocalizations.of(context).welcome() +
              ' ' +
              result['result']['full_name'];
          validateResult(result['result']);
          setScanState(false, true, true, msg);
        }
      } else {
        setScanState(false, true, false, '');
      }
    } catch (e) {
      setScanState(false, true, false, '');
    }
    validateFace();
  }

  validateResult(result) async {
    if (result['show'] == 'ending') {
      showEndAlert(result['id']);
    } else if (result['show'] == 'detail') {
      openDetail(
          result['id'], result['full_name'], result['type'], result['img_url']);
    } else if (result['show'] == 'none') {
      if (result['type'].indexOf(1) >= 0 && result['notify']) {
        await post(
            'resident/notify',
            {
              'message': preDefinedMessages(9),
              'type': 9,
              'resident_id': result['other'],
              'other': result['full_name']
            },
            context);
      } else if (result['type'].indexOf(2) >= 0) {
        await post(
            'guest/setstate',
            {
              'invite_id': result['invite_id'],
              'visitor_id': result['id'],
              'status': 1,
              'service_id': result['other']
            },
            context);
      } else if (result['type'].indexOf(3) >= 0) {
        var res = await post(
            'guest/setstate',
            {
              'invite_id': result['other'],
              'visitor_id': result['id'],
              'status': 1
            },
            context);
        if (res['success'] && res['result']['notify']) {
          await post(
              'resident/notify',
              {
                'booth': '',
                'message': preDefinedMessages(10),
                'resident_id': res['result']['resident_id'],
                'type': 10,
                'img': result['img_url'],
                'is_img': false,
                'other': result['full_name'],
                'is_service': false,
                'is_event': res['result']['is_event'],
                'is_favorite': false
              },
              context);
        }
      }
    }
  }

  openDetail(id, fullName, type, imgUrl) async {
    var dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
      child: UserMain(
        guest: {'_id': id, 'full_name': fullName, 'img_url': imgUrl},
        types: type,
      ),
    );
    await showDialog(context: context, builder: (context) => dialog);
  }

  showEndAlert(id) async {
    var dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.sp)),
        child: CustomEndBox(
          message: SitLocalizations.of(context).ending(),
        ));
    var result = await showDialog(
        context: context, child: dialog, barrierDismissible: false);
    var res;
    if (result == 1) {
      res = await post(
          'guest/setstate',
          {
            'visitor_id': id,
            'status': 4,
          },
          context);
    } else if (result == 2) {
      res = await post(
          'guest/setstate', {'visitor_id': id, 'status': 2}, context);
    }
    setState(() {});
  }

  onQR() {
    setState(() {
      scanMode = QR_SCAN;
      scanning = true;
      scanSuccess = false;
    });
  }

  onBio() {
    setState(() {
      scanning = false;
      scanSuccess = false;
      scanMode = BIO_SCAN;
    });
  }

  onPlate() async {
    setState(() {
      isLoading = true;
    });
    var result = await get('residential/services', context);
    setState(() {
      isLoading = false;
    });
    if (result['result']['plate'])
      setState(() {
        scanning = false;
        scanSuccess = false;
        scanMode = PLATE_SCAN;
        PLATE_SCAN_ADD = false;
      });
    else {
      return showToast(SitLocalizations.of(context).plateNotAllowed());
    }
  }

  onAddPlate() async {
    if (scanMode == QR_SCAN) {
      setState(() {
        scanning = false;
        scanned = false;
        scanSuccess = false;
        scanMode = NONE;
      });
      await Future.delayed(Duration(milliseconds: 200));
      setState(() {
        scanMode = PLATE_SCAN;
        PLATE_SCAN_ADD = true;
      });
    } else {
      if (cameraForm != null && scanMode == BIO_SCAN) cameraForm.readyTaking();
      setState(() {
        scanning = false;
        scanSuccess = false;
        scanned = false;
        scanMode = PLATE_SCAN;
        PLATE_SCAN_ADD = true;
      });
    }

    // Future.delayed(Duration(milliseconds: 300));
  }

  onProfile() async {
    if (!scanning && scanned && scanSuccess && scanMode == PLATE_SCAN) {
      var subUrl = 'user/$userId';
      try {
        var response = await get(SERVER_URL + subUrl, context);

        if (response.statusCode != 200) {
          throw new Exception('Something went wrong');
        } else {
          var result = json.decode(response.body);

          var additional = {'visitor': false, 'visitor_name': ''};
          var imgUrl;
          if (result['visitor'] != null) {
            additional['visitor'] = true;
            additional['visitor_name'] = result['visitor']['full_name'];
            additional['visitor_img_url'] = result['visitor']['img_url'];
            imgUrl = result['visitor']['img_url'];
          } else {
            imgUrl = result['resident']['user_id']['img_url'];
          }

          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProfileResident(
                        resident: result['resident'],
                        add: additional,
                      )));
        }
      } catch (e) {
        return;
      }
    }
  }

  getToday() {
    var format = DateFormat('yyyy-MM-dd 00:00:00');
    var today = format.format(DateTime.now());
    return DateTime.parse(today).toUtc().toString();
  }

  getTomorrow() {
    var format = DateFormat('yyyy-MM-dd 23:59:59');
    var tomorrow = format.format(DateTime.now());
    return DateTime.parse(tomorrow).toUtc().toString();
  }

  getNow() {
    var format = DateFormat('yyyy-MM-dd HH:mm:ss');
    var now = format.format(DateTime.now());
    return DateTime.parse(now).toUtc().toString();
  }

  validateFace() async {}
}
