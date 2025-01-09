import 'package:flutter/material.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

class ValidationErrorTheme extends ThemeExtension<ValidationErrorTheme> {
  final TextStyle? errorLabelTextStyle;

  const ValidationErrorTheme({this.errorLabelTextStyle});

  static ValidationErrorTheme? of(BuildContext context) => ObtainableThemeExtension.of<ValidationErrorTheme>(context);

  @override
  ValidationErrorTheme copyWith({TextStyle? errorTextStyle}) {
    return ValidationErrorTheme(errorLabelTextStyle: errorTextStyle);
  }

  @override
  ThemeExtension<ValidationErrorTheme> lerp(ThemeExtension<ValidationErrorTheme>? other, double t) {
    if (other is! ValidationErrorTheme) {
      return this;
    }

    return ValidationErrorTheme(errorLabelTextStyle: TextStyle.lerp(errorLabelTextStyle, other.errorLabelTextStyle, t));
  }
}
