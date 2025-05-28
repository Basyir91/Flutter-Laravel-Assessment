import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../services/tensorflow_service.dart';
import '../components/confidence_widget.dart';
import '../pg_preview/page.dart';
import 'state.dart';

class HomeScreen extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const HomeScreen({super.key});

  // --------------------------------- METHODS ---------------------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewState>(
      create: (_) => HomeViewState(context.read<TensorFlowService>()),
      child: const _Content(),
    );
  }
}

class _Content extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  // -------------------------------- FIELDS -----------------------------------
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  // ----------------------------- PROPERTIES ----------------------------------
  @override
  bool get wantKeepAlive => false;

  // ------------------------------- METHODS -----------------------------------
  void afterFirstBuild(BuildContext context) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<HomeViewState>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        afterFirstBuild(context);
      }
    });

    state.loadModel();
    initCamera();
  }

  void initCamera() {
    final state = context.read<HomeViewState>();

    _cameraController = CameraController(
      cameras[state.cameraIndex],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.setFlashMode(FlashMode.off);

      setState(() {});
      _cameraController.startImageStream((image) async {
        if (!mounted) {
          return;
        }
        await state.runModel(context, image);
        await handleCaptureWhenDetect(image);
      });
    });
  }

  Future<void> handleCaptureWhenDetect(CameraImage cameraImage) async {
    if (!mounted) {
      return;
    }
    final state = context.read<HomeViewState>();

    if (state.recognitions.isNotEmpty &&
        state.recognitions[0].confidenceInClass! > 0.7 &&
        !state.navigatedToCapture) {
      final list = state.convertCameraImageToFile(cameraImage);
      state.setNavigatedToCapture(value: true);
      Future.delayed(const Duration(seconds: 3), () async {
        final now = DateTime.now();

        state.recognitions[0].timestamp = DateFormat('yyyy-MM-dd').format(now);
        state.recognitions[0].date = DateFormat('HH:mm:ss').format(now);

        if (!mounted) {
          return;
        }
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CapturedScreen(recognition: state.recognitions[0], image: list),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    context.read<HomeViewState>()
      ..close()
      ..setNavigatedToCapture(value: false);
    _cameraController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else {
      initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<HomeViewState>(
      builder: (context, state, _) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: const Text('Cat Detection'),
            ),
            body: _Body(
              cameraController: _cameraController,
              initializeControllerFuture: _initializeControllerFuture,
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const _Body({
    required this.cameraController,
    required this.initializeControllerFuture,
  });

  // -------------------------------- FIELDS -----------------------------------
  final CameraController cameraController;
  final Future<void> initializeControllerFuture;

  // ----------------------------- PROPERTIES ----------------------------------
  double get heightAppBar => AppBar().preferredSize.height;
  bool get isInitialized => cameraController.value.isInitialized;
  Size get previewSize => isInitialized
      ? cameraController.value.previewSize!
      : const Size(100, 100);
  double get previewHeight => max(previewSize.height, previewSize.width);
  double get previewWidth => min(previewSize.height, previewSize.width);

  // ------------------------------- METHODS -----------------------------------
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final double screenHeight = max(screen.height, screen.width);
    final double screenWidth = min(screen.height, screen.width);
    final screenRatio = screenHeight / screenWidth;
    final previewRatio = previewHeight / previewWidth;
    final maxHeight = screenRatio > previewRatio
        ? screenHeight
        : screenWidth * previewRatio;
    final maxWidth = screenRatio > previewRatio
        ? screenHeight / previewRatio
        : screenWidth;

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              OverflowBox(
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                child: FutureBuilder<void>(
                  future: initializeControllerFuture,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(cameraController);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Consumer<HomeViewState>(
                builder: (_, state, _) {
                  return ConfidenceWidget(
                    heightAppBar: heightAppBar,
                    entities: state.recognitions,
                    previewHeight: max(state.heightImage, state.widthImage),
                    previewWidth: min(state.heightImage, state.widthImage),
                    screenWidth: MediaQuery.of(context).size.width,
                    screenHeight: MediaQuery.of(context).size.height,
                    selectedObject: state.selectedObject,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
