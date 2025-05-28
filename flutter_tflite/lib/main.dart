import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/tensorflow_service.dart';
import 'ui/pg_home/page.dart';

// ################################# VARIABLES #################################
late List<CameraDescription> cameras;

// ------------------------------- METHODS -------------------------------------
Future<void> main() async {
  cameras = await availableCameras();
  runApp(const MyApp());
}

// ################################## CLASSES ##################################
class MyApp extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const MyApp({super.key});

  // ------------------------------- METHODS -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => TensorFlowService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const HomeScreen(),
      ),
    );
  }
}
