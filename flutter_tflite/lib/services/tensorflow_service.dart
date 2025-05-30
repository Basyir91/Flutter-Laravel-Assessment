import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class TensorFlowService {
  // ------------------------------- METHODS -----------------------------------
  Future<void> loadModel() async {
    try {
      unawaited(Tflite.close());
      String? res;

      res = await Tflite.loadModel(
        model: 'assets/model.tflite',
        labels: 'assets/labels.txt',
      );

      if (kDebugMode) {
        print('loadModel: $res');
      }
    } on PlatformException {
      if (kDebugMode) {
        print('Failed to load model.');
      }
    }
  }

  Future<void> close() async {
    await Tflite.close();
  }

  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
    List<dynamic>? recognitions = <dynamic>[];
    recognitions = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: 'YOLO',
      imageHeight: image.height,
      imageWidth: image.width,
      imageMean: 0,
      imageStd: 255,
      threshold: 0.2,
      numResultsPerClass: 1,
    );
    if (kDebugMode) {
      print('recognitions: $recognitions');
    }
    return recognitions;
  }
}
