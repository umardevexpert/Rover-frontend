import 'package:flutter/material.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

@immutable
class AutocompleteFacadeTheme extends ThemeExtension<AutocompleteFacadeTheme> {
  final InputDecorationTheme? inputDecorationTheme;

  const AutocompleteFacadeTheme({this.inputDecorationTheme});
  static AutocompleteFacadeTheme? of(BuildContext context) =>
      ObtainableThemeExtension.of<AutocompleteFacadeTheme>(context);

  @override
  ThemeExtension<AutocompleteFacadeTheme> copyWith({InputDecorationTheme? inputDecorationTheme}) {
    return AutocompleteFacadeTheme(inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme);
  }

  @override
  ThemeExtension<AutocompleteFacadeTheme> lerp(ThemeExtension<AutocompleteFacadeTheme>? other, double t) {
    // TODO: implement lerp
    return (t > 0.5) ? other ?? this : this;
  }
}
