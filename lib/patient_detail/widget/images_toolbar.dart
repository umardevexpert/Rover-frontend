import 'dart:io';

import 'package:flutter/material.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/image_capturing/model/rover_tooth_image.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/service/intra_oral_camera_button_press_service.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient_detail/widget/tooth_image_sorting_dropdown.dart';
import 'package:rover/patient_detail/widget/tooth_number_picker.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:ui_kit/util/assets.dart';
import 'package:window_manager/window_manager.dart';

class ImagesToolbar extends StatelessWidget {
  final _cameraButtonService = get<IntraOralCameraButtonPressService>();
  final _dialogController = get<ImageCaptureDialogController>();

  final Patient patient;

  ImagesToolbar({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: ToothImageSortingDropdown()),
              SMALL_GAP,
              Expanded(child: ToothNumberPicker(patientId: patient.id)),
            ],
          ),
        ),
        STANDARD_GAP,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                size: SecondaryButtonSize.large,
                onPressed: _snipPhoto,
                prefixIcon: Assets.svgImage('icon/crop'),
                child: Text('Snip Photo'),
              ),
              SMALL_GAP,
              SecondaryButton(
                size: SecondaryButtonSize.large,
                variant: SecondaryButtonVariant.fill,
                onPressed: () => _cameraButtonService.openImageCaptureDialog(patient),
                prefixIcon: Assets.svgImage('icon/camera'),
                child: Text('Intraoral Camera'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _snipPhoto() async {
    try {
      await windowManager.minimize();
      final applicationCacheDirectory = await getApplicationCacheDirectory();
      final now = DateTime.now();
      final imageName = 'Snip-${now.millisecondsSinceEpoch}.png';
      final imagePath = '${applicationCacheDirectory.absolute.path}${Platform.pathSeparator}$imageName';
      final capturedData = await ScreenCapturer.instance.capture(imagePath: imagePath);
      await _restoreAppWindow();
      final imageBytes = capturedData?.imageBytes;
      if (imageBytes == null) {
        showErrorSnackbarWithClose(title: 'There was an error while capturing the screen');
        return;
      }
      final missingTeeth = _dialogController.missingTeeth;
      final initialTeeth = _dialogController.showInitialTooth();
      final preview = ToothPreview(
        RoverToothImage(generateMediumRandomString(), imageBytes, now),
        teeth: initialTeeth,
        missingTeeth: missingTeeth,
      );
      _cameraButtonService.openImageCaptureDialog(patient);
      _dialogController.setOrAddToothPreview(preview.id, preview);
      _dialogController.toggleImageSelection(preview.id);
      File(imagePath).deleteSync();
    } on Exception catch (e) {
      await _restoreAppWindow();
      showErrorSnackbarWithClose(title: 'There was an error while capturing the screen', content: e.toString());
    }
  }

  Future<void> _restoreAppWindow() async {
    // BUG FIX: Restore function does not work on MAC OS and instead show() must be used. However using show() on windows
    // will maximize the screen size again.
    await windowManager.restore();
  }
}
