import 'package:flutter/material.dart';
import 'package:rover/common/util/form_validators.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';

class EmailField extends StatelessWidget {
  final String? validationId;
  final FormFieldSetter<String>? onSaved;
  final TextInputAction? textInputAction;

  const EmailField({super.key, this.validationId, this.onSaved, this.textInputAction});

  @override
  Widget build(BuildContext context) {
    return ValidatedTextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validationId: validationId,
      validator: FormValidators.validateEmail,
      textInputAction: textInputAction,
      onSaved: onSaved,
    );
  }
}
