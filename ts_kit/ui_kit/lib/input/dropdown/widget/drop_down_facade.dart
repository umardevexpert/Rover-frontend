import 'package:flutter/material.dart';
import 'package:ui_kit/input/dropdown/theme/drop_down_facade_theme.dart';

const _MATERIAL_MIN_TARGET_SIZE = 50.0;

class DropDownFacade extends StatelessWidget {
  final String? valueText;
  final Widget? valueWidget;
  final String? placeholder;
  final VoidCallback? onTap;
  final bool isOpen;
  final bool isEnabled;
  final bool embeddedStyle;
  final DropDownFacadeTheme? facadeTheme;
  final bool drawFocusEffect;
  final bool hasError;
  final int? maxLines;

  const DropDownFacade({
    super.key,
    this.onTap,
    this.valueText,
    this.placeholder,
    this.isOpen = false,
    this.isEnabled = true,
    this.embeddedStyle = false,
    this.facadeTheme,
    this.drawFocusEffect = false,
    this.hasError = false,
    this.maxLines,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(betka): rename deprecated textTheme properties after checking if every project has it defined
    final theme = Theme.of(context);
    final dropDownTheme = facadeTheme ?? DropDownFacadeTheme.of(context);

    final currentBorder = getCurrentBorder(dropDownTheme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: currentBorder,
          borderRadius: dropDownTheme?.borderRadius,
          color: embeddedStyle ? Colors.transparent : dropDownTheme?.backgroundColor,
        ),
        height: dropDownTheme?.height ?? _MATERIAL_MIN_TARGET_SIZE,
        padding: _getPaddingShrankByBorderSize(dropDownTheme?.padding ?? EdgeInsets.zero, currentBorder),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            valueWidget ?? _buildTextOption(theme, dropDownTheme),
            Icon(
              Icons.keyboard_arrow_down,
              color: isEnabled ? dropDownTheme?.arrowColor ?? theme.textTheme.bodyMedium?.color : theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextOption(ThemeData theme, DropDownFacadeTheme? dropDownTheme) {
    return Flexible(
      child: Text(
        valueText ?? placeholder ?? '',
        maxLines: maxLines ?? 2,
        overflow: TextOverflow.ellipsis,
        style: valueText != null
            ? dropDownTheme?.textStyle ?? theme.textTheme.titleMedium
            : dropDownTheme?.hintStyle ?? theme.inputDecorationTheme.hintStyle,
      ),
    );
  }

  BoxBorder? getCurrentBorder(DropDownFacadeTheme? theme) {
    if (embeddedStyle) {
      return null;
    }
    if (isOpen || drawFocusEffect) {
      return theme?.activeBorder;
    }
    if (hasError) {
      return theme?.errorBorder;
    }
    return theme?.border;
  }

  EdgeInsets _getPaddingShrankByBorderSize(EdgeInsets padding, BoxBorder? border) {
    if (border == null) {
      return padding;
    }
    if (border is Border) {
      return EdgeInsets.only(
        left: _shrinkPaddingSize(padding.left, border.left.width),
        right: _shrinkPaddingSize(padding.right, border.right.width),
        top: _shrinkPaddingSize(padding.top, border.top.width),
        bottom: _shrinkPaddingSize(padding.bottom, border.bottom.width),
      );
    }
    final dimensions = border.dimensions;
    return EdgeInsets.only(
      left: _shrinkPaddingSize(padding.left, dimensions.horizontal / 2),
      right: _shrinkPaddingSize(padding.right, dimensions.horizontal / 2),
      top: _shrinkPaddingSize(padding.top, dimensions.vertical / 2),
      bottom: _shrinkPaddingSize(padding.bottom, dimensions.vertical / 2),
    );
  }

  double _shrinkPaddingSize(double padding, double borderWidth) {
    return (padding - borderWidth).clamp(0, double.infinity);
  }
}
