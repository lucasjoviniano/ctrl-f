import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ctrl_f/utilities/text_recognition.dart';
import 'package:ctrl_f/screens/search_screen.dart';

class CameraScreen extends StatefulWidget {
  static final id = 'CameraScreen'; // Id of the route
  final CameraDescription camera;

  const CameraScreen({Key key, @required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializecontroller;
  bool isDetecting = false;

  List<Widget> basicWidgets = [];

  void _aux(String term) {
    print('Entering aux');

    _controller.startImageStream((CameraImage image) {
      if (isDetecting) return;
      print('Detecting');
      print('*' * 100);
      isDetecting = true;
      MLVision.scanImage(image, term).then((_) {
        return;
      }).whenComplete(() => isDetecting = false);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.medium,
        enableAudio: false);

    _initializecontroller = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializecontroller,
      builder: (context, snapshot) {
        // If the camera can be used
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: CameraPreview(_controller),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      // Adjust the bottomsheet above the keyboard
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SearchScreen(),
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.search,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
