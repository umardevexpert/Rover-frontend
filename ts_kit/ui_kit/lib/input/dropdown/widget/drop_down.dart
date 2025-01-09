import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_facade_theme.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down_facade.dart';
import 'package:ui_kit/input/dropdown/widget/options_popup_decorator.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class DropDown<TOption> extends StatefulWidget {
  final PopupController? controller;
  final TOption? value;
  final List<String>? portalScopeLabels;
  final Iterable<TOption> options;
  final ValueChanged<TOption>? onChanged;
  final StringBuilder<TOption>? displayStringForOption;
  final WidgetBuilder1<TOption>? displayWidgetForOption;
  final WidgetBuilder1<TOption>? optionWidgetBuilder;
  final IndexedWidgetBuilder? dividerBuilder;
  final Predicate<TOption>? isOptionEnabled;
  final String? placeholder;
  final bool? scrollbarVisible;
  final bool embeddedStyle;
  final int? minPopupRows;
  final int? maxPopupRows;
  final DropDownFacadeTheme? facadeTheme;
  final DropDownPopupTheme? popupTheme;
  final bool hasError;
  final int? textWrapMaxLines;
  final int? popupTextWrapMaxLines;
  final bool enabled;

  const DropDown({
    super.key,
    this.controller,
    this.value,
    required this.options,
    this.onChanged,
    this.displayStringForOption,
    this.displayWidgetForOption,
    this.dividerBuilder,
    this.optionWidgetBuilder,
    this.placeholder,
    this.isOptionEnabled,
    this.scrollbarVisible,
    this.embeddedStyle = false,
    this.minPopupRows,
    this.maxPopupRows,
    this.facadeTheme,
    this.popupTheme,
    this.hasError = false,
    this.textWrapMaxLines,
    this.popupTextWrapMaxLines,
    this.portalScopeLabels,
    this.enabled = true,
  }) : assert(
          displayWidgetForOption == null || displayStringForOption == null,
          'Either displayWidgetForOption or displayStringForOption should be null, displayWidgetForOption has advantage, therefore displayStringForOption would be overwritten',
        );

  @override
  State<DropDown<TOption>> createState() => _DropDownState<TOption>();
}

class _DropDownState<TOption> extends State<DropDown<TOption>> {
  late final PopupController _optionsPopupController;

  final _facadeFocusNode = FocusNode();

  // We're using listeners and we need to react to listeners triggers by rebuilding the widget
  void _rebuildWidget() => setState(() {});

  @override
  void initState() {
    super.initState();
    _optionsPopupController = widget.controller ?? PopupController();
    _optionsPopupController.addListener(_rebuildWidget);

    _facadeFocusNode.onKeyEvent = (focusNode, keyEvent) {
      if (keyEvent is KeyDownEvent &&
          !_optionsPopupController.open &&
          keyEvent.logicalKey.keyId == LogicalKeyboardKey.enter.keyId) {
        _optionsPopupController.showPopup();
      }

      return KeyEventResult.ignored;
    };
  }

  @override
  void dispose() {
    _facadeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.popupTheme ?? DropDownPopupTheme.of(context);
    return OptionsPopupDecorator(
      controller: _optionsPopupController,
      listSettings: OptionsListSettings<TOption>(
        options: widget.options,
        displayStringForOption: widget.displayStringForOption,
        optionWidgetBuilder: widget.optionWidgetBuilder,
        paddingForOption: theme?.paddingForOption,
        dividerBuilder: widget.dividerBuilder,
        onSelected: (value) {
          widget.onChanged?.call(value);
          _optionsPopupController.hidePopup();
        },
        rowHeight: theme?.rowHeight,
        scrollbarVisible: widget.scrollbarVisible,
        textWrapMaxLines: widget.popupTextWrapMaxLines,
        isOptionEnabled: widget.isOptionEnabled,
      ),
      minVisiblePopupRows: widget.minPopupRows,
      maxVisiblePopupRows: widget.maxPopupRows,
      facadeFocusNode: _facadeFocusNode,
      child: _buildFacade(context),
      portalScopeLabels: widget.portalScopeLabels,
    );
  }

  Widget _buildFacade(BuildContext context) {
    final value = widget.value;
    final displayValue = value == null ? null : (widget.displayStringForOption?.call(value) ?? value.toString());
    return Focus(
      focusNode: _facadeFocusNode,
      canRequestFocus: widget.enabled,
      onFocusChange: (_) => _rebuildWidget(),
      child: DropDownFacade(
        isOpen: _optionsPopupController.open,
        hasError: widget.hasError,
        onTap: widget.enabled
            ? () {
                _facadeFocusNode.requestFocus();
                _optionsPopupController.showPopup();
              }
            : null,
        placeholder: widget.enabled ? widget.placeholder : displayValue,
        valueText: !widget.enabled ? null : displayValue,
        valueWidget: value == null ? null : widget.displayWidgetForOption?.call(context, value),
        embeddedStyle: widget.embeddedStyle,
        facadeTheme: widget.facadeTheme,
        maxLines: widget.textWrapMaxLines,
        drawFocusEffect: _facadeFocusNode.hasFocus,
        isEnabled: widget.enabled,
      ),
    );
  }
}
