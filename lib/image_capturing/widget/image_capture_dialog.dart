import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/large_dialog_template.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/service/intra_oral_camera_button_press_service.dart';
import 'package:rover/image_capturing/widget/camera_preview_window.dart';
import 'package:rover/image_capturing/widget/capturing_photos_hint.dart';
import 'package:rover/image_capturing/widget/image_previews.dart';
import 'package:rover/image_capturing/widget/intra_oral_camera_options_dropdown.dart';
import 'package:rover/image_capturing/widget/teeth_selector_section.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

const _HEIGHT_BREAKPOINT = 740;

class ImageCaptureDialog extends StatelessWidget {
  final _dialogController = get<ImageCaptureDialogController>();
  final _cameraButtonService = get<IntraOralCameraButtonPressService>();

  ImageCaptureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return LargeDialogTemplate(
      titleText: 'Capture Images',
      child: _buildBody(appTheme),
      buttons: _buildActionButtons(),
    );
  }

  Widget _buildBody(AppTheme? appTheme) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: _handleArrowInput,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: LARGER_UI_GAP,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          var scaleRatio = 1.0;

          if (constraints.maxHeight < _HEIGHT_BREAKPOINT) {
            scaleRatio = (constraints.maxHeight - LARGE_UI_GAP - SMALL_UI_GAP) / _HEIGHT_BREAKPOINT;
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreviewAndToothSelector(appTheme, scaleRatio),
              const SizedBox(width: 80),
              _buildCameraDropdownAndPreviews(appTheme),
            ],
          );
        }),
      ),
    );
  }

  SizedBox _buildPreviewAndToothSelector(AppTheme? appTheme, double scaleRatio) {
    return SizedBox(
      width: 546 * scaleRatio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CameraPreviewWindow(scaleRatio: scaleRatio),
          LARGE_GAP,
          TeethSelectorSection(scaleRatio: scaleRatio),
        ],
      ),
    );
  }

  Expanded _buildCameraDropdownAndPreviews(AppTheme? appTheme) {
    return Expanded(
      child: SingleChildScrollView(
        child: HandlingStreamBuilder<bool>(
          stream: _dialogController.showHintStream,
          builder: (context, showHint) {
            return Padding(
              padding: const EdgeInsets.only(
                right: SMALL_UI_GAP,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHint) CapturingPhotosHint(onClose: _dialogController.closeHint),
                  IntraOralCameraOptionsDropdown(),
                  SMALL_GAP,
                  ImagePreviews(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    return [
      PrimaryButton(
        onPressed: () async {
          final savingFailure = await _dialogController.saveToothPreviews();
          if (savingFailure == null) {
            _cameraButtonService.closeImageCaptureDialog();
          } else {
            showErrorSnackbarWithClose(title: savingFailure.title, content: savingFailure.content);
          }
        },
        child: Text('Done'),
      )
    ];
  }

  void _handleArrowInput(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _dialogController.selectPreviousTeethBlock();
      }

      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _dialogController.selectNextTeethBlock();
      }
    }
  }
}
