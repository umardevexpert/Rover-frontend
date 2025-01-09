part of 'package:ui_kit/input/compliant_text_field/widget/material_specification_compliant_text_field.dart';

InputBorder _getMaterial3CompliantBorder({required ThemeData theme, required bool isOutlined, required bool hasError}) {
  final resolver = isOutlined
      ? MaterialStateOutlineInputBorderWithError.resolveWith
      : MaterialStateUnderlinedInputBorderWithError.resolveWith;

  return resolver.call(
    (states) {
      final material3BorderSide = BorderSide(
        color: _getColorFromStates(states, theme.colorScheme, enabledColor: theme.colorScheme.outline),
        width: states.contains(MaterialState.focused) ? 2 : 1,
      );

      return isOutlined
          ? OutlineInputBorder(borderSide: material3BorderSide)
          : UnderlineInputBorder(borderSide: material3BorderSide);
    },
    hasError: hasError,
  );
}

TextStyle _getMaterial3CompliantTextStyle({required ThemeData theme, required bool hasError}) {
  return MaterialStateTextStyleWithError.resolveWith(
    (states) => TextStyle(color: _getColorFromStates(states, theme.colorScheme)),
    hasError: hasError,
  );
}

Color _getMaterial3CompliantColor({required ThemeData theme, required bool hasError}) {
  return MaterialStateColorWithError.resolveWith(
    (states) => _getColorFromStates(states, theme.colorScheme),
    hasError: hasError,
  );
}

Color _getColorFromStates(Set<MaterialState> states, ColorScheme colorScheme, {Color? enabledColor}) {
  if (states.contains(MaterialState.error)) {
    return colorScheme.error;
  }

  if (states.isEmpty) {
    return enabledColor ?? colorScheme.onSurfaceVariant;
  }

  if (states.contains(MaterialState.focused)) {
    return colorScheme.primary;
  }

  return colorScheme.onSurface;
}
