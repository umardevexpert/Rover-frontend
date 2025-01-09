import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/dropdown/widget/options_list.dart';

const _MATERIAL_DEFAULT_ROW_HEIGHT = 50.0;

class OptionsPopup<TOption> extends StatelessWidget {
  final int? minVisibleRows;
  final int? maxVisibleRows;
  final OptionsListSettings<TOption> listSettings;
  final DropDownPopupTheme? popupTheme;

  double get minHeight => min(minVisibleRows ?? 0, listSettings.options.length) * _rowHeight;

  double get height {
    if (maxVisibleRows != null && maxVisibleRows! < listSettings.options.length) {
      return maxVisibleRows! * _rowHeight;
    }
    return (listSettings.options.length) * _rowHeight;
  }

  double get _rowHeight => listSettings.rowHeight ?? _MATERIAL_DEFAULT_ROW_HEIGHT;

  const OptionsPopup({
    super.key,
    required this.listSettings,
    this.minVisibleRows,
    this.maxVisibleRows,
    this.popupTheme,
  })  : assert(minVisibleRows == null || minVisibleRows >= 0),
        assert(maxVisibleRows == null || maxVisibleRows >= 1),
        assert(minVisibleRows == null || maxVisibleRows == null || maxVisibleRows >= minVisibleRows);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dropDownTheme = popupTheme ?? DropDownPopupTheme.of(context);

    return PhysicalModel(
      color: Colors.transparent,
      elevation: dropDownTheme?.elevation ?? 0,
      child: Container(
        decoration: BoxDecoration(
          border: dropDownTheme?.border,
          borderRadius: dropDownTheme?.borderRadius,
          color: dropDownTheme?.backgroundColor ?? theme.scaffoldBackgroundColor,
        ),
        constraints: _computeConstrains(),
        child: Material(
          borderRadius: dropDownTheme?.borderRadius,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: OptionsList<TOption>(settings: listSettings),
        ),
      ),
    );
  }

  BoxConstraints _computeConstrains() {
    return BoxConstraints(
      minHeight: minHeight,
      maxHeight: maxVisibleRows == null ? double.infinity : maxVisibleRows! * _rowHeight,
    );
  }
}
