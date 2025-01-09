import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/navigation/model/navigation_tab_definition.dart';
import 'package:rover/navigation/widget/navigation_tab_button.dart';

class NavigationTabs extends StatelessWidget {
  final List<NavigationTabDefinition> tabs;

  const NavigationTabs({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: tabs.map<Widget>((tab) => NavigationTabButton(tab: tab)).intersperse(STANDARD_GAP).toList(),
    );
  }
}
