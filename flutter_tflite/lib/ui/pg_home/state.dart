import 'dart:developer';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../models/recognition.dart';
import '../../services/tensorflow_service.dart';

class HomeViewState extends ChangeNotifier {
  // ------------------------------- CONSTRUCTORS ------------------------------
  HomeViewState(this._tensorFlowService);

  // -------------------------------- FIELDS -----------------------------------
  late List<Recognition> recognitions = <Recognition>[];
  late final TensorFlowService _tensorFlowService;

  bool _isLoadModel = false;
  bool _isDetecting = false;

  // ----------------------------- PROPERTIES ----------------------------------
  bool _navigatedToCapture = false;
  bool get navigatedToCapture => _navigatedToCapture;

  int _widthImage = 0;
  int get widthImage => _widthImage;

  int _heightImage = 0;
  int get heightImage => _heightImage;

  final _cameraIndex = 0;
  int get cameraIndex => _cameraIndex;

  final _selectedObject = 'cat';
  String get selectedObject => _selectedObject;

  // ------------------------------- METHODS ----------------------------------
  Future<void> loadModel() async {
    await _tensorFlowService.loadModel();
    _isLoadModel = true;
  }

  void setNavigatedToCapture({required bool value}) {
    _navigatedToCapture = value;
    notifyListeners();
  }

  Future<void> runModel(BuildContext context, CameraImage cameraImage) async {
    try {
      if (_isLoadModel) {
        if (!_isDetecting) {
          if (!_navigatedToCapture) {
            _isDetecting = true;
            final startTime = DateTime.now().millisecondsSinceEpoch;
            final recognitions = await _tensorFlowService.runModelOnFrame(
              cameraImage,
            );
            final endTime = DateTime.now().millisecondsSinceEpoch;

            log('Time detection: ${endTime - startTime}');

            if (recognitions != null) {
              this.recognitions = findHighestConfidenceRecognition(
                List<Recognition>.from(
                  //ignore: argument_type_not_assignable
                  recognitions.map((model) => Recognition.fromJson(model)),
                ),
                selectedObject,
              );
              _widthImage = cameraImage.width;
              _heightImage = cameraImage.height;
              notifyListeners();
            }
            _isDetecting = false;
          }
        }
      } else {
        log(
          'Please run `loadModel(type)` before running `runModel(cameraImage)`',
        );
      }
    } on Exception catch (e) {
      log('$e');
    }
  }

  List<Recognition> findHighestConfidenceRecognition(
    List<Recognition> recognitions,
    String selectedObject,
  ) {
    final filteredRecognitions = recognitions
        .where((recognition) => recognition.detectedClass == selectedObject)
        .toList();
    if (filteredRecognitions.isEmpty) {
      return [];
    }
    Recognition? highestConfidenceRecognition;
    double highestConfidence = 0;

    for (final recognition in filteredRecognitions) {
      if (recognition.confidenceInClass! > highestConfidence) {
        highestConfidence = recognition.confidenceInClass!;
        highestConfidenceRecognition = recognition;
      }
    }
    return highestConfidenceRecognition == null
        ? []
        : [highestConfidenceRecognition];
  }

  Uint8List convertCameraImageToFile(CameraImage cameraImage) {
    try {
      // Step 1: Convert YUV data to RGB
      final image = _convertYUV420ToImage(cameraImage);
      if (image == null) {
        throw Exception('Failed to convert CameraImage to RGB.');
      }

      // Step 2: Encode the image as JPEG
      final jpegData = Uint8List.fromList(img.encodeJpg(image));

      return jpegData;
    } catch (e) {
      debugPrint('Error converting CameraImage to file: $e');
      rethrow;
    }
  }

  img.Image? _convertYUV420ToImage(CameraImage cameraImage) {
    try {
      final width = cameraImage.width;
      final height = cameraImage.height;

      // Plane data from CameraImage
      final yPlane = cameraImage.planes[0].bytes;
      final uPlane = cameraImage.planes[1].bytes;
      final vPlane = cameraImage.planes[2].bytes;

      // Calculate pixel strides
      final yRowStride = cameraImage.planes[0].bytesPerRow;
      final uvRowStride = cameraImage.planes[1].bytesPerRow;
      final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

      // Create an empty image buffer
      final image = img.Image(width: width, height: height);

      // Convert YUV to RGB
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final yIndex = y * yRowStride + x;
          final uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

          final yValue = yPlane[yIndex];
          final uValue = uPlane[uvIndex] - 128;
          final vValue = vPlane[uvIndex] - 128;

          // Convert YUV to RGB
          final r = (yValue + 1.402 * vValue).clamp(0, 255).toInt();
          final g = (yValue - 0.344 * uValue - 0.714 * vValue)
              .clamp(0, 255)
              .toInt();
          final b = (yValue + 1.772 * uValue).clamp(0, 255).toInt();
          final color = img.ColorRgb8(r, g, b);

          // Set the pixel color in the image buffer
          image.setPixel(x, y, color);
        }
      }

      return image;
    } on Exception catch (e) {
      debugPrint('Error converting YUV420 to RGB: $e');
      return null;
    }
  }

  Future<void> close() async {
    await _tensorFlowService.close();
  }
}
