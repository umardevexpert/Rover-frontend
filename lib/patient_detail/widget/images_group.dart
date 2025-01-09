import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/image_capturing/widget/tooth_image_preview_card.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/patient_detail/widget/edit_selected_teeth_dialog.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ImagesGroup extends StatelessWidget {
  final _imageStorageController = get<ToothImageStorageController>();
  final _patientDetailsController = get<PatientDetailPageController>();

  final String groupTitle;
  final Patient patient;
  final List<ToothPreview> previews;

  ImagesGroup({super.key, required this.previews, required this.groupTitle, required this.patient});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            width: double.infinity,
            color: appTheme?.colorScheme.grey100,
            padding: const EdgeInsets.only(bottom: SMALL_UI_GAP),
            child: Text(groupTitle, style: appTheme?.textTheme.titleL),
          ),
        ),
        SliverToBoxAdapter(
          child: Wrap(
            spacing: STANDARD_UI_GAP,
            runSpacing: STANDARD_UI_GAP,
            children: previews
                .map(
                  (preview) => ToothImagePreviewCard(
                    selected: false,
                    cardWidth: 306,
                    capturedTeeth: preview.teeth,
                    imageFile: preview.image,
                    date: DateTime.now(),
                    onSelected: (_) => _openEditSelectedTeethDialog(context, preview),
                    onDeletePressed: () => _removeToothPreview(preview),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _removeToothPreview(ToothPreview preview) {
    _imageStorageController.removeImage(patient.id, preview.id);
    if (previews.length == 1) {
      _patientDetailsController.setSelectedTeeth({});
    }
  }

  void _openEditSelectedTeethDialog(BuildContext context, ToothPreview toothPreview) {
    final otherPreviewsTeethSet =
        previews.where((element) => element.id != toothPreview.id).expand((element) => element.teeth).toSet();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: EditSelectedTeethDialog(
            preview: toothPreview,
            patient: patient,
            otherPreviewsTeethSet: otherPreviewsTeethSet,
          ),
        );
      },
    );
  }
}
