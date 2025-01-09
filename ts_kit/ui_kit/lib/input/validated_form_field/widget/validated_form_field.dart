import 'package:flutter/material.dart';
import 'package:ui_kit/input/validated_form_field/theme/validation_error_theme.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form.dart';
import 'package:master_kit/util/shared_type_definitions.dart';

class ValidatedFormField<T> extends StatelessWidget {
  final Projector<FormFieldState<T>, Widget> builder;
  final ValueChanged<T?>? onSaved;
  final Projector<T?, String?>? validator;
  final T? initialValue;
  final bool enabled;
  final AutovalidateMode? autovalidateMode;
  final String? restorationId;
  final TextStyle? errorStyle;
  final double errorGap;
  final String? validationId;

  const ValidatedFormField({
    super.key,
    required this.builder,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.enabled = true,
    this.autovalidateMode,
    this.restorationId,
    this.errorStyle,
    this.errorGap = 8,
    this.validationId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = errorStyle ??
        ValidationErrorTheme.of(context)?.errorLabelTextStyle ??
        theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.error).merge(theme.inputDecorationTheme.errorStyle);

    return FormField<T>(
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            builder(field),
            if (field.hasError) ...[
              SizedBox(height: errorGap),
              Text(
                field.errorText!,
                style: style,
              )
            ]
          ],
        );
      },
      onSaved: onSaved,
      validator: (value) => _validateFormField(context, value),
      initialValue: initialValue,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      restorationId: restorationId,
    );
  }

  String? _validateFormField(BuildContext context, T? value) {
    final standardValidationResult = validator?.call(value);
    if (standardValidationResult != null || validationId == null) {
      return standardValidationResult;
    }
    final validatedForm = ValidatedForm.of(context);
    return validatedForm?.getExplicitValidationWithIdIfValidatingExplicit(validationId!);
  }
}
