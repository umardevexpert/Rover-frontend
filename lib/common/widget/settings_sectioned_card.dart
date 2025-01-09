import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_card.dart';

class SettingsSectionedCard extends StatelessWidget {
  final List<Widget> sections;

  const SettingsSectionedCard({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return RoverCard(
      padding: const EdgeInsets.symmetric(horizontal: LARGE_UI_GAP, vertical: STANDARD_UI_GAP),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: sections.intersperse(const Divider(height: 64)).toList(),
      ),
    );
  }
}
