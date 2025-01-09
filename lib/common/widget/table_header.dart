import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class TableHeader extends StatelessWidget {
  final List<Widget> columnLabels;

  const TableHeader({super.key, required this.columnLabels});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return DefaultTextStyle(
      style: appTheme?.textTheme.titleM.copyWith(
            color: appTheme.colorScheme.grey600,
            fontWeight: FontWeight.w500,
          ) ??
          TextStyle(),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: appTheme?.colorScheme.grey100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
            ),
            child: Row(children: columnLabels),
          ),
          Divider(height: 0, thickness: 1, color: appTheme?.colorScheme.grey200),
        ],
      ),
    );
  }
}
