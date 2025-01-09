import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_text_form_field.dart';

class PasswordField extends StatefulWidget {
  final String? validationId;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? label;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const PasswordField({
    super.key,
    this.validationId,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    this.label,
    this.hintText,
    this.controller,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return ValidatedTextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        label: widget.label,
        hintText: widget.hintText,
        suffixIcon: _buildPasswordIconButton(),
        suffixIconColor: AppTheme.of(context)?.colorScheme.grey500,
      ),
      obscureText: _isHidden,
      textInputAction: widget.textInputAction,
      validationId: widget.validationId,
      validator: widget.validator,
      onSaved: widget.onSaved,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }

  Widget _buildPasswordIconButton() {
    return Container(
      padding: EdgeInsets.only(right: 8),
      //This has to be here otherwise the splash happens behind the text field
      child: Material(
        type: MaterialType.transparency,
        child: IconButton(
          splashRadius: 20,
          onPressed: () => setState(() => _isHidden = !_isHidden),
          icon: Icon(
            _isHidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}
