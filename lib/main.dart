import 'package:camera/camera.dart';
import 'package:ctrl_f/screens/camera_screen.dart';
import 'package:ctrl_f/screens/intro_screen.dart';
import 'package:ctrl_f/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  final prefs = await SharedPreferences.getInstance();
  bool accessed = prefs.getBool(kCheckAccessKey) ?? false;

  runApp(
    CtrlF(
      camera: cameras.first, // Back camera
      accessed: accessed,
    ),
  );
}

class CtrlF extends StatelessWidget {
  final CameraDescription camera;
  final bool accessed;

  CtrlF({Key key, @required this.camera, @required this.accessed});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: accessed ? CameraScreen.id : IntroScreen.id,
      routes: {
        CameraScreen.id: (context) => CameraScreen(camera: camera),
        IntroScreen.id: (context) => IntroScreen(),
      },
    );
  }
}
