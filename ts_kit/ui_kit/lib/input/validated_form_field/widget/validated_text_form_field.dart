import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/input/compliant_text_field/widget/material_specification_compliant_text_field.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form_field.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class ValidatedTextFormField extends StatefulWidget {
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
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? validationId;
  final bool readOnly;
  final bool outlined;
  final bool enabled;
  final WidgetBuilder1<EditableTextState>? contextMenuBuilder;

  const ValidatedTextFormField({
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
    this.onFieldSubmitted,
    this.validationId,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
    this.outlined = true,
    this.enabled = true,
    this.contextMenuBuilder,
  }) : assert(initialValue == null || controller == null);

  @override
  State<ValidatedTextFormField> createState() => _ValidatedTextFormFieldState();
}

class _ValidatedTextFormFieldState extends State<ValidatedTextFormField> {
  late final TextEditingController _controller;
  FormFieldState<String>? _fieldState;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue ?? '');

    // When controller is received from external source, it can also receive updates outside of this widget.
    // Once the controller is updated, we need to pass this new value and call onChanged method.
    if (widget.controller != null) {
      widget.controller!.addListener(_handleControllerChanges);
    }
  }

  @override
  void didUpdateWidget(ValidatedTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      // In order to remove listener, we need to provide the same function instance to the
      // removeListener call as was passed to the addListener callback
      oldWidget.controller?.removeListener(_handleControllerChanges);
      widget.controller?.addListener(_handleControllerChanges);

      // We need to update the internal value persisted when the controller is replaced with a new one
      if (widget.controller != null) {
        // BUG FIX(Pavel): We cannot call didChange method here, since the widget is in the process of rebuilding
        // causing an error to occur.
        // ignore: invalid_use_of_protected_member
        _fieldState?.setValue(widget.controller!.text);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final String? initialValue;
    if (controller != null && controller.text != '') {
      initialValue = controller.text;
    } else {
      initialValue = widget.initialValue;
    }

    return ValidatedFormField<String>(
      initialValue: initialValue,
      onSaved: widget.onSaved,
      validator: widget.validator,
      validationId: widget.validationId,
      builder: (field) {
        _fieldState = field;

        return MaterialSpecificationCompliantTextField(
          controller: _controller,
          focusNode: widget.focusNode,
          decoration: widget.decoration,
          textInputAction: widget.textInputAction,
          style: widget.style,
          keyboardType: widget.keyboardType,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          textCapitalization: widget.textCapitalization,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          inputFormatters: widget.inputFormatters,
          onSubmitted: widget.onFieldSubmitted,
          readOnly: widget.readOnly,
          onChanged: _onChanged,
          outlined: widget.outlined,
          hasError: field.hasError,
          enabled: widget.enabled,
          contextMenuBuilder: widget.contextMenuBuilder,
        );
      },
    );
  }

  void _handleControllerChanges() {
    return _onChanged(_controller.text);
  }

  void _onChanged(final String value) {
    final previousValue = _fieldState?.value;

    if (value != previousValue) {
      _fieldState?.didChange(value);
      widget.onChanged?.call(value);
    }
  }
}
