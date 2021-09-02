// import 'package:easyguard/ui/widgets/qr_code_scanner.dart';
import 'package:flutter/material.dart';
// import 'package:qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easyguard/public/colors.dart';

typedef GetQrCode = Function();
typedef StopScanning = Function();
typedef ResumeScanning = Function();
typedef SendString = Function(String qr);
typedef Resumed = Function();
class QrForm extends StatefulWidget {
  QrForm({
    Key key,
    @required this.sendString, @required this.resumed
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrFormState();

  GetQrCode getQrCode;
  StopScanning stopScanning;
  ResumeScanning resumeScanning;
  SendString sendString;
  Resumed resumed;
}

class _QrFormState extends State<QrForm> {
  var qrText = '';

  var paused = false;
  QRViewController controller;
  
  final GlobalKey qrKey = GlobalKey(debugLabel: 'EIEO_QR');

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        child: Stack(
          children: <Widget>[
            QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: color_red_weak,
                  borderRadius: 16.sp,
                  borderLength: 36.sp,
                  borderWidth: 10.sp,
                  cutOutSize: 600.w,
                )),
            Align(
                alignment: Alignment.center,
                child: paused
                    ? FloatingActionButton(
                      heroTag: "qrCapture",
                        backgroundColor: color_blue_weak_half_trans,
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {
                            resumeScanning();
                          });
                        },
                      )
                    : Container())
          ],
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        stopScanning();
        widget.sendString(qrText);
      });
    });
  }

  getQrCode() {
    return qrText;
  }

  stopScanning() {
    paused = true;
    controller.pauseCamera();
  }

  resumeScanning() {
    qrText = '';
    controller.resumeCamera();
    paused = false;
    widget.resumed();
  }

  @override
  void initState() {
    super.initState();
    widget.getQrCode = getQrCode;
    widget.stopScanning = stopScanning;
    widget.resumeScanning = resumeScanning;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
