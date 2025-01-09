import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:ui_kit/adaptive/widget/adaptive.dart';
import 'package:ui_kit/input/popup/widget/generic_popup_builder.dart';

class PopupDecorator extends StatelessWidget {
  final PopupController? controller;
  final Widget child;
  final Widget Function(BuildContext, Size) popupContentBuilder;
  final double popupContentHeight;
  final EdgeInsets popupPadding;
  final FocusNode? facadeFocusNode;
  final bool closePopupOnEscapePress;
  final bool closePopupOnEnterPress;
  final List<String>? portalScopeLabels;

  const PopupDecorator({
    super.key,
    this.controller,
    this.facadeFocusNode,
    required this.child,
    this.closePopupOnEscapePress = true,
    this.closePopupOnEnterPress = true,
    this.popupPadding = EdgeInsets.zero,
    required this.popupContentHeight,
    required this.popupContentBuilder,
    this.portalScopeLabels,
  });

  @override
  Widget build(BuildContext context) {
    return GenericPopupBuilder(
      controller: controller,
      popupContentBuilder: popupContentBuilder,
      popupPositionProvider: (context, childPosition, _) {
        final y = childPosition.top + childPosition.height + popupPadding.top;
        final maxY = screenHeight(context) - popupContentHeight - oneTimeOnlyBottomSafeAreaHeight();

        return Rectangle(childPosition.left, min(y, maxY), childPosition.width, popupContentHeight);
      },
      closePopupOnEscapePress: closePopupOnEscapePress,
      closePopupOnEnterPress: closePopupOnEnterPress,
      facadeFocusNode: facadeFocusNode,
      child: child,
      portalScopeLabels: portalScopeLabels,
    );
  }
}
