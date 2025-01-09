import 'package:flutter/material.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/assets.dart';

const _ICON_SIZE = 17.0;
final _unsortedIcon = Assets.svgImage('icon/arrow_up_down', height: _ICON_SIZE, width: _ICON_SIZE);
final _ascendingIcon = Assets.svgImage('icon/arrow_up_down_ascending', height: _ICON_SIZE, width: _ICON_SIZE);
final _descendingIcon = Assets.svgImage('icon/arrow_up_down_descending', height: _ICON_SIZE, width: _ICON_SIZE);

class RoverTableHeaderLabel extends StatelessWidget {
  final String label;
  final VoidCallback? onSortingPressed;
  final TableSortingType? sortingType;

  RoverTableHeaderLabel({
    super.key,
    required this.label,
    this.onSortingPressed,
    this.sortingType,
  }) : assert((sortingType != null) == (onSortingPressed != null));

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return InkWell(
      onTap: onSortingPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: appTheme?.textTheme.titleM.copyWith(
              color: appTheme.colorScheme.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (sortingType != null)
            Padding(
              padding: const EdgeInsets.only(left: SMALL_UI_GAP),
              child: switch (sortingType!) {
                TableSortingType.none => _unsortedIcon,
                TableSortingType.ascending => _ascendingIcon,
                TableSortingType.descending => _descendingIcon,
              },
            )
        ],
      ),
    );
  }
}
