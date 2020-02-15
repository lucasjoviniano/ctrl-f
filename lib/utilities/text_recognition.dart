import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class MLVision {
  static Future<VisionText> scanImage(
      CameraImage image, int orientation) async {
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
    final FirebaseVisionImage img = FirebaseVisionImage.fromBytes(
        _concatenatePlanes(image.planes), metadata);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    final VisionText text = await recognizer.processImage(img);

    return text;
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
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
