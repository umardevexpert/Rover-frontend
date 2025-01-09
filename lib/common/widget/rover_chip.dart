import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

enum RoverChipColor {
  darkBlue,
  lightBlue,
  golden,
  grey,
  green,
}

class RoverChip extends StatelessWidget {
  final bool showDecorationDot;
  final RoverChipColor color;
  final String label;

  const RoverChip({super.key, this.showDecorationDot = false, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final colorScheme = appTheme?.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: SMALLER_BORDER_RADIUS,
        color: _getBackgroundColor(colorScheme),
      ),
      padding: const EdgeInsets.symmetric(horizontal: SMALLER_UI_GAP, vertical: 5),
      child: DefaultTextStyle(
        style: appTheme?.textTheme.bodyS.copyWith(
              fontWeight: FontWeight.w500,
              color: _getForegroundColor(colorScheme),
            ) ??
            const TextStyle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDecorationDot)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: const Text(
                  '•',
                  textHeightBehavior: TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
                ),
              ),
            Text(
              label,
              textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getBackgroundColor(RoverColorScheme? colorScheme) {
    switch (color) {
      case RoverChipColor.darkBlue:
      case RoverChipColor.lightBlue:
        return colorScheme?.primaryLight;
      case RoverChipColor.golden:
        return colorScheme?.colorScale1;
      case RoverChipColor.grey:
        return colorScheme?.grey200;
      case RoverChipColor.green:
        return colorScheme?.greenLight;
    }
  }

  Color? _getForegroundColor(RoverColorScheme? colorScheme) {
    switch (color) {
      case RoverChipColor.darkBlue:
        return colorScheme?.colorScale4;
      case RoverChipColor.lightBlue:
        return colorScheme?.primary;
      case RoverChipColor.golden:
        return colorScheme?.colorScale0;
      case RoverChipColor.grey:
        return colorScheme?.grey700;
      case RoverChipColor.green:
        return colorScheme?.green;
    }
  }
}
