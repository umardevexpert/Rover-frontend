import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/widget/patient_autocomplete.dart';
import 'package:rover/image_capturing/widget/tooth_image_preview_card.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:ui_kit/stream/widget/multi_stream_builder2.dart';

class ImagePreviews extends StatelessWidget {
  final _dialogController = get<ImageCaptureDialogController>();

  ImagePreviews({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return HandlingStreamBuilder(
        stream: _dialogController.toothPreviewsStream,
        builder: (context, previews) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagesCountAndPatientsName(appTheme, previews),
              STANDARD_GAP,
              Wrap(
                spacing: STANDARD_UI_GAP,
                runSpacing: STANDARD_UI_GAP,
                children: previews.values.toList().reversed.map(_buildToothPreviewCard).toList(),
              )
            ],
          );
        });
  }

  Widget _buildImagesCountAndPatientsName(AppTheme? appTheme, Map<String, ToothPreview> previews) {
    final textStyle = appTheme?.textTheme.bodyXL;
    final textStyleFixedSize = TextStyle(fontFeatures: const [FontFeature.tabularFigures()]);

    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: appTheme?.textTheme.titleXL.copyWith(color: Colors.black),
            children: [
              TextSpan(text: '${previews.length} images', style: textStyleFixedSize),
              TextSpan(text: ' for ', style: textStyle),
              if (_dialogController.patient != null) TextSpan(text: _dialogController.patient!.fullName),
            ],
          ),
        ),
        if (_dialogController.patient == null)
          PatientAutocomplete(onSelected: (selectedPatient) => _dialogController.patient = selectedPatient)
      ],
    );
  }

  Widget _buildToothPreviewCard(ToothPreview preview) {
    final previewId = preview.id;
    return MultiStreamBuilder2<String?, bool>(
      stream1: _dialogController.selectedToothPreviewIDStream,
      stream2: _dialogController.isErrorStream,
      builder: (context, selectedImageID, hasError) {
        final capturedTeeth = _dialogController.getToothPreview(previewId)?.teeth;

        return ToothImagePreviewCard(
          capturedTeeth: capturedTeeth,
          selected: selectedImageID == previewId,
          onSelected: (_) => _dialogController.toggleImageSelection(previewId),
          onDeletePressed: () => _dialogController.removeToothPreview(previewId),
          imageFile: preview.image,
          hasError: hasError && capturedTeeth.isNullOrEmpty,
        );
      },
    );
  }
}
