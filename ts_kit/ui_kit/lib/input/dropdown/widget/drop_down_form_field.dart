import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_facade_theme.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form_field.dart';

class DropDownFormField<TOption> extends StatelessWidget {
  final PopupController? controller;
  final TOption? initialValue;
  final Iterable<TOption> options;
  final ValueChanged<TOption>? onChanged;
  final StringBuilder<TOption>? displayStringForOption;
  final Predicate<TOption>? isOptionEnabled;
  final String? placeholder;
  final bool? scrollbarVisible;
  final bool embeddedStyle;
  final int? minPopupRows;
  final int? maxPopupRows;
  final DropDownFacadeTheme? facadeTheme;
  final DropDownPopupTheme? popupTheme;
  final FormFieldSetter<TOption?>? onSaved;
  final FormFieldValidator<TOption?>? validator;
  final String? validationId;
  final int? textWrapMaxLines;
  final int? popupTextWrapMaxLines;
  final bool enabled;

  const DropDownFormField({
    super.key,
    this.controller,
    this.initialValue,
    required this.options,
    this.onChanged,
    this.displayStringForOption,
    this.isOptionEnabled,
    this.placeholder,
    this.scrollbarVisible,
    this.embeddedStyle = false,
    this.minPopupRows,
    this.maxPopupRows,
    this.facadeTheme,
    this.popupTheme,
    this.onSaved,
    this.validator,
    this.validationId,
    this.textWrapMaxLines,
    this.popupTextWrapMaxLines,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DropDownFacadeTheme.of(context);

    return ValidatedFormField<TOption>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      validationId: validationId,
      errorStyle: theme?.errorLabelTextStyle,
      builder: (field) {
        return DropDown<TOption>(
          controller: controller,
          value: field.value,
          options: options,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
          displayStringForOption: displayStringForOption,
          isOptionEnabled: isOptionEnabled,
          placeholder: placeholder,
          scrollbarVisible: scrollbarVisible,
          embeddedStyle: embeddedStyle,
          minPopupRows: minPopupRows,
          maxPopupRows: maxPopupRows,
          facadeTheme: facadeTheme,
          popupTheme: popupTheme,
          hasError: field.hasError,
          textWrapMaxLines: textWrapMaxLines,
          popupTextWrapMaxLines: popupTextWrapMaxLines,
          enabled: enabled,
        );
      },
    );
  }
}
