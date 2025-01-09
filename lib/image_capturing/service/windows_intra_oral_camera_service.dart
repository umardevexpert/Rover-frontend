part of '../contract/intra_oral_camera_service.dart';

const _CAMERA_DELIMITER_STRING = r' <\\?';
const _UPDATE_INTERVAL = Duration(seconds: 3);
const _deepListComparator = DeepCollectionEquality.unordered();

class WindowsIntraOralCameraService extends IntraOralCameraService {
  StreamSubscription<void>? _camerasPollingSubscription;

  @override
  Stream<ActiveRoverCamera?> get activeCameraStream => _activeCameraStreamController.stream;

  @override
  Stream<List<RoverCameraDescription>> get availableCamerasStream =>
      _availableCamerasStreamController.stream.distinct(_deepListComparator.equals);

  int? get _activeCameraId {
    final id = _activeCameraStreamController.valueOrNull?.id;
    return id?.byCalling(int.tryParse);
  }

  RoverCameraDescription? get _activeCamera => _activeCameraStreamController.valueOrNull?.cameraDescription;

  @override
  Future<void> initializeDefaultCamera() async {
    try {
      final camera = await _autodetectCamera();
      if (camera == null) {
        await _handleError('There are no available cameras', 'Check connection to your camera');
        return;
      }
      await _initializeCamera(camera);
    } on CameraException catch (e) {
      await _handleError('Failed to initialize camera', '${e.code} ${e.description}');
    } on Exception catch (e) {
      await _handleError('Unexpected error has occurred while initializing the camera', e.toString());
    }
  }

  @override
  Future<void> disposeCurrentCamera() async {
    if (_activeCameraId != null) {
      try {
        await CameraPlatform.instance.dispose(_activeCameraId!);
        _activeCameraStreamController.add(null);
      } on CameraException catch (e) {
        await _handleError('Error while disposing of the camera', '${e.code} ${e.description}', skipDispose: true);
      }
    }
  }

  @override
  Future<void> setActiveCamera(RoverCameraDescription selectedCamera) async {
    if (_activeCamera == null || selectedCamera != _activeCamera) {
      await _initializeCamera(selectedCamera);
    }
  }

  @override
  Future<RoverToothImage?> captureImage() async {
    try {
      if (_activeCameraId == null) {
        return null;
      }
      final imageFile = await CameraPlatform.instance.takePicture(_activeCameraId!);
      final imageBytes = await imageFile.readAsBytes();
      File(imageFile.path).deleteSync();
      return RoverToothImage(generateMediumRandomString(), imageBytes, DateTime.now());
    } on PlatformException catch (_) {
      showErrorSnackbarWithClose(title: 'Image was not taken', content: "You're taking images too fast");
      return null;
    } on Exception catch (e) {
      showErrorSnackbarWithClose(title: 'Error while capturing image', content: e.toString());
      return null;
    }
  }

  @override

  /// Continuously check for new cameras
  Future<void> startPollingAvailableCameras() async {
    _camerasPollingSubscription ??= Stream.periodic(_UPDATE_INTERVAL, (_) => _fetchAvailableCameras()).listen(null);
  }

  @override
  Future<void> stopPollingAvailableCameras() async {
    await _camerasPollingSubscription?.cancel();
    _camerasPollingSubscription = null;
  }

  Future<void> _initializeCamera(RoverCameraDescription camera) async {
    try {
      await disposeCurrentCamera();
      final cameraId = await CameraPlatform.instance.createCamera(
        CameraDescription(name: camera.rawName, lensDirection: CameraLensDirection.external, sensorOrientation: 0),
        ResolutionPreset.max,
      );
      await CameraPlatform.instance.initializeCamera(cameraId);
      _activeCameraStreamController.add(ActiveRoverCamera(id: cameraId.toString(), cameraDescription: camera));
    } on CameraException catch (e) {
      await _handleError('Failed to initialize camera', '${e.code} ${e.description}');
    } on Exception catch (e) {
      await _handleError('Unexpected error has occurred while initializing the camera', e.toString());
    }
  }

  Future<void> _fetchAvailableCameras() async {
    final cameras = await CameraPlatform.instance.availableCameras();
    _availableCamerasStreamController.add(cameras.map(_cameraDescriptionToDropDownOptionMapper).toList());
  }

  /// Searching for vendor id of mouth watch camera manufacturer, if theres none camera with that vendor id
  /// then look for USB video device and if that fails pick the first available one
  Future<RoverCameraDescription?> _autodetectCamera() async {
    await _fetchAvailableCameras();
    final cameras = _availableCamerasStreamController.value;
    return cameras.firstWhereOrNull((camera) => camera.rawName.contains('vid_eb1a')) ??
        cameras.firstWhereOrNull((camera) => camera.rawName.startsWith('USB Video Device')) ??
        cameras.firstOrNull;
  }

  RoverCameraDescription _cameraDescriptionToDropDownOptionMapper(CameraDescription camera) {
    final index = camera.name.indexOf(_CAMERA_DELIMITER_STRING);
    return RoverCameraDescription(
      rawName: camera.name,
      displayName: index != -1 && index != 0 ? camera.name.substring(0, index) : camera.name,
    );
  }
}
