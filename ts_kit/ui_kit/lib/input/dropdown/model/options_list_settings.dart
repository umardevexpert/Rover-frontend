import 'package:flutter/widgets.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class OptionsListSettings<TOption> {
  final Iterable<TOption> options;
  final ValueChanged<TOption>? onSelected;
  final StringBuilder<TOption>? displayStringForOption;
  final WidgetBuilder1<TOption>? optionWidgetBuilder;
  final EdgeInsetsGeometry? paddingForOption;
  final IndexedWidgetBuilder? dividerBuilder;
  final double? rowHeight;
  final bool? scrollbarVisible;
  final int? textWrapMaxLines;
  final Predicate<TOption>? isOptionEnabled;

  OptionsListSettings({
    required this.options,
    this.dividerBuilder,
    this.onSelected,
    this.displayStringForOption,
    this.optionWidgetBuilder,
    this.rowHeight,
    this.scrollbarVisible,
    this.textWrapMaxLines,
    this.isOptionEnabled,
    this.paddingForOption = EdgeInsets.zero,
  }) : assert(rowHeight == null || rowHeight >= 0);

  OptionsListSettings<TOption> copyWith({
    Iterable<TOption>? options,
    ValueChanged<TOption>? onSelected,
    StringBuilder<TOption>? displayStringForOption,
    WidgetBuilder1<TOption>? optionWidgetBuilder,
    IndexedWidgetBuilder? dividerBuilder,
    Predicate<TOption>? isOptionEnabled,
    double? rowHeight,
    bool? scrollbarVisible,
    int? textWrapMaxLines,
    EdgeInsets? paddingForOption,
  }) {
    return OptionsListSettings(
      options: options ?? this.options,
      onSelected: onSelected ?? this.onSelected,
      displayStringForOption: displayStringForOption ?? this.displayStringForOption,
      optionWidgetBuilder: optionWidgetBuilder ?? this.optionWidgetBuilder,
      dividerBuilder: dividerBuilder ?? this.dividerBuilder,
      rowHeight: rowHeight ?? this.rowHeight,
      scrollbarVisible: scrollbarVisible ?? this.scrollbarVisible,
      textWrapMaxLines: textWrapMaxLines ?? this.textWrapMaxLines,
      isOptionEnabled: isOptionEnabled ?? this.isOptionEnabled,
      paddingForOption: paddingForOption ?? this.paddingForOption,
    );
  }
}
