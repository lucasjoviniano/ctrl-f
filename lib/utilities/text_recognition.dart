import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MLVision {
  static Future<void> scanImage(CameraImage image, String search) async {
    print('Scanning...');
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes
          .map((plane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: plane.bytesPerRow,
                height: plane.height,
                width: plane.width,
              ))
          .toList(),
      rotation: ImageRotation.rotation90,
    );
    final FirebaseVisionImage img =
        FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    final VisionText text = await recognizer.processImage(img);

    int l = 0;

    for (TextBlock block in text.blocks) {
      print(block.text);
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          if (element.text == search) {
            l++;
          }
        }
      }
    }
    print('Number: $l');

    //return l;
  }
}

class BoundBox extends CustomPainter {
  BoundBox({this.box});

  final Rect box;

  final pnt = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      box,
      pnt,
    );
  }

  @override
  bool shouldRepaint(BoundBox old) => false;
}
