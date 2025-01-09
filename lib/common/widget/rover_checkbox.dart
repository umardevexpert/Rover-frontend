import 'package:flutter/material.dart';
import 'package:ui_kit/util/assets.dart';

enum RoverCheckboxStyle { small, large, round }

class RoverCheckbox extends StatelessWidget {
  final RoverCheckboxStyle style;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  const RoverCheckbox({
    super.key,
    this.style = RoverCheckboxStyle.small,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => onChanged?.call(!checked),
          borderRadius: BorderRadius.circular(4.0),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: Assets.svgImage(
              checked ? 'checkbox/filled_${style.name}' : 'checkbox/empty_${style.name}',
              width: _isSmall ? 20 : 24,
              height: _isSmall ? 20 : 24,
            ),
          ),
        ),
      ],
    );
  }

  bool get _isSmall => style == RoverCheckboxStyle.small;
}
