import 'package:flutter/material.dart' hide Autocomplete, AutocompleteOnSelected, AutocompleteOptionToString;
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/input/autocomplete/widget/autocomplete.dart';
import 'package:ui_kit/input/validated_form_field/widget/validated_form_field.dart';

class ValidatedAutocompleteFormField<TOption> extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? minPopupRows;
  final int? maxPopupRows;
  final AutocompleteStringToOption<TOption> stringToOption;
  final AutocompleteOptionToString<TOption>? displayStringForOption;
  final Iterable<TOption> Function(TextEditingValue) optionsBuilder;
  final AutocompleteOnSelected<TOption?>? onSelected;
  final ValueChanged<String>? onTextSubmitted;
  final TOption? initialValue;
  final InputDecoration? decoration;
  final String? Function(TOption?, String)? validator;
  final String? validationId;
  final Consumer<TOption?>? onSaved;
  final bool limitToOptions;
  final String? invalidOptionErrorMessage;
  final bool enabled;

  const ValidatedAutocompleteFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.minPopupRows = 0,
    this.maxPopupRows = 10,
    required this.stringToOption,
    this.displayStringForOption,
    required this.optionsBuilder,
    this.onSelected,
    this.onTextSubmitted,
    this.initialValue,
    this.decoration,
    this.validator,
    this.validationId,
    this.onSaved,
    this.limitToOptions = false,
    this.invalidOptionErrorMessage,
    this.enabled = true,
  })  : assert(!limitToOptions || invalidOptionErrorMessage != null),
        assert(invalidOptionErrorMessage == null || limitToOptions);

  @override
  State<ValidatedAutocompleteFormField<TOption>> createState() => _ValidatedAutocompleteFormFieldState<TOption>();
}

class _ValidatedAutocompleteFormFieldState<TOption> extends State<ValidatedAutocompleteFormField<TOption>> {
  late TextEditingController _controller;

  void _setValueToController(TOption option) {
    final text = widget.displayStringForOption?.call(option) ?? option.toString();
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    final initialValue = widget.initialValue;
    if (initialValue != null) {
      _setValueToController(initialValue);
    }
  }

  @override
  void didUpdateWidget(covariant ValidatedAutocompleteFormField<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final value = _controller.value;
      if (oldWidget.controller == null) {
        _controller.dispose();
      }
      _controller = widget.controller ?? TextEditingController.fromValue(value);
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
    return ValidatedFormField<TOption>(
      initialValue: widget.initialValue,
      onSaved: widget.onSaved,
      validator: (option) {
        final text = _controller.text;

        if (widget.limitToOptions && option == null && text.isNotEmpty) {
          return widget.invalidOptionErrorMessage;
        }
        return widget.validator?.call(option, text);
      },
      validationId: widget.validationId,
      builder: (field) {
        final effectiveDecoration =
            (widget.decoration ?? const InputDecoration()).applyDefaults(Theme.of(field.context).inputDecorationTheme);
        final border = field.hasError ? effectiveDecoration.errorBorder : effectiveDecoration.enabledBorder;

        return Autocomplete<TOption>(
          textController: _controller,
          decoration: effectiveDecoration.copyWith(enabledBorder: border),
          stringToOption: widget.stringToOption,
          displayStringForOption: widget.displayStringForOption,
          maxPopupRows: widget.maxPopupRows,
          minPopupRows: widget.minPopupRows,
          onSelected: (option) {
            field.didChange(option);
            widget.onSelected?.call(option);
          },
          onTextSubmitted: widget.onTextSubmitted,
          optionsBuilder: widget.optionsBuilder,
          enabled: widget.enabled,
        );
      },
    );
  }
}
