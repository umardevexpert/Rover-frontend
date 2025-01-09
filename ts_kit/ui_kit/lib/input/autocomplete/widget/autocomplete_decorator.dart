import 'dart:async';

import 'package:flutter/material.dart'
    hide AutocompleteOnSelected, AutocompleteOptionToString, AutocompleteOptionsBuilder;
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/dropdown/widget/options_popup_decorator.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

typedef AutocompleteOnSelected<TOption> = ValueChanged<TOption>;
typedef AutocompleteOptionToString<TOption> = String Function(TOption option);
typedef AutocompleteOptionsBuilder<TOption> = FutureOr<Iterable<TOption>> Function(TextEditingValue textEditingValue);

class SelectedOptionController<TOption> {
  Consumer<TOption>? _onOptionChanged;
  TOption? _selectedOption;

  TOption? get selectedOption => _selectedOption;

  void setSelectedOption(TOption newSelectedOption) {
    _selectedOption = newSelectedOption;
    _onOptionChanged?.call(newSelectedOption);
  }
}

class AutocompleteDecorator<TOption> extends StatefulWidget {
  final SelectedOptionController<TOption>? selectedOptionController;
  final AutocompleteOptionsBuilder<TOption> optionsBuilder;
  final AutocompleteOptionToString<TOption>? displayStringForOption;
  final WidgetBuilder1<TOption>? optionWidgetBuilder;
  final IndexedWidgetBuilder? dividerBuilder;
  final AutocompleteFieldViewBuilder fieldViewBuilder;
  final AutocompleteOnSelected<TOption>? onSelected;
  final double? popupRowHeight;
  final int? maxPopupRows;
  final int? minPopupRows;
  final TextEditingController? textEditingController;
  final PopupController? popupController;
  final FocusNode? focusNode;
  final DropDownPopupTheme? popupTheme;
  final Predicate<TOption>? isOptionEnabled;

  const AutocompleteDecorator({
    super.key,
    this.selectedOptionController,
    required this.optionsBuilder,
    this.displayStringForOption,
    this.optionWidgetBuilder,
    this.dividerBuilder,
    required this.fieldViewBuilder,
    this.onSelected,
    this.popupRowHeight,
    this.maxPopupRows,
    this.minPopupRows,
    this.textEditingController,
    this.popupController,
    this.focusNode,
    this.popupTheme,
    this.isOptionEnabled,
  });

  @override
  State<AutocompleteDecorator<TOption>> createState() => _AutocompleteDecoratorState();
}

class _AutocompleteDecoratorState<TOption> extends State<AutocompleteDecorator<TOption>> {
  Iterable<TOption> _suggestions = [];
  bool _doNotOpenDropDownAtNextTextUpdate = false;
  bool _allowOpeningPopupOnFocus = true;
  late final PopupController _popupController;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _popupController = widget.popupController ?? PopupController();
    _installTextEditingControllerListener();
    _installFocusNodeListener();
  }

  @override
  void didUpdateWidget(covariant AutocompleteDecorator<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textEditingController != widget.textEditingController) {
      if (oldWidget.textEditingController == null) {
        _textEditingController.dispose();
      }
      _installTextEditingControllerListener();
    }

    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _installFocusNodeListener();
    }

    widget.selectedOptionController?._onOptionChanged = _onSelectedOption;
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) {
      _textEditingController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OptionsPopupDecorator<TOption>(
      controller: _popupController,
      facadeFocusNode: _focusNode,
      listSettings: OptionsListSettings<TOption>(
        options: _suggestions,
        rowHeight: widget.popupRowHeight,
        displayStringForOption: widget.displayStringForOption,
        onSelected: widget.selectedOptionController?.setSelectedOption,
        optionWidgetBuilder: widget.optionWidgetBuilder,
        dividerBuilder: widget.dividerBuilder,
        isOptionEnabled: widget.isOptionEnabled,
      ),
      minVisiblePopupRows: widget.minPopupRows,
      maxVisiblePopupRows: widget.maxPopupRows,
      popupTheme: widget.popupTheme,
      child: widget.fieldViewBuilder(context, _textEditingController, _focusNode, _onSubmitted),
    );
  }

  void _onSelectedOption(TOption newSelectedOption) {
    _doNotOpenDropDownAtNextTextUpdate = true;
    widget.onSelected?.call(newSelectedOption);
    _popupController.hidePopup();
  }

  void _onSubmitted() => _popupController.hidePopup();

  void _installTextEditingControllerListener() {
    _textEditingController = widget.textEditingController ?? TextEditingController();
    _textEditingController.addListener(() async {
      // ATTENTION: POSSIBLE RACE CONDITION!
      final options = await widget.optionsBuilder(_textEditingController.value);
      setState(() => _suggestions = options);
      if (_suggestions.isNotEmpty && !_doNotOpenDropDownAtNextTextUpdate && _focusNode.hasFocus) {
        _popupController.showPopup();
      }

      if (_suggestions.isEmpty) {
        _popupController.hidePopup();
      }

      _doNotOpenDropDownAtNextTextUpdate = false;
    });
  }

  void _installFocusNodeListener() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_allowOpeningPopupOnFocus && _focusNode.hasFocus && !_popupController.open) {
        _popupController.showPopup();
        _allowOpeningPopupOnFocus = false;
      } else if (!_focusNode.hasFocus && !_popupController.open) {
        _allowOpeningPopupOnFocus = true;
      }
    });
  }
}
