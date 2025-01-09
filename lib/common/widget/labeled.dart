import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class Labeled extends StatelessWidget {
  final String label;
  final Widget child;

  const Labeled({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        SMALL_GAP,
        child,
      ],
    );
  }
}
