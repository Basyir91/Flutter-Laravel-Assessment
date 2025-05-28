import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../models/recognition.dart';
import '../pg_home/page.dart';

class CapturedScreen extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const CapturedScreen({super.key, this.recognition, this.image});

  // -------------------------------- FIELDS -----------------------------------
  final Recognition? recognition;
  final Uint8List? image;

  // ------------------------------- METHODS -----------------------------------
  @override
  State<CapturedScreen> createState() => _CapturedScreenState();
}

class _CapturedScreenState extends State<CapturedScreen> {
  // ------------------------------- METHODS -----------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (context) => const HomeScreen()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text('Preview Score'),
          actions: const [],
        ),
        body: _Body(recognition: widget.recognition, image: widget.image),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _Body({this.recognition, this.image});

  // -------------------------------- FIELDS -----------------------------------
  final Recognition? recognition;
  final Uint8List? image;

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    final confidence = ((recognition!.confidenceInClass ?? 0) * 100)
        .toStringAsFixed(0);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Transform.rotate(
                angle: pi / 2,
                child: Image.memory(image!),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    '“Detecting ${recognition!.detectedClass ?? ''}“',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('confidence%: $confidence%'),
                  const SizedBox(height: 8),
                  Text('Date: ${recognition!.date}'),
                  const SizedBox(height: 4),
                  Text('Timestamp: ${recognition!.timestamp}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
