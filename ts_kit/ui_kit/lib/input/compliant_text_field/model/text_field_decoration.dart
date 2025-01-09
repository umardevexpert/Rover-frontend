part of 'package:ui_kit/input/compliant_text_field/widget/material_specification_compliant_text_field.dart';

class _TextFieldDecoration {
  final InputBorder border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final TextStyle labelStyle;
  final TextStyle floatingLabelStyle;
  final Color suffixIconColor;
  final Color? cursorColor;

  const _TextFieldDecoration({
    required this.border,
    required this.enabledBorder,
    required this.focusedBorder,
    required this.labelStyle,
    required this.floatingLabelStyle,
    required this.suffixIconColor,
    required this.cursorColor,
  });
}
