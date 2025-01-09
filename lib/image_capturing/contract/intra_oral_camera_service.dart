import 'dart:async';
import 'dart:io';

import 'package:camera_macos/camera_macos.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/image_capturing/model/active_rover_camera.dart';
import 'package:rover/image_capturing/model/rover_camera_description.dart';
import 'package:rover/image_capturing/model/rover_tooth_image.dart';
import 'package:rxdart/rxdart.dart';

part '../service/macos_intra_oral_camera_service.dart';

part '../service/windows_intra_oral_camera_service.dart';

abstract class IntraOralCameraService {
  final _activeCameraStreamController = BehaviorSubject<ActiveRoverCamera?>();
  final _availableCamerasStreamController = BehaviorSubject<List<RoverCameraDescription>>();

  Stream<ActiveRoverCamera?> get activeCameraStream;

  Stream<List<RoverCameraDescription>> get availableCamerasStream;

  Future<void> initializeDefaultCamera();

  Future<void> disposeCurrentCamera();

  void setActiveCamera(RoverCameraDescription selectedCamera);

  Future<RoverToothImage?> captureImage();

  Future<void> startPollingAvailableCameras();

  Future<void> stopPollingAvailableCameras();

  Future<void> _handleError(String errorText, String? errorDescription, {bool skipDispose = false}) async {
    if (!skipDispose) {
      await disposeCurrentCamera();
    }
    showErrorSnackbarWithClose(title: errorText, content: errorDescription);
    _activeCameraStreamController.addError(errorText);
    _availableCamerasStreamController.addError(errorText);
  }
}
