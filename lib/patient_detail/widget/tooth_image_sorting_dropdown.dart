import 'package:flutter/material.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/rover_dropdown.dart';
import 'package:rover/patient_detail/controller/patient_detail_page_controller.dart';
import 'package:rover/patient_detail/model/tooth_image_sort_type.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';

class ToothImageSortingDropdown extends StatelessWidget {
  final PatientDetailPageController patientDetailController = get<PatientDetailPageController>();

  ToothImageSortingDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder(
      stream: patientDetailController.imageSortType,
      builder: (_, sortType) => RoverDropdown(
        labelText: 'Sort by',
        rowHeight: 40,
        options: ToothImageSortType.values,
        valueText: _sortTypeToString(sortType),
        optionWidgetBuilder: _buildRow,
        onOptionSelected: patientDetailController.setImageSortType,
      ),
    );
  }

  Widget _buildRow(BuildContext context, ToothImageSortType sortType) {
    return Text(
      _sortTypeToString(sortType),
      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
      style: AppTheme.of(context)?.textTheme.bodyM,
    );
  }

  String _sortTypeToString(ToothImageSortType sortType) {
    return switch (sortType) {
      ToothImageSortType.imageNewToOld => 'From new to old',
      ToothImageSortType.imageOldToNew => 'From old to new',
      ToothImageSortType.toothNumberAscending => 'From first tooth to last',
      ToothImageSortType.toothNumberDescending => 'From last tooth to first',
    };
  }
}
