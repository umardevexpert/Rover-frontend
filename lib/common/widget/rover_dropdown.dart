import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';
import 'package:ui_kit/input/dropdown/widget/options_popup_decorator.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/util/assets.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class RoverDropdown<TValue> extends StatefulWidget {
  final String valueText;
  final String labelText;
  final double rowHeight;
  final Iterable<TValue> options;
  final WidgetBuilder1<TValue> optionWidgetBuilder;
  final ValueChanged<TValue> onOptionSelected;
  final bool? scrollbarVisible;
  final int? minVisiblePopupRows;
  final int? maxVisiblePopupRows;
  final bool closeOnOptionSelected;
  final PopupController? popupController;
  final Projector<TValue, String>? displayStringForOption;
  final Projector<TValue, bool>? isOptionEnabled;

  const RoverDropdown({
    super.key,
    required this.valueText,
    required this.labelText,
    required this.rowHeight,
    required this.options,
    required this.optionWidgetBuilder,
    required this.onOptionSelected,
    this.popupController,
    this.minVisiblePopupRows,
    this.maxVisiblePopupRows,
    this.scrollbarVisible,
    this.displayStringForOption,
    this.isOptionEnabled,
    this.closeOnOptionSelected = true,
  });

  @override
  State<RoverDropdown<TValue>> createState() => _RoverDropdownState<TValue>();
}

class _RoverDropdownState<TValue> extends State<RoverDropdown<TValue>> {
  late final _textController = TextEditingController(text: widget.valueText);
  late final _popupController = widget.popupController ?? PopupController();

  @override
  void didUpdateWidget(covariant RoverDropdown<TValue> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueText != widget.valueText) {
      _textController.text = widget.valueText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OptionsPopupDecorator(
      controller: _popupController,
      maxVisiblePopupRows: widget.maxVisiblePopupRows,
      minVisiblePopupRows: widget.minVisiblePopupRows,
      listSettings: OptionsListSettings(
        options: widget.options,
        onSelected: _onOptionSelected,
        optionWidgetBuilder: widget.optionWidgetBuilder,
        displayStringForOption: widget.displayStringForOption,
        isOptionEnabled: widget.isOptionEnabled,
        rowHeight: widget.rowHeight,
        scrollbarVisible: widget.scrollbarVisible,
      ),
      child: TextField(
        controller: _textController,
        readOnly: true,
        onTap: _popupController.showPopup,
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: Assets.svgImage(
            'icon/arrow_down',
            color: AppTheme.of(context)?.colorScheme.primaryDark,
          ),
        ),
      ),
    );
  }

  void _onOptionSelected(TValue option) {
    widget.onOptionSelected(option);
    if (widget.closeOnOptionSelected) {
      _popupController.hidePopup();
    }
  }
}
