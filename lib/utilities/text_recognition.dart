import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MLVision {
  static Future<VisionText> scanImage(CameraImage image, String search, int orientation) async {
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
      rotation: _getRotation(orientation),
    );
    final FirebaseVisionImage img =
        FirebaseVisionImage.fromBytes(image.planes[0].bytes, metadata);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    final VisionText text = await recognizer.processImage(img);

    return text;
  }

  static ImageRotation _getRotation(int rotation) {
    switch (rotation) {
      case 0: 
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;
    }
  }
}

class TextBoundingBox extends CustomPainter {

  TextBoundingBox({this.imageSize, this.text, this.search});

  final Size imageSize;
  final VisionText text;
  final String search;

  @override
  void paint(Canvas canvas, Size size) {
    final double X = size.width / this.imageSize.width;
    final double Y = size.height / this.imageSize.height;

    Rect scaleRect(TextContainer element) {
      return Rect.fromLTRB(
          element.boundingBox.left * X,
          element.boundingBox.right * X,
          element.boundingBox.top * Y,
          element.boundingBox.bottom * Y
          );
    }

    final Paint paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
    
    for (TextBlock block in text.blocks) {
      print(block.text);
      for (TextLine line in block.lines) {
        //for (TextElement element in line.elements) {
          // if (element.text == search) {
            paint.color = Colors.white;
            canvas.drawRect(scaleRect(line), paint);
          // }
        //}
      }
    }
  }

  @override
  bool shouldRepaint(TextBoundingBox  oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.text != text;
  }
}
