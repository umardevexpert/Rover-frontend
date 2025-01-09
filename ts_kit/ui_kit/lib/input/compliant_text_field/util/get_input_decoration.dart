part of 'package:ui_kit/input/compliant_text_field/widget/material_specification_compliant_text_field.dart';

_TextFieldDecoration _resolveInputDecoration({
  required BuildContext context,
  required InputDecoration? suppliedDecoration,
  required bool hasError,
  required bool isOutlined,
}) {
  final theme = Theme.of(context);
  final errorTheme = InputDecorationErrorTheme.of(context);
  final themeDecoration = theme.inputDecorationTheme;

  final border = _getBorder(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final enabledBorder = _getEnabledBorder(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final focusedBorder = _getFocusedBorder(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final labelStyle = _getLabelStyle(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final floatingLabelStyle = _getFloatingLabelStyle(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final suffixIconColor = _getSuffixIconColor(
    suppliedDecoration: suppliedDecoration,
    themeDecoration: themeDecoration,
    hasError: hasError,
    errorTheme: errorTheme,
  );

  final cursorColor = _getCursorColor(hasError: hasError, errorTheme: errorTheme);

  late final InputBorder materialBorder;
  if (border == null && enabledBorder == null) {
    materialBorder = _getMaterial3CompliantBorder(theme: theme, isOutlined: isOutlined, hasError: hasError);
  } else {
    materialBorder = isOutlined ? OutlineInputBorder() : UnderlineInputBorder();
  }

  late final TextStyle materialLabelStyle;
  if (labelStyle == null || floatingLabelStyle == null) {
    materialLabelStyle = _getMaterial3CompliantTextStyle(theme: theme, hasError: hasError);
  } else {
    materialLabelStyle = TextStyle();
  }

  late final Color materialSuffixIconColor;
  if (suffixIconColor == null) {
    materialSuffixIconColor = _getMaterial3CompliantColor(theme: theme, hasError: hasError);
  } else {
    materialSuffixIconColor = theme.colorScheme.onSurfaceVariant;
  }

  return _TextFieldDecoration(
    border: border ?? materialBorder,
    enabledBorder: enabledBorder,
    focusedBorder: focusedBorder,
    labelStyle: labelStyle ?? materialLabelStyle,
    floatingLabelStyle: floatingLabelStyle ?? materialLabelStyle,
    suffixIconColor: suffixIconColor ?? materialSuffixIconColor,
    cursorColor: cursorColor,
  );
}
