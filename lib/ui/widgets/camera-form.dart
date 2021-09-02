import 'dart:io';

import 'package:easyguard/public/colors.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef Takepicture = Function();
typedef PictureTaken = Function();
typedef ReadyTaking = Function();

class CameraForm extends StatefulWidget {
  CameraDescription camera;
  Takepicture takePicture;
  PictureTaken pictureTaken;
  ReadyTaking readyTaking;
  final returned;
  CameraForm({this.takePicture, this.returned, @required this.camera});
  @override
  _CameraFormState createState() => _CameraFormState();
}

class _CameraFormState extends State<CameraForm> {
  List<CameraDescription> cameras;

  CameraController controller;
  Future<void> _initializeControllerFuture;
  ResolutionPreset resolution = ResolutionPreset.high;

  bool pictureTaken = false;
  bool takingPicture = false;
  var tempPath;
  bool firstLoad = true;
  loadCameras() {
    controller = CameraController(widget.camera, ResolutionPreset.high,
        enableAudio: true);
    _initializeControllerFuture = controller.initialize();
    return;
  }

  takePicture() async {
    try {
      await _initializeControllerFuture;
      // await controller.stopVideoRecording();
      // await controller.stopImageStream();
      final path = join((await getTemporaryDirectory()).path,
          DateTime.now().toIso8601String());
      // if (await File(path).exists()) await File(path).delete();
      await controller.takePicture(path);
      setState(() {
        tempPath = path;
        takingPicture = true;
      });
      return path;
    } catch (e) {
      return '';
    }
  }

  pictureTakne() async {
    print('taken...');
    setState(() {
      pictureTaken = true;
    });
  }

  readyTaking() async {
    setState(() {
      pictureTaken = false;
      takingPicture = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadCameras();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.pictureTaken = pictureTakne;
    widget.takePicture = takePicture;
    widget.readyTaking = readyTaking;
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16.sp)),
        child: takingPicture
            ? Stack(children: <Widget>[
                Image.file(File(tempPath),
                    fit: BoxFit.fill, width: double.infinity),
                Align(
                    alignment: Alignment.center,
                    child: pictureTaken
                        ? FloatingActionButton(
                            heroTag: 'capturePicture',
                            backgroundColor: color_blue_weak_half_trans,
                            child: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                pictureTaken = false;
                                takingPicture = false;
                                widget.returned();
                              });
                            })
                        : CircularProgressIndicator())
              ])
            : FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If the Future is complete, display the preview.

                    return CameraPreview(controller);
                  } else if (snapshot.error != null) {
                    return Container();
                  } else {
                    // Otherwise, display a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }
                }));
  }
}
