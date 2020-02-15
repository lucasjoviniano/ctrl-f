import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

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
          element.boundingBox.top * Y,
          element.boundingBox.right * X,
          element.boundingBox.bottom * Y);
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0x50a7f2a4);

    for (TextBlock block in text.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          if (element.text.toLowerCase() == search.toLowerCase()) {
            canvas.drawRect(scaleRect(element), paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(TextBoundingBox oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.text != text;
  }
}