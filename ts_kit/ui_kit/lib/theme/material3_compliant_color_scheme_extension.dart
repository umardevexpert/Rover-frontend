import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';
import 'package:ui_kit/sdk_extension/color_extension.dart';
import 'package:ui_kit/theme/material3_compliant_color_scheme.dart';

extension Material3CompliantColorSchemeExtension on ColorScheme {
  Material3CompliantColorScheme? get _castedColorScheme => maybeCast<Material3CompliantColorScheme>();
  bool get _isLightTheme => brightness == Brightness.light;

  Color get primaryFixed => primary.withTone(90);
  Color get primaryFixedVariant => primary.withTone(80);
  Color get onPrimaryFixed => primary.withTone(10);
  Color get onPrimaryFixedVariant => primary.withTone(30);

  Color get secondaryFixed => secondary.withTone(90);
  Color get secondaryFixedVariant => secondary.withTone(80);
  Color get onSecondaryFixed => secondary.withTone(10);
  Color get onSecondaryFixedVariant => secondary.withTone(30);

  Color get tertiaryFixed => tertiary.withTone(90);
  Color get tertiaryFixedVariant => tertiary.withTone(80);
  Color get onTertiaryFixed => tertiary.withTone(10);
  Color get onTertiaryFixedVariant => tertiary.withTone(30);

  Color get surfaceBright => _castedColorScheme?.surfaceBright ?? _surfaceBright;
  Color get surfaceContainerLowest => _castedColorScheme?.surfaceContainerLowest ?? _surfaceContainerLowest;
  Color get surfaceContainerLow => _castedColorScheme?.surfaceContainerLow ?? _surfaceContainerLow;
  Color get surfaceContainer => _castedColorScheme?.surfaceContainer ?? _surfaceContainer;
  Color get surfaceContainerHigh => _castedColorScheme?.surfaceContainerHigh ?? _surfaceContainerHigh;
  Color get surfaceContainerHighest => _castedColorScheme?.surfaceContainerHighest ?? _surfaceContainerHighest;

  Color get _surfaceBright => _isLightTheme ? surface.withTone(98) : surface.withTone(24);
  Color get _surfaceContainerLowest => _isLightTheme ? surface.withTone(100) : surface.withTone(4);
  Color get _surfaceContainerLow => _isLightTheme ? surface.withTone(96) : surface.withTone(10);
  Color get _surfaceContainer => _isLightTheme ? surface.withTone(94) : surface.withTone(12);
  Color get _surfaceContainerHigh => _isLightTheme ? surface.withTone(92) : surface.withTone(17);
  Color get _surfaceContainerHighest => _isLightTheme ? surface.withTone(90) : surface.withTone(22);

  // aliases
  Color get primaryFixedDim => primaryFixedVariant;
  Color get secondaryFixedDim => secondaryFixedVariant;
  Color get tertiaryFixedDim => tertiaryFixedVariant;
  Color get surfaceDim => surfaceVariant;
}
