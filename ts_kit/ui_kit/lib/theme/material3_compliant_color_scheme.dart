import 'package:flutter/material.dart';

class Material3CompliantColorScheme extends ColorScheme {
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedVariant;
  final Color onPrimaryFixedVariant;

  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedVariant;
  final Color onSecondaryFixedVariant;

  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedVariant;
  final Color onTertiaryFixedVariant;

  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  Material3CompliantColorScheme({
    required super.brightness,
    required super.primary,
    required super.onPrimary,
    super.primaryContainer,
    super.onPrimaryContainer,
    required super.secondary,
    required super.onSecondary,
    super.secondaryContainer,
    super.onSecondaryContainer,
    super.tertiary,
    super.onTertiary,
    super.tertiaryContainer,
    super.onTertiaryContainer,
    required super.error,
    required super.onError,
    super.errorContainer,
    super.onErrorContainer,
    required super.background,
    required super.onBackground,
    required super.surface,
    required super.onSurface,
    super.surfaceVariant,
    super.onSurfaceVariant,
    super.outline,
    super.outlineVariant,
    super.shadow,
    super.scrim,
    super.inverseSurface,
    super.onInverseSurface,
    super.inversePrimary,
    super.surfaceTint,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedVariant,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedVariant,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedVariant,
    required this.onTertiaryFixedVariant,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });
}
