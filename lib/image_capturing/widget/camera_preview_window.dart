import 'dart:async';

import 'package:camera_macos/camera_macos.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:master_kit/util/platform.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/image_capturing/contract/intra_oral_camera_service.dart';
import 'package:rover/image_capturing/model/rover_tooth_image.dart';
import 'package:rover/image_capturing/model/teeth_selection_mode.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/service/intra_oral_camera_button_press_service.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/util/assets.dart';

class CameraPreviewWindow extends StatefulWidget {
  final double scaleRatio;

  const CameraPreviewWindow({super.key, required this.scaleRatio});

  @override
  State<CameraPreviewWindow> createState() => _CameraPreviewWindowState();
}

class _CameraPreviewWindowState extends State<CameraPreviewWindow> {
  final _cameraService = get<IntraOralCameraService>();
  final _cameraButtonService = get<IntraOralCameraButtonPressService>();
  final _dialogController = get<ImageCaptureDialogController>();
  late final StreamSubscription<DateTime> _streamSubscription;

  @override
  void initState() {
    super.initState();
    _cameraService.initializeDefaultCamera();
    _streamSubscription = _cameraButtonService.buttonPressedStream.listen((_) => _onCameraButtonPressed());
  }

  @override
  void dispose() {
    _cameraService.disposeCurrentCamera();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
        height: 364 * widget.scaleRatio,
        decoration: BoxDecoration(borderRadius: STANDARD_BORDER_RADIUS, color: appTheme?.colorScheme.grey200),
        child: HandlingStreamBuilder<String?>(
          stream: _dialogController.selectedToothPreviewIDStream,
          builder: (context, selectedImageID) {
            if (selectedImageID == null) {
              return _buildCameraPreview(appTheme);
            }
            return _buildImagePreview(_dialogController.getSelectedToothPreview()?.image);
          },
        ));
  }

  Widget _buildImagePreview(RoverToothImage? image) {
    return Image.memory(image!.bytes, fit: BoxFit.cover);
  }

  Widget _buildCameraPreview(AppTheme? appTheme) {
    return HandlingStreamBuilder(
      stream: _cameraService.activeCameraStream,
      errorBuilder: (_, __) => _buildCameraPreviewError(appTheme),
      builder: (_, camera) {
        if (camera == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return switch (Platform.current) {
          Platform.macOS => CameraMacOSView(
              deviceId: camera.id,
              fit: BoxFit.fitHeight,
              cameraMode: CameraMacOSMode.photo,
              onCameraInizialized: (_) {},
            ),
          _ => Transform.flip(flipX: true, child: CameraPlatform.instance.buildPreview(int.parse(camera.id))),
        };
      },
    );
  }

  Column _buildCameraPreviewError(AppTheme? appTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.svgImage('icon/alert'),
        SMALL_GAP,
        Text('Connection failed', style: appTheme?.textTheme.titleXL),
        const SizedBox(height: 4),
        Text(
          'Check the connection to the device',
          style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
        ),
      ],
    );
  }

  Future<void> _onCameraButtonPressed() async {
    final capturedImage = await _cameraService.captureImage();
    if (capturedImage != null) {
      _dialogController.deselectCurrentImage();
      final missingTeeth = _dialogController.missingTeeth;

      _dialogController.setOrAddToothPreview(
        capturedImage.id,
        ToothPreview(capturedImage, teeth: Set.from(_dialogController.selectedTeeth), missingTeeth: missingTeeth),
      );

      if (_dialogController.activeTeethSelectionMode == TeethSelectionMode.auto) {
        _dialogController.selectNextTeethBlock();
      }

      if (_dialogController.skipMissingTeeth) {
        _dialogController.keepFirstToothInBlock();
      }
    }
  }
}
