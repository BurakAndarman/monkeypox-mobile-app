// ignore_for_file: file_names

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ViewCamera extends StatefulWidget {
  /// Default Constructor
  const ViewCamera({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<ViewCamera> createState() => ViewCameraState();
}

class ViewCameraState extends State<ViewCamera> {
  late CameraController controller;

  bool isLoading = true;

  @override
  void initState() {
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
    super.initState();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text('Camera Initializing...'),
                  ],
                ),
              )
            : Center(child: CameraPreview(controller)));
  }
}
