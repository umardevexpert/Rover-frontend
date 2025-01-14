import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/widget/rover_multiselect_dropdown.dart';
import 'package:rover/image_capturing/service/tooth_image_storage_controller.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:ui_kit/stream/widget/multi_stream_builder2.dart';

class ToothNumberPicker extends StatelessWidget {
  final _patientDetailController = get<PatientDetailPageController>();
  final _imageStorageController = get<ToothImageStorageController>();
  late final availableTeethStream = _imageStorageController.imagesStream.map((event) => event[patientId] ?? []);
  final String patientId;

  ToothNumberPicker({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) { 
    return MultiStreamBuilder2(
      stream1: _patientDetailController.selectedTeethStream,
      stream2: availableTeethStream.map((previews) => previews.expand((element) => element.teeth).toSet()),
      builder: (_, selectedTeeth, availableTeeth) => RoverMultiselectDropdown(
        rowHeight: 42.0,
        labelText: 'Teeth numbers',
        options: availableTeeth.sorted((a, b) => a.compareTo(b)).toSet(),
        selectedOptions: selectedTeeth.intersection(availableTeeth),
        onValueChanged: _patientDetailController.setSelectedTeeth,
        optionTextBuilder: (toothNumber) => toothNumber.toString(),
        valueTextBuilder: (teeth) => _valueTextBuilder(teeth, availableTeeth.isEmpty),
      ),
    );
  }

  String _valueTextBuilder(Set<int> teeth, bool noTeeth) {
    if (noTeeth) {
      return 'No teeth';
    }
    return teeth.isEmpty ? 'All' : teeth.sorted((a, b) => a.compareTo(b)).join(', ');
  }
}
