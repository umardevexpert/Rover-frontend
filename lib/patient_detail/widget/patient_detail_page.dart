import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/page_template.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/common/widget/tabs_toggle.dart';
import 'package:rover/image_capturing/widget/camera_listener_wrapper.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/patient_detail/model/presentation.dart';
import 'package:rover/patient_detail/widget/images_section.dart';
import 'package:rover/patient_detail/widget/images_toolbar.dart';
import 'package:rover/patient_detail/widget/next_appointment_card.dart';
import 'package:rover/patient_detail/widget/patient_info.dart';
import 'package:rover/patient_detail/widget/presentations_section.dart';
import 'package:rover/patient_detail/widget/treatments_section.dart';
import 'package:ui_kit/util/assets.dart';

class PatientDetailPage extends StatefulWidget {
  final Patient patient;

  PatientDetailPage({super.key, required this.patient});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final _patientDetailController = get<PatientDetailPageController>();
  var _selectedTabIndex = 0;
  var _refreshing = false;
  final _presentations = <Presentation>[];

  @override
  void initState() {
    super.initState();
    _patientDetailController.setPatientId(widget.patient.id);
  }

  @override
  Widget build(BuildContext context) {
    return CameraListenerWrapper(
      patient: widget.patient,
      child: PageTemplate(
        hasBackButton: true,
        backButtonText: 'Back to Patients',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInformationHeader(),
            STANDARD_GAP,
            Flexible(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: _buildBody())),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationHeader() {
    return RoverCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PatientInfo(patient: widget.patient),
              const Spacer(),
              NextAppointmentCard(date: DateTime.now()), // TODO(matej): insert next appointment date
            ],
          ),
          LARGER_GAP,
          _buildTabsAndButtons(),
          if (_selectedTabIndex == 2) ...[
            Divider(height: 48),
            ImagesToolbar(patient: widget.patient),
          ],
        ],
      ),
    );
  }

  Widget _buildTabsAndButtons() {
    return Row(
      children: [
        _buildTabsToggle(),
        Spacer(),
        SecondaryButton(
          onPressed: _refreshData,
          enabled: !_refreshing,
          prefixIcon: _refreshing
              ? const SizedBox.square(dimension: 15, child: CircularProgressIndicator(strokeWidth: 3))
              : null,
          size: SecondaryButtonSize.large,
          child: Text('Refresh'),
        ),
        SizedBox(width: SMALL_UI_GAP),
        PrimaryButton(
          onPressed: () => setState(() => _presentations.add(Presentation.demo())),
          size: PrimaryButtonSize.large,
          child: Text('Create Presentation'),
        ),
      ],
    );
  }

  Widget _buildTabsToggle() {
    return TabsToggle(
      activeIndex: _selectedTabIndex,
      onIndexChanged: (index) => setState(() => _selectedTabIndex = index),
      tabs: [
        TabDefinition(
          label: 'Treatment plans',
          icon: Assets.svgImage('icon/treatments_tab'),
        ),
        TabDefinition(
          label: 'Presentations',
          icon: Assets.svgImage('icon/presentations_tab'),
        ),
        TabDefinition(label: 'Images', icon: Assets.svgImage('icon/image')),
      ],
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _selectedTabIndex,
      children: [
        TreatmentsSection(patient: widget.patient),
        PresentationsSection(presentations: _presentations),
        ImagesSection(patient: widget.patient),
      ],
    );
  }

  Future<void> _refreshData() async {
    setState(() => _refreshing = true);
    await _patientDetailController.refreshPatientDetails();
    await Future<void>.delayed(const Duration(seconds: 1)); // TODO(matej): keep this delay?
    setState(() => _refreshing = false);
  }
}
