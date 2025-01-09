part of '../contract/intra_oral_camera_service.dart';

/// This is a temporary solution so that multiple people can work on image capture with only 1 available windows laptop
class MacOsIntraOralCameraService extends IntraOralCameraService {
  CameraMacOSController? _cameraController;
  Completer<void>? _cameraDisposedCompleter;

  @override
  Stream<ActiveRoverCamera?> get activeCameraStream => _activeCameraStreamController.stream;

  @override
  Stream<List<RoverCameraDescription>> get availableCamerasStream => _availableCamerasStreamController.stream;

  @override
  Future<RoverToothImage?> captureImage() async {
    try {
      final image = await _cameraController?.takePicture();
      if (image == null || image.bytes == null) {
        return null;
      }
      return RoverToothImage(generateMediumRandomString(), image.bytes!, DateTime.now());
    } on Exception catch (e) {
      showErrorSnackbarWithClose(title: 'There was an error while capturing the image', content: e.toString());
      return null;
    }
  }

  @override
  Future<void> disposeCurrentCamera() async {
    try {
      _cameraDisposedCompleter = Completer<void>();
      // BUG FIX: Without this delay the app would crash due to app calling stopRunning between beginConfiguration
      // and commitConfiguration
      await Future<void>.delayed(Duration(milliseconds: 500));
      await _cameraController?.destroy();
      _cameraController = null;
      _cameraDisposedCompleter?.complete();
      _cameraDisposedCompleter = null;
    } on Exception catch (e) {
      await _handleError('There was an error while disposing current camera', e.toString());
    }
  }

  @override
  Future<void> initializeDefaultCamera() async {
    if (_cameraDisposedCompleter != null) {
      return;
    }
    try {
      /// BUG FIX: Without this delay fast enough dispose and initialization of the camera would crash the application
      /// It still crashes sometimes, but less often - we tried to fix it but couldn't
      await _cameraDisposedCompleter?.future.then((value) => Future<void>.delayed(Duration(milliseconds: 300)));
      if ((await _fetchAvailableCameras()) == false) {
        return;
      }
      final camera = await _autodetectCamera();
      if (camera == null) {
        await _handleError('There are no available cameras', 'Check connection to your camera');
        return;
      }
      await _initializeCamera(camera);
    } catch (e) {
      await _handleError('Failed to initialize camera', e.toString());
    }
  }

  @override
  Future<void> setActiveCamera(RoverCameraDescription selectedCamera) async {
    if (_activeCameraStreamController.valueOrNull == null ||
        selectedCamera != _activeCameraStreamController.value?.cameraDescription) {
      await _initializeCamera(selectedCamera);
    }
  }

  @override
  Future<void> startPollingAvailableCameras() async {
    // TODO: implement startPollingAvailableCameras
  }

  @override
  Future<void> stopPollingAvailableCameras() async {
    // TODO: implement stopPollingAvailableCameras
  }

  Future<void> _initializeCamera(RoverCameraDescription camera) async {
    try {
      await disposeCurrentCamera();
      final args = await CameraMacOS.instance.initialize(
        deviceId: camera.rawName,
        cameraMacOSMode: CameraMacOSMode.photo,
      );
      if (args == null) {
        await _handleError('Failed to initialize camera', 'CameraMacOSArguments is null');
        return;
      }
      _cameraController = CameraMacOSController(args);
      _activeCameraStreamController.add(ActiveRoverCamera(id: camera.rawName, cameraDescription: camera));
    } on Exception catch (e) {
      await _handleError('Unexpected error has occurred while initializing the camera', e.toString());
    }
  }

  Future<bool> _fetchAvailableCameras() async {
    try {
      await _cameraDisposedCompleter?.future.then((value) => Future<void>.delayed(Duration(milliseconds: 1000)));

      final cameras = await CameraMacOS.instance.listDevices(deviceType: CameraMacOSDeviceType.video);
      _availableCamerasStreamController.add(cameras.map(_cameraDescriptionToDropDownOptionMapper).toList());
      return true;
    } on FlutterError catch (e) {
      await _handleError(
        'Error while fetching available cameras',
        'Make sure that Rover application has camera and microphone permissions in Privacy & Security settings.\n\n$e',
      );
      return false;
    }
  }

  Future<RoverCameraDescription?> _autodetectCamera() async {
    if (!_availableCamerasStreamController.hasValue || _availableCamerasStreamController.value.isNullOrEmpty) {
      return null;
    }
    final cameras = _availableCamerasStreamController.value;
    return cameras.firstWhereOrNull((camera) => camera.rawName.contains('eb1a')) ??
        cameras.firstWhereOrNull((camera) => camera.displayName.startsWith('USB Camera')) ??
        cameras.firstOrNull;
  }

  RoverCameraDescription _cameraDescriptionToDropDownOptionMapper(CameraMacOSDevice camera) {
    return RoverCameraDescription(
      rawName: camera.deviceId,
      displayName: camera.localizedName ?? camera.deviceId,
    );
  }
}
