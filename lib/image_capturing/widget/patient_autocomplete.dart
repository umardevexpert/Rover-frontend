import 'package:flutter/material.dart' hide Autocomplete;
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/service/patients_page_controller.dart';
import 'package:ui_kit/input/autocomplete/widget/autocomplete.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

class PatientAutocomplete extends StatelessWidget {
  final Consumer<Patient> onSelected;
  final _patientsPageController = get<PatientsPageController>();

  PatientAutocomplete({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _patientsPageController.allPatientsStream,
      initialData: const <Patient>[],
      builder: (context, allPatients) {
        return Expanded(
          child: Autocomplete<Patient>(
            decoration: InputDecoration(
              hintText: 'Select a patient by typing his name',
            ),
            optionsBuilder: (textEditingValue) => allPatients
                .where((option) => option.fullName.toUpperCase().contains(textEditingValue.text.toUpperCase())),
            onSelected: (selection) => onSelected(selection!),
            displayStringForOption: (patient) => patient.fullName,
          ),
        );
      },
    );
  }
}
