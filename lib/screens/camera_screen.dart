import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:ctrl_f/utilities/text_recognition.dart';
import 'package:ctrl_f/utilities/text_bounding_box.dart';
import 'package:ctrl_f/screens/search_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key key, @required this.camera}) : super(key: key);

  static final id = 'CameraScreen'; // Id of the route

  final CameraDescription camera;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializecontroller;
  bool isDetecting = false;
  String searchTerm;

  dynamic _result;

  void _detect(String term) {
    _controller.startImageStream((CameraImage image) {
      if (isDetecting) return;

      isDetecting = true;

      MLVision.scanImage(image, widget.camera.sensorOrientation).then((text) {
        setState(() {
          _result = text;
        });
      }).whenComplete(() => isDetecting = false);
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = CameraController(widget.camera, ResolutionPreset.high,
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
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CameraPreview(_controller),
                _buildResults(),
              ],
            ),
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
                ).then((text) {
                  setState(() {
                    searchTerm = text;
                    _detect(searchTerm);
                  });
                });
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

  Widget _buildResults() {
    CustomPainter painter;

    Size imageSize = Size(
      _controller.value.previewSize.height,
      _controller.value.previewSize.width,
    );

    painter = TextBoundingBox(
        imageSize: imageSize, text: _result, search: searchTerm);

    return CustomPaint(
      painter: painter,
    );
  }
}
