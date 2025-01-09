import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:ui_kit/adaptive/widget/adaptive.dart';
import 'package:ui_kit/sdk_extension/global_key_extension.dart';

class PopupController extends ChangeNotifier {
  bool _open = false;

  bool get open => _open;

  void showPopup() {
    _open = true;
    notifyListeners();
  }

  void hidePopup() {
    _open = false;
    notifyListeners();
  }
}

class GenericPopupBuilder extends StatefulWidget {
  final PopupController? controller;
  final List<String>? portalScopeLabels;
  final Widget Function(BuildContext, Size) popupContentBuilder;
  final Rectangle<double> Function(BuildContext context, Rectangle<double> childPosition, Size windowSize)
      popupPositionProvider;
  final bool closePopupOnEscapePress;
  final bool closePopupOnEnterPress;
  final Widget child;
  final FocusNode? facadeFocusNode;

  const GenericPopupBuilder({
    super.key,
    this.controller,
    this.portalScopeLabels,
    required this.popupContentBuilder,
    required this.popupPositionProvider,
    this.closePopupOnEscapePress = true,
    this.closePopupOnEnterPress = true,
    required this.child,
    this.facadeFocusNode,
  });

  @override
  State<GenericPopupBuilder> createState() => _GenericPopupBuilderState();
}

class _GenericPopupBuilderState extends State<GenericPopupBuilder> {
  late final PopupController _controller;
  final _popupFocusNode = FocusScopeNode();
  final _decoratedWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PopupController();

    _controller.addListener(() => setState(() {}));

    KeyEventResult keyEventHandler(int keyId, bool isPopupVisible) {
      final enterPressed = keyId == LogicalKeyboardKey.enter.keyId;
      final escapePressed = keyId == LogicalKeyboardKey.escape.keyId;

      if (isPopupVisible &&
          ((enterPressed && widget.closePopupOnEnterPress) || (escapePressed && widget.closePopupOnEscapePress))) {
        widget.facadeFocusNode?.requestFocus();
        _controller.hidePopup();
      }

      // We want to ignore it, since ListView has its own onKeyEvent, which handles submitting on enter press
      return KeyEventResult.ignored;
    }

    _popupFocusNode.onKeyEvent = (focusNode, keyEvent) {
      if (keyEvent is KeyDownEvent) {
        return keyEventHandler(keyEvent.logicalKey.keyId, _controller.open);
      }
      return KeyEventResult.ignored;
    };

    final facadeOnKeyEvent = widget.facadeFocusNode?.onKeyEvent;
    widget.facadeFocusNode?.onKeyEvent = (focusNode, keyEvent) {
      if (keyEvent is KeyUpEvent) {
        return KeyEventResult.ignored;
      }

      // BUG Fix: The FacadeOnKeyEvent can open the popup and then the keyEventHandler will incorrectly close it
      final wasPopupOpen = _controller.open;
      facadeOnKeyEvent?.call(focusNode, keyEvent);

      keyEventHandler(keyEvent.logicalKey.keyId, wasPopupOpen);

      return KeyEventResult.ignored;
    };
  }

  @override
  Widget build(BuildContext context) {
    final childRectangle = _decoratedWidgetKey.globalPaintBounds?.getRectangle();

    return PortalTarget(
      portalCandidateLabels: widget.portalScopeLabels?.map(PortalLabel.new).toList() ?? const [PortalLabel.main],
      visible: _controller.open,
      portalFollower: FocusScope(
        node: _popupFocusNode,
        child: GestureDetector(
          onPanEnd: (_) => _controller.hidePopup(),
          behavior: HitTestBehavior.opaque,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final popupPosition = widget.popupPositionProvider(context, childRectangle!, MediaQuery.of(context).size);
              return Padding(
                padding: EdgeInsets.only(
                  left: popupPosition.left,
                  top: popupPosition.top,
                  right: screenWidth(context) - popupPosition.right,
                  bottom: screenHeight(context) - popupPosition.bottom,
                ),
                child: widget.popupContentBuilder(context, Size(popupPosition.width, popupPosition.height)),
              );
            },
          ),
        ),
      ),
      child: SizedBox(key: _decoratedWidgetKey, child: widget.child),
    );
  }
}

extension on Rect {
  Rectangle<double> getRectangle() => Rectangle(left, top, width, height);
}
