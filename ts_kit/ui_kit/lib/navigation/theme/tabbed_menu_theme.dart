import 'package:flutter/material.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

@immutable
class TabbedMenuTheme extends ThemeExtension<TabbedMenuTheme> {
  final Decoration? indicatorDecoration;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? tabBarPadding;
  final EdgeInsetsGeometry? tabBarItemPadding;
  final TextStyle? labelStyle;

  const TabbedMenuTheme({
    this.indicatorDecoration,
    this.foregroundColor,
    this.tabBarPadding,
    this.tabBarItemPadding,
    this.labelStyle,
  });

  static TabbedMenuTheme? of(BuildContext context) => ObtainableThemeExtension.of<TabbedMenuTheme>(context);

  @override
  TabbedMenuTheme copyWith({
    Decoration? indicatorDecoration,
    Color? foregroundColor,
    EdgeInsetsGeometry? tabBarPadding,
    EdgeInsetsGeometry? tabBarItemPadding,
    TextStyle? labelStyle,
  }) {
    return TabbedMenuTheme(
      indicatorDecoration: indicatorDecoration ?? this.indicatorDecoration,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      tabBarPadding: tabBarPadding ?? this.tabBarPadding,
      tabBarItemPadding: tabBarItemPadding ?? this.tabBarItemPadding,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  @override
  ThemeExtension<TabbedMenuTheme> lerp(ThemeExtension<TabbedMenuTheme>? other, double t) {
    if (other is! TabbedMenuTheme) {
      return this;
    }

    return TabbedMenuTheme(
      indicatorDecoration: Decoration.lerp(indicatorDecoration, other.indicatorDecoration, t) ?? indicatorDecoration,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t) ?? foregroundColor,
      tabBarPadding: EdgeInsetsGeometry.lerp(tabBarPadding, other.tabBarPadding, t) ?? tabBarPadding,
      tabBarItemPadding: EdgeInsetsGeometry.lerp(tabBarItemPadding, other.tabBarItemPadding, t) ?? tabBarItemPadding,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t) ?? labelStyle,
    );
  }
}
