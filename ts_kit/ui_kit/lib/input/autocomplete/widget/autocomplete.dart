import 'dart:async';

import 'package:flutter/material.dart'
    hide AutocompleteOnSelected, AutocompleteOptionToString, AutocompleteOptionsBuilder;
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/input/autocomplete/theme/autocomplete_facade_theme.dart';
import 'package:ui_kit/input/autocomplete/widget/autocomplete_decorator.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/util/keyboard_controller.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

typedef AutocompleteStringToOption<TOption> = TOption? Function(String value);
typedef AutocompleteOnSelected<TOption> = ValueChanged<TOption>;
typedef AutocompleteOptionToString<TOption> = String Function(TOption option);
typedef AutocompleteOptionsBuilder<TOption> = FutureOr<Iterable<TOption>> Function(TextEditingValue textEditingValue);

class Autocomplete<TOption> extends StatefulWidget {
  final SelectedOptionController<TOption>? selectedOptionController;
  final TextEditingController? textController;
  final PopupController? popupController;
  final FocusNode? focusNode;
  final int? minPopupRows;
  final int? maxPopupRows;
  final AutocompleteFacadeTheme? facadeTheme;
  final AutocompleteStringToOption<TOption>? stringToOption;
  final AutocompleteOptionToString<TOption>? displayStringForOption;
  final WidgetBuilder1<TOption>? optionWidgetBuilder;
  final IndexedWidgetBuilder? dividerBuilder;
  final AutocompleteOptionsBuilder<TOption> optionsBuilder;
  final AutocompleteOnSelected<TOption?>? onSelected;
  final ValueChanged<String>? onTextSubmitted;
  final ValueChanged<String>? onTextChanged;
  final InputDecoration? decoration;
  final double? popupRowHeight;
  final DropDownPopupTheme? popupTheme;
  final Predicate<TOption>? isOptionEnabled;
  final bool hideCursor;
  final VoidCallback? onTextFieldTap;
  final bool enabled;

  const Autocomplete({
    super.key,
    this.selectedOptionController,
    this.textController,
    this.popupController,
    this.optionWidgetBuilder,
    this.dividerBuilder,
    this.focusNode,
    this.minPopupRows = 0,
    this.maxPopupRows = 10,
    this.facadeTheme,
    this.stringToOption,
    this.displayStringForOption,
    required this.optionsBuilder,
    this.onSelected,
    this.onTextSubmitted,
    this.onTextChanged,
    this.decoration,
    this.popupRowHeight,
    this.popupTheme,
    this.isOptionEnabled,
    this.hideCursor = false,
    this.onTextFieldTap,
    this.enabled = true,
  });

  @override
  State<Autocomplete<TOption>> createState() => _AutocompleteState();
}

class _AutocompleteState<TOption> extends State<Autocomplete<TOption>> {
  late TextEditingController _textController;
  late final PopupController _popupController;
  late final SelectedOptionController<TOption> _selectedOptionController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = widget.textController ?? TextEditingController();
    _selectedOptionController = widget.selectedOptionController ?? SelectedOptionController<TOption>();
    _popupController = widget.popupController ?? PopupController();
    _popupController.addListener(() => setState(() {}));

    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant Autocomplete<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textController != widget.textController) {
      final value = _textController.value;
      if (oldWidget.textController == null) {
        _textController.dispose();
      }
      _textController = widget.textController ?? TextEditingController.fromValue(value);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
    }
  }

  @override
  void dispose() {
    if (widget.textController == null) {
      _textController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutocompleteDecorator<TOption>(
      textEditingController: _textController,
      popupController: _popupController,
      selectedOptionController: _selectedOptionController,
      focusNode: _focusNode,
      fieldViewBuilder: _buildTextField,
      minPopupRows: widget.minPopupRows,
      maxPopupRows: widget.maxPopupRows,
      displayStringForOption: widget.displayStringForOption,
      optionsBuilder: widget.optionsBuilder,
      optionWidgetBuilder: widget.optionWidgetBuilder,
      dividerBuilder: widget.dividerBuilder,
      popupRowHeight: widget.popupRowHeight,
      popupTheme: widget.popupTheme,
      onSelected: (option) {
        widget.onSelected?.call(option);
        KeyboardController.hideKeyboard();
        _displayOptionInTextArea(option);
      },
      isOptionEnabled: widget.isOptionEnabled,
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController editingController,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
    final theme = Theme.of(context).inputDecorationTheme;
    final facadeTheme = (widget.facadeTheme ?? AutocompleteFacadeTheme.of(context))?.inputDecorationTheme;

    final facadeThemeBorder = facadeTheme?.focusedBorder ?? facadeTheme?.border;
    final themeBorder = theme.focusedBorder ?? theme.border;
    final defaultBorder = facadeTheme?.enabledBorder ?? theme.enabledBorder;

    return TextField(
      onTap: () {
        _popupController.showPopup();
        widget.onTextFieldTap?.call();
      },
      showCursor: !widget.hideCursor,
      controller: editingController,
      focusNode: focusNode,
      onSubmitted: (value) {
        _popupController.hidePopup();
        widget.onTextSubmitted?.call(value);
      },
      onChanged: (value) {
        widget.onTextChanged?.call(value);
        if (widget.stringToOption != null) {
          if (value.isEmpty) {
            widget.onSelected?.call(null);
          } else {
            final option = widget.stringToOption!(value);
            if (option != null) {
              widget.onSelected?.call(option);
            }
          }
        }
      },
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        border: facadeTheme?.border ?? theme.border,
        errorBorder: facadeTheme?.errorBorder ?? theme.errorBorder,
        focusedBorder: facadeTheme?.focusedBorder ?? theme.focusedBorder,
        disabledBorder: facadeTheme?.disabledBorder ?? theme.disabledBorder,
        enabledBorder: _popupController.open ? (facadeThemeBorder ?? themeBorder) : defaultBorder,
      ),
      enabled: widget.enabled,
    );
  }

  String _optionToText(TOption option) =>
      widget.displayStringForOption?.call(option) ?? (option == null ? '' : option.toString());

  void _displayOptionInTextArea(TOption option) {
    final text = _optionToText(option);
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
    );
  }
}
