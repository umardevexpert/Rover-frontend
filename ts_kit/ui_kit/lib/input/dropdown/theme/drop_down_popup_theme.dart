import 'package:flutter/material.dart';
import 'package:ui_kit/theme/material3_compliant_color_scheme_extension.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

const _EXTRA_SMALL_CIRCULAR_BORDER = BorderRadius.all(Radius.circular(4.0));
const _SMALLER_UI_GAP = 8.0;
const _LEVEL_2_ELEVATION = 3.0;

@immutable
class DropDownPopupTheme extends ThemeExtension<DropDownPopupTheme> {
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final double? rowHeight;
  final double? popupToElementGap;
  final EdgeInsetsGeometry? paddingForOption;
  final Color? backgroundColor;

  const DropDownPopupTheme({
    this.border,
    this.borderRadius,
    this.elevation,
    this.rowHeight,
    this.popupToElementGap,
    this.backgroundColor,
    this.paddingForOption,
  });

  static DropDownPopupTheme? of(BuildContext context) => ObtainableThemeExtension.of<DropDownPopupTheme>(context);

  factory DropDownPopupTheme.fromColorScheme({
    required ColorScheme colorScheme,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    double? rowHeight,
    double? popupToElementGap,
    Color? backgroundColor,
    EdgeInsets? paddingForOption,
  }) {
    return DropDownPopupTheme(
      border: border,
      borderRadius: borderRadius ?? _EXTRA_SMALL_CIRCULAR_BORDER,
      elevation: elevation ?? _LEVEL_2_ELEVATION,
      rowHeight: rowHeight,
      popupToElementGap: popupToElementGap,
      backgroundColor: backgroundColor ?? colorScheme.surfaceContainer,
      paddingForOption: paddingForOption ?? const EdgeInsets.symmetric(vertical: _SMALLER_UI_GAP),
    );
  }

  @override
  DropDownPopupTheme copyWith({
    Border? border,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    double? rowHeight,
    double? popupToElementGap,
    Color? backgroundColor,
  }) {
    return DropDownPopupTheme(
      border: border ?? this.border,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      rowHeight: rowHeight ?? this.rowHeight,
      popupToElementGap: popupToElementGap ?? this.popupToElementGap,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  ThemeExtension<DropDownPopupTheme> lerp(ThemeExtension<DropDownPopupTheme>? other, double t) {
    // TODO: implement lerp
    return (t > 0.5) ? other ?? this : this;
  }
}
