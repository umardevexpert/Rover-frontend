import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class SettingsRow extends StatelessWidget {
  final Widget? left;
  final Widget? right;

  const SettingsRow({super.key, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (left != null) Expanded(child: left!) else const Spacer(),
        SMALL_GAP,
        if (right != null) Expanded(child: right!) else const Spacer(),
      ],
    );
  }
}
