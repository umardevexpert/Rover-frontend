import 'package:flutter/material.dart';
import 'package:rover/common/widget/rover_multiselect_dropdown.dart';
import 'package:rover/patient/model/age_range.dart';

final _AGE_RANGES = {
  AgeRange(toAge: 18),
  AgeRange(fromAge: 18, toAge: 24),
  AgeRange(fromAge: 25, toAge: 44),
  AgeRange(fromAge: 45, toAge: 64),
  AgeRange(fromAge: 65),
};

class AgeRangePicker extends StatefulWidget {
  final ValueChanged<Set<AgeRange>> onAgeRangeChanged;

  const AgeRangePicker({super.key, required this.onAgeRangeChanged});

  @override
  State<AgeRangePicker> createState() => _AgeRangePickerState();
}

class _AgeRangePickerState extends State<AgeRangePicker> {
  var _selectedAgeRanges = <AgeRange>{};

  @override
  Widget build(BuildContext context) {
    return RoverMultiselectDropdown(
      rowHeight: 42.0,
      labelText: 'Age range',
      options: _AGE_RANGES,
      selectedOptions: _selectedAgeRanges,
      onValueChanged: onValueChanged,
      optionTextBuilder: _getAgeRangeText,
      valueTextBuilder: (ranges) => ranges.map(_getAgeRangeText).join(', '),
    );
  }

  void onValueChanged(Set<AgeRange> ranges) {
    setState(() => _selectedAgeRanges = ranges);
    widget.onAgeRangeChanged(ranges);
  }

  String _getAgeRangeText(AgeRange ageRange) {
    if (ageRange.fromAge == null) {
      return '< ${ageRange.toAge}';
    } else if (ageRange.toAge == null) {
      return '${ageRange.fromAge}+';
    }
    return '${ageRange.fromAge}-${ageRange.toAge}';
  }
}
