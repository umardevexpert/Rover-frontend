import 'package:flutter/material.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_popup_theme.dart';
import 'package:ui_kit/input/dropdown/widget/options_popup.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';
import 'package:ui_kit/input/popup/widget/popup_decorator.dart';

class OptionsPopupDecorator<TOption> extends StatelessWidget {
  final PopupController? controller;
  final Widget child;
  final OptionsListSettings<TOption> listSettings;
  final DropDownPopupTheme? popupTheme;
  final int? minVisiblePopupRows;
  final int? maxVisiblePopupRows;
  final bool closePopupOnEscapePress;
  final bool closePopupOnEnterPress;
  final FocusNode? facadeFocusNode;
  final List<String>? portalScopeLabels;

  const OptionsPopupDecorator({
    super.key,
    this.controller,
    required this.child,
    required this.listSettings,
    this.popupTheme,
    this.minVisiblePopupRows,
    this.maxVisiblePopupRows,
    this.closePopupOnEscapePress = true,
    this.closePopupOnEnterPress = true,
    this.facadeFocusNode,
    this.portalScopeLabels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = popupTheme ?? DropDownPopupTheme.of(context);

    final optionsPopup = OptionsPopup<TOption>(
      listSettings: listSettings.copyWith(
        onSelected: (value) {
          listSettings.onSelected?.call(value);
          //BUG Fix: fix flickering of focus border when focus is in popup and selecting a value
          facadeFocusNode?.requestFocus();
        },
      ),
      popupTheme: popupTheme,
      minVisibleRows: minVisiblePopupRows,
      maxVisibleRows: maxVisiblePopupRows,
    );

    return PopupDecorator(
      child: child,
      popupPadding: EdgeInsets.only(top: theme?.popupToElementGap ?? 0),
      popupContentBuilder: (context, size) {
        if (listSettings.options.isEmpty) {
          return const SizedBox.shrink();
        }
        return optionsPopup;
      },
      controller: controller,
      closePopupOnEnterPress: closePopupOnEnterPress,
      closePopupOnEscapePress: closePopupOnEscapePress,
      popupContentHeight: optionsPopup.height,
      portalScopeLabels: portalScopeLabels,
    );
  }
}
