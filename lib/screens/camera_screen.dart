import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ctrl_f/utilities/text_recognition.dart';

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

  void ppp() {
    print('Testando');
  }

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
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                    Positioned.fill(
                      child: CameraPreview(_controller),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        width: 350.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Palavra',
                            ),
                            onSubmitted: (text) {
                              //ppp();
                              _aux(text);
                            },
                          ),
                        ),
                      ),
                    ),
                  ] +
                  basicWidgets,
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
