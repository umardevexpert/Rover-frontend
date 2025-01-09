import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/image_capturing/contract/intra_oral_camera_service.dart';
import 'package:rover/image_capturing/model/rover_camera_description.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down.dart';
import 'package:ui_kit/stream/widget/multi_stream_builder2.dart';

class IntraOralCameraOptionsDropdown extends StatefulWidget {
  const IntraOralCameraOptionsDropdown({super.key});

  @override
  State<IntraOralCameraOptionsDropdown> createState() => _IntraOralCameraOptionsDropdownState();
}

class _IntraOralCameraOptionsDropdownState extends State<IntraOralCameraOptionsDropdown> {
  final _cameraService = get<IntraOralCameraService>();

  @override
  void initState() {
    super.initState();
    _cameraService.startPollingAvailableCameras();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return MultiStreamBuilder2(
      stream1: _cameraService.availableCamerasStream,
      stream2: _cameraService.activeCameraStream,
      initialData: (<RoverCameraDescription>[], null),
      errorBuilder: (_, __) => const DropDown(options: <RoverCameraDescription>[], placeholder: 'Error'),
      builder: (_, availableCameras, activeCamera) => DropDown(
        placeholder: 'Select camera',
        options: availableCameras,
        value: activeCamera?.cameraDescription,
        optionWidgetBuilder: (_, camera) => Text(camera.displayName, style: appTheme?.textTheme.bodyL),
        displayStringForOption: (camera) => camera.displayName,
        onChanged: _cameraService.setActiveCamera,
      ),
    );
  }

  @override
  void dispose() {
    _cameraService.stopPollingAvailableCameras();
    super.dispose();
  }
}
