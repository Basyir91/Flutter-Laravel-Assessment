import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/recognition.dart';

class ConfidenceWidget extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const ConfidenceWidget({
    required this.heightAppBar,
    required this.entities,
    required this.previewWidth,
    required this.previewHeight,
    required this.screenWidth,
    required this.screenHeight,
    required this.selectedObject,
    super.key,
  });

  // -------------------------------- FIELDS -----------------------------------
  final List<Recognition> entities;
  final String selectedObject;
  final int previewWidth;
  final int previewHeight;
  final double screenWidth;
  final double screenHeight;
  final double heightAppBar;

  // ------------------------------- METHODS -----------------------------------
  List<Widget> _renderHeightLineEntities() {
    var results = <Widget>[];

    if (entities.isEmpty) {
      results.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Detecting $selectedObject'),
          ),
        ),
      );
    } else {
      results = entities.map((entity) {
        final rectX = entity.rect!.x;
        final rectY = entity.rect!.y;
        final rectW = entity.rect!.w;
        final rectH = entity.rect!.h;

        final screenRatio = screenHeight / screenWidth;
        final previewRatio = previewHeight / previewWidth;

        double scaleWidth;
        double scaleHeight;
        double x;
        double y;
        double w;
        double h;

        if (screenRatio > previewRatio) {
          scaleHeight = screenHeight;
          scaleWidth = screenHeight / previewRatio;
          final difW = (scaleWidth - screenWidth) / scaleWidth;
          x = (rectX - difW / 2) * scaleWidth;
          w = rectW * scaleWidth;
          if (rectX < difW / 2) {
            w -= (difW / 2 - rectX) * scaleWidth;
          }
          y = rectY * scaleHeight;
          h = rectH * scaleHeight;
        } else {
          scaleHeight = screenWidth * previewRatio;
          scaleWidth = screenWidth;
          final difH = (scaleHeight - screenHeight) / scaleHeight;
          x = rectX * scaleWidth;
          w = rectW * scaleWidth;
          y = (rectY - difH / 2) * scaleHeight;
          h = rectH * scaleHeight;
          if (rectY < difH / 2) {
            h -= (difH / 2 - rectY) * scaleHeight;
          }
        }

        final confidence = ((entity.confidenceInClass ?? 0) * 100)
            .toStringAsFixed(0);

        return Positioned(
          left: max(0, x),
          top: max(0, y),
          width: w,
          height: h,
          child: Container(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Column(
              children: [
                Text(
                  '“Detecting ${entity.detectedClass ?? ''} $confidence%',
                  overflow: TextOverflow.ellipsis,
                ),
                if (rectW < 0.3 * screenWidth)
                  const Text(
                    'Move closer',
                    style: TextStyle(color: Colors.red),
                  ),
                if (rectW > 0.7 * screenWidth)
                  const Text(
                    'Move farther',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        );
      }).toList();
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _renderHeightLineEntities());
  }
}
