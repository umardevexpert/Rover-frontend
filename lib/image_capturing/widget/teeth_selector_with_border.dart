import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/image_capturing/widget/teeth_selector.dart';

//TODO(andy): TEST (was 272)
const _TEETH_SELECTOR_HEIGHT = 240.0;
const _BORDER_RADIUS = 7.0;

class TeethSelectorWithBorder extends StatelessWidget {
  final Set<int> selectedTeeth;
  final Set<int>? missingTeeth;
  final ValueChanged<int> onToothPressed;
  final double scaleRatio;

  TeethSelectorWithBorder({
    super.key,
    required this.selectedTeeth,
    required this.onToothPressed,
    this.missingTeeth,
    this.scaleRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      height: _TEETH_SELECTOR_HEIGHT * scaleRatio,
      decoration: BoxDecoration(
        border: Border.all(color: appTheme?.colorScheme.grey200 ?? Colors.black),
        borderRadius: BorderRadius.circular(_BORDER_RADIUS),
      ),
      child: FittedBox(
        child: TeethSelector(selectedTeeth: selectedTeeth, missingTeeth: missingTeeth, onToothPressed: onToothPressed),
      ),
    );
  }
}
