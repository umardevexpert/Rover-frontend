import 'package:flutter/material.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

const _HEIGHT = 56.0;
const _EXTRA_SMALL_CIRCULAR_BORDER = BorderRadius.all(Radius.circular(4.0));
const _SMALL_UI_GAP = 16.0;
const _SMALLER_UI_GAP = 8.0;

@immutable
class DropDownFacadeTheme extends ThemeExtension<DropDownFacadeTheme> {
  final BoxBorder? border;
  final BoxBorder? activeBorder;
  final BoxBorder? errorBorder;
  final BorderRadiusGeometry? borderRadius;
  final double? height;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? arrowColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorLabelTextStyle;

  const DropDownFacadeTheme({
    this.border,
    BoxBorder? activeBorder,
    BoxBorder? errorBorder,
    this.borderRadius,
    this.height,
    this.padding,
    this.backgroundColor,
    this.arrowColor,
    this.textStyle,
    this.hintStyle,
    this.errorLabelTextStyle,
  })  : activeBorder = activeBorder ?? border,
        errorBorder = errorBorder ?? border;

  static DropDownFacadeTheme? of(BuildContext context) => ObtainableThemeExtension.of<DropDownFacadeTheme>(context);

  factory DropDownFacadeTheme.fromColorScheme({
    required ColorScheme colorScheme,
    Border? border,
    Border? activeBorder,
    BoxBorder? errorBorder,
    BorderRadiusGeometry? borderRadius,
    double? height,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? arrowColor,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorLabelTextStyle,
  }) {
    return DropDownFacadeTheme(
      border: border ?? Border.all(color: colorScheme.outline),
      activeBorder: activeBorder ?? Border.all(width: 1, color: colorScheme.primary),
      errorBorder: errorBorder ?? Border.all(width: 1, color: colorScheme.error),
      borderRadius: borderRadius ?? _EXTRA_SMALL_CIRCULAR_BORDER,
      height: height ?? _HEIGHT,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: _SMALL_UI_GAP, vertical: _SMALLER_UI_GAP),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      arrowColor: arrowColor,
      textStyle: textStyle,
      hintStyle: hintStyle,
      errorLabelTextStyle: errorLabelTextStyle,
    );
  }

  @override
  DropDownFacadeTheme copyWith({
    Border? border,
    Border? activeBorder,
    BoxBorder? errorBorder,
    BorderRadiusGeometry? borderRadius,
    double? height,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? arrowColor,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorLabelTextStyle,
  }) {
    return DropDownFacadeTheme(
      border: border ?? this.border,
      activeBorder: activeBorder ?? this.activeBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      borderRadius: borderRadius ?? this.borderRadius,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      arrowColor: arrowColor ?? this.arrowColor,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorLabelTextStyle: errorLabelTextStyle ?? this.errorLabelTextStyle,
    );
  }

  @override
  ThemeExtension<DropDownFacadeTheme> lerp(ThemeExtension<DropDownFacadeTheme>? other, double t) {
    // TODO: implement lerp
    return (t > 0.5) ? other ?? this : this;
  }
}
