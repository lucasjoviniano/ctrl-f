import 'package:camera/camera.dart';
import 'package:ctrl_f/screens/camera_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  runApp(
    CtrlF(
      camera: cameras.first,
    ),
  );
}

class CtrlF extends StatelessWidget {
  final CameraDescription camera;

  CtrlF({Key key, @required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: CameraScreen.id,
      routes: {
        CameraScreen.id: (context) => CameraScreen(camera: camera),
      },
    );
  }
}
