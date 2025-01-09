import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/large_dialog_template.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/widget/teeth_selector_with_border.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

const _TOOTH_IMAGE_WIDTH = 450.0;
const _TOOTH_IMAGE_ASPECT_RATIO = 1.5;

class EditSelectedTeethDialog extends StatefulWidget {
  final Patient patient;
  final ToothPreview preview;
  final Set<int> otherPreviewsTeethSet;
  const EditSelectedTeethDialog({
    super.key,
    required this.patient,
    required this.preview,
    required this.otherPreviewsTeethSet,
  });

  @override
  State<EditSelectedTeethDialog> createState() => _EditSelectedTeethDialogState();
}

class _EditSelectedTeethDialogState extends State<EditSelectedTeethDialog> {
  final _dialogController = get<ImageCaptureDialogController>();
  final _patientDetailsController = get<PatientDetailPageController>();

  @override
  void initState() {
    super.initState();
    _dialogController.patient = widget.patient;
    _dialogController.resetTeethSelection();
    widget.preview.teeth.forEach((e) => _dialogController.changeToothSelection(e, updateToothPreview: false));
    _dialogController.patient = widget.patient;
    _dialogController.setOrAddToothPreview(widget.preview.id, widget.preview);
    _dialogController.toggleImageSelection(widget.preview.id);
  }

  @override
  void dispose() {
    _dialogController.resetStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder<Set<int>>(
      stream: _dialogController.selectedTeethStream,
      builder: (context, selectedTeeth) {
        return LargeDialogTemplate(
          titleText: 'Select Teeth Numbers',
          buttons: _buildActionButtons(context, selectedTeeth),
          child: SizedBox(
            width: _TOOTH_IMAGE_WIDTH,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToothImage(),
                LARGER_GAP,
                TeethSelectorWithBorder(
                    selectedTeeth: selectedTeeth,
                    missingTeeth: widget.preview.missingTeeth,
                    onToothPressed: (e) => _dialogController.onToothPressed(e, updateToothPreview: false)),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, Set<int> selectedTeeth) {
    return [
      SecondaryButton(
        onPressed: () => _closeDialog(context),
        child: Text('Cancel'),
      ),
      SMALL_GAP,
      PrimaryButton(
        enabled: selectedTeeth.isNotEmpty,
        onPressed: () async {
          _dialogController.updateTeethOfToothPreview(widget.preview, selectedTeeth);
          final savingFailure = await _dialogController.updateToothPreview(widget.preview);
          _patientDetailsController
              .filterSelectedTeethUsingAvailableTeeth(widget.otherPreviewsTeethSet.union(selectedTeeth));
          if (savingFailure != null) {
            showErrorSnackbarWithClose(title: savingFailure.title, content: savingFailure.content);
          } else if (mounted) {
            _closeDialog(context);
          }
        },
        child: Text('Save'),
      ),
    ];
  }

  Widget _buildToothImage() {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RoverCard(
          padding: EdgeInsets.zero,
          width: _TOOTH_IMAGE_WIDTH,
          height: _TOOTH_IMAGE_WIDTH / _TOOTH_IMAGE_ASPECT_RATIO,
          child: ClipRRect(
            borderRadius: BorderRadius.all(STANDARD_CORNER_RADIUS),
            child: Image.memory(widget.preview.image.bytes, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    if (mounted) {
      context.pop();
    }
  }
}
