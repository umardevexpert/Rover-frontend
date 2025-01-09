// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/input/compliant_text_field/model/resolvable_with_external_error_state.dart';
import 'package:ui_kit/input/compliant_text_field/theme/input_decoration_error_theme.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

part 'package:ui_kit/input/compliant_text_field/model/text_field_decoration.dart';
part 'package:ui_kit/input/compliant_text_field/util/get_input_decoration.dart';
part 'package:ui_kit/input/compliant_text_field/util/get_predefined_decoration.dart';
part 'package:ui_kit/input/compliant_text_field/util/resolve_state_to_material3_compliant_decoration.dart';

// BUG FIX: Flutter textfield has design that does not conform to Material3 specification.
// This class fixes incorrect behavior of Hover and Focus state priority (where material design specifies that
// Focus has priority over Hover but Flutter widget behaves oppositely).
class MaterialSpecificationCompliantTextField extends StatelessWidget {
  final String? initialValue;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? validationId;
  final bool readOnly;
  final bool outlined;
  final bool hasError;
  final bool enabled;
  final WidgetBuilder1<EditableTextState>? contextMenuBuilder;

  MaterialSpecificationCompliantTextField({
    super.key,
    this.initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.controller,
    this.onSubmitted,
    this.validationId,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.outlined = true,
    this.hasError = false,
    this.enabled = true,
    this.contextMenuBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resolvedDecoration = _resolveInputDecoration(
      context: context,
      suppliedDecoration: decoration,
      hasError: hasError,
      isOutlined: outlined,
    );

    final usedDecoration = (decoration ?? InputDecoration()).applyDefaults(theme.inputDecorationTheme);
    final effectiveDecoration = usedDecoration.copyWith(
      border: resolvedDecoration.border,
      enabledBorder: resolvedDecoration.enabledBorder,
      focusedBorder: resolvedDecoration.focusedBorder,
      labelStyle: resolvedDecoration.labelStyle,
      floatingLabelStyle: resolvedDecoration.floatingLabelStyle,
      suffixIconColor: resolvedDecoration.suffixIconColor,
      filled: (decoration?.filled ?? !outlined) || (usedDecoration.filled ?? false),
    );

    ///IMPORTANT: Due to Textfields property contextMenuBuilder not being null by default, we must
    ///use this pattern which conditionally uses Textfields property
    if (contextMenuBuilder == null) {
      return TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: effectiveDecoration,
        textInputAction: textInputAction,
        style: style,
        keyboardType: keyboardType,
        obscuringCharacter: obscuringCharacter,
        obscureText: obscureText,
        autocorrect: autocorrect,
        textCapitalization: textCapitalization,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
        readOnly: readOnly,
        onChanged: onChanged,
        cursorColor: resolvedDecoration.cursorColor,
        enabled: enabled,
      );
    }
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: effectiveDecoration,
      textInputAction: textInputAction,
      style: style,
      keyboardType: keyboardType,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      autocorrect: autocorrect,
      textCapitalization: textCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      onChanged: onChanged,
      cursorColor: resolvedDecoration.cursorColor,
      enabled: enabled,
      contextMenuBuilder: contextMenuBuilder,
    );
  }
}
