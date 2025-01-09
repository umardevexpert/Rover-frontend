part of 'package:ui_kit/input/compliant_text_field/widget/material_specification_compliant_text_field.dart';

InputBorder? _getBorder({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  return _getErrorBorder(
        suppliedDecoration: suppliedDecoration,
        themeDecoration: themeDecoration,
        hasError: hasError,
        errorTheme: errorTheme,
      ) ??
      _getDefaultBorder(suppliedDecoration: suppliedDecoration, themeDecoration: themeDecoration);
}

InputBorder? _getEnabledBorder({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  final border = suppliedDecoration?.enabledBorder ?? themeDecoration?.enabledBorder;

  return _getErrorBorder(
        suppliedDecoration: suppliedDecoration,
        themeDecoration: themeDecoration,
        hasError: hasError,
        errorTheme: errorTheme,
      ) ??
      border ??
      _getDefaultBorder(suppliedDecoration: suppliedDecoration, themeDecoration: themeDecoration);
}

InputBorder? _getFocusedBorder({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  final border = suppliedDecoration?.focusedBorder ?? themeDecoration?.focusedBorder;
  final errorBorder = hasError
      ? suppliedDecoration?.focusedErrorBorder ?? errorTheme?.focusedBorder ?? themeDecoration?.focusedErrorBorder
      : null;

  return errorBorder ??
      _getErrorBorder(
        suppliedDecoration: suppliedDecoration,
        themeDecoration: themeDecoration,
        hasError: hasError,
        errorTheme: errorTheme,
      ) ??
      border ??
      _getDefaultBorder(suppliedDecoration: suppliedDecoration, themeDecoration: themeDecoration);
}

TextStyle? _getLabelStyle({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  return _getErrorLabelStyle(
    errorLabelStyle: errorTheme?.labelStyle,
    suppliedLabelStyle: suppliedDecoration?.labelStyle,
    themeLabelStyle: themeDecoration?.labelStyle,
    errorColor: errorTheme?.labelColor,
    hasError: hasError,
  );
}

TextStyle? _getFloatingLabelStyle({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  return _getErrorLabelStyle(
    errorLabelStyle: errorTheme?.floatingLabelStyle,
    suppliedLabelStyle: suppliedDecoration?.floatingLabelStyle,
    themeLabelStyle: themeDecoration?.floatingLabelStyle,
    errorColor: errorTheme?.labelColor,
    hasError: hasError,
  );
}

Color? _getSuffixIconColor({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  final errorIconColor = hasError ? errorTheme?.suffixIconColor : null;
  return errorIconColor ?? suppliedDecoration?.suffixIconColor ?? themeDecoration?.suffixIconColor;
}

Color? _getCursorColor({required final bool hasError, required final InputDecorationErrorTheme? errorTheme}) {
  return hasError ? errorTheme?.cursorColor : null;
}

@protected
InputBorder? _getDefaultBorder({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
}) {
  return suppliedDecoration?.border ?? themeDecoration?.border;
}

@protected
InputBorder? _getErrorBorder({
  required final InputDecoration? suppliedDecoration,
  required final InputDecorationTheme? themeDecoration,
  required final bool hasError,
  required final InputDecorationErrorTheme? errorTheme,
}) {
  if (!hasError) {
    return null;
  }

  return suppliedDecoration?.errorBorder ?? errorTheme?.border ?? themeDecoration?.errorBorder;
}

@protected
TextStyle? _getErrorLabelStyle({
  required TextStyle? errorLabelStyle,
  required TextStyle? suppliedLabelStyle,
  required TextStyle? themeLabelStyle,
  required Color? errorColor,
  required bool hasError,
}) {
  final errorStyle = hasError ? errorLabelStyle : null;
  final defaultStyle = suppliedLabelStyle ?? themeLabelStyle;
  final defaultStyleWithPossibleError =
      hasError && errorColor != null ? (defaultStyle ?? TextStyle()).copyWith(color: errorColor) : defaultStyle;

  return errorStyle ?? defaultStyleWithPossibleError;
}
