import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/extension/rover_text_theme_extension.dart';
import 'package:ui_kit/util/obtainable_theme_extension.dart';

class AppTheme extends ThemeExtension<AppTheme> {
  final RoverTextTheme textTheme;
  final RoverColorScheme colorScheme;

  const AppTheme({
    required this.textTheme,
    required this.colorScheme,
  });

  static AppTheme? of(BuildContext context) => ObtainableThemeExtension.of<AppTheme>(context);

  @override
  ThemeExtension<AppTheme> copyWith({
    RoverTextTheme? textTheme,
    RoverColorScheme? colorScheme,
  }) {
    return AppTheme(
      textTheme: textTheme ?? this.textTheme,
      colorScheme: colorScheme ?? this.colorScheme,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(covariant ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) {
      return this;
    }
    return AppTheme(
      textTheme: textTheme.lerp(other.textTheme, t),
      colorScheme: colorScheme.lerp(other.colorScheme, t),
    );
  }
}
