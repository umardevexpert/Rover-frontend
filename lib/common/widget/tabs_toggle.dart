import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/tab_toggle_button.dart';

class TabsToggle extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onIndexChanged;
  final List<TabDefinition> tabs;

  const TabsToggle({super.key, required this.activeIndex, required this.onIndexChanged, required this.tabs});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: appTheme?.colorScheme.grey300 ?? Colors.black),
        borderRadius: STANDARD_BORDER_RADIUS,
      ),
      padding: EdgeInsets.all(3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs
            .mapIndexed<Widget>(
              (index, tab) => TabToggleButton(
                isSelected: activeIndex == index,
                onPressed: () => onIndexChanged(index),
                tab: tab,
              ),
            )
            .intersperse(const SizedBox(width: 12.0))
            .toList(),
      ),
    );
  }
}
