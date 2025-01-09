import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/treatment_plan.dart';
import 'package:rover/patient/widget/connection_failed_body.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/patient_detail/widget/treatments_table.dart';
import 'package:rxdart/streams.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down.dart';
import 'package:ui_kit/util/assets.dart';

class TreatmentsSection extends StatefulWidget {
  final Patient patient;

  TreatmentsSection({super.key, required this.patient});

  @override
  State<TreatmentsSection> createState() => _TreatmentsSectionState();
}

class _TreatmentsSectionState extends State<TreatmentsSection> {
  final _patientDetailsController = get<PatientDetailPageController>();
  final _imageStoringController = get<ToothImageStorageController>();

  TreatmentPlan? _selectedTreatmentPlan;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: LARGER_UI_GAP),
      child: RoverCard(
        padding: const EdgeInsets.all(STANDARD_UI_GAP),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildTitleAndSubtitle(appTheme),
                const Expanded(child: LARGER_GAP),
                _buildDropdown(),
              ],
            ),
            _buildTable(appTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(AppTheme? appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Treatments',
          style: appTheme?.textTheme.bodyXL.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Select one or more for which you want to create a presentation',
          style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 502),
      child: StreamBuilder(
        stream: _patientDetailsController.treatmentPlansStream,
        builder: (_, plans) {
          if (plans.hasError && !_hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hasError = true));
          } else if (!plans.hasError && _hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _hasError = false));
          }
          // TODO(matej): create a better dropdown menu with label and mouse cursor on hover - as in Figma
          return DropDown<TreatmentPlan?>(
            placeholder: plans.hasError
                ? 'Connection error'
                : (plans.data != null && plans.data!.isEmpty)
                    ? 'No treatment plans'
                    : 'Treatment plan',
            value: _selectedTreatmentPlan,
            options: plans.hasError ? [] : plans.data ?? [null],
            displayStringForOption: (tp) => tp?.name ?? 'Unnamed treatment plan',
            optionWidgetBuilder: (_, plan) => plan == null
                ? Center(child: SizedBox.square(dimension: 30, child: const CircularProgressIndicator()))
                : Text(plan.name),
            onChanged: (value) {
              if (value == _selectedTreatmentPlan) {
                return;
              }
              setState(() => _selectedTreatmentPlan = value);
              _patientDetailsController.setTreatmentPlanId(_selectedTreatmentPlan!.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildTable(AppTheme? appTheme) {
    return StreamBuilder(
      stream: CombineLatestStream.combine2(
          _patientDetailsController.treatmentsStream,
          _imageStoringController.imagesStream.map((imagesPerPatientId) => imagesPerPatientId[widget.patient.id] ?? []),
          (treatments, teethImages) => (treatments, teethImages)),
      builder: (_, treatmentsAndTeeth) {
        if (treatmentsAndTeeth.hasError || _hasError) {
          return Flexible(child: ConnectionFailedBody());
        }
        if (_selectedTreatmentPlan == null) {
          return _buildEmptyTreatments(appTheme);
        }
        final (treatments, teethPreview) = treatmentsAndTeeth.data ?? (null, null);
        return TreatmentsTable(treatments: treatments, teethPreview: teethPreview);
      },
    );
  }

  Widget _buildEmptyTreatments(AppTheme? appTheme) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.svgImage('no_documents', width: 232, height: 152),
            const SizedBox(height: 20),
            Text(
              'You have not chosen any treatment plan',
              style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
            ),
          ],
        ),
      ),
    );
  }
}
