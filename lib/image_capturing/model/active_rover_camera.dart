import 'package:rover/image_capturing/model/rover_camera_description.dart';

class ActiveRoverCamera {
  /// Id used for camera initialization and preview building
  final String id;
  final RoverCameraDescription cameraDescription;

  const ActiveRoverCamera({required this.id, required this.cameraDescription});
}
