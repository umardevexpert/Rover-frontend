import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/set_extension.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_checkbox.dart';
import 'package:rover/common/widget/rover_dropdown.dart';

class RoverMultiselectDropdown<TValue> extends StatelessWidget {
  final double rowHeight;
  final String labelText;
  final Set<TValue> options;
  final Set<TValue> selectedOptions;
  final ValueChanged<Set<TValue>> onValueChanged;
  final Projector<Set<TValue>, String> valueTextBuilder;
  final Projector<TValue, String> optionTextBuilder;
  final int? minVisiblePopupRows;
  final int maxVisiblePopupRows;

  const RoverMultiselectDropdown({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onValueChanged,
    required this.rowHeight,
    required this.labelText,
    required this.valueTextBuilder,
    required this.optionTextBuilder,
    this.minVisiblePopupRows,
    this.maxVisiblePopupRows = 7,
  });

  @override
  Widget build(BuildContext context) {
    return RoverDropdown(
      rowHeight: rowHeight,
      labelText: labelText,
      valueText: valueTextBuilder(selectedOptions),
      options: options,
      minVisiblePopupRows: minVisiblePopupRows,
      maxVisiblePopupRows: maxVisiblePopupRows,
      scrollbarVisible: options.length > maxVisiblePopupRows,
      closeOnOptionSelected: false,
      optionWidgetBuilder: _buildOptionRow,
      onOptionSelected: _onOptionChanged,
    );
  }

  Widget _buildOptionRow(BuildContext context, TValue option) {
    final isChecked = selectedOptions.contains(option);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(2),
          child: RoverCheckbox(checked: isChecked, onChanged: (_) => _onOptionChanged(option)),
        ),
        SMALLER_GAP,
        _buildText(option, context, isChecked),
      ],
    );
  }

  void _onOptionChanged(TValue option) {
    final newSelectedOptions = Set.of(selectedOptions);
    onValueChanged(newSelectedOptions..addOrRemoveIfExists(option));
  }

  Widget _buildText(TValue option, BuildContext context, bool isChecked) {
    return Text(
      optionTextBuilder(option),
      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
      style: AppTheme.of(context)?.textTheme.bodyM.copyWith(
            fontWeight: FontWeight.w500,
            color: isChecked ? null : AppTheme.of(context)?.colorScheme.grey600,
          ),
    );
  }
}
