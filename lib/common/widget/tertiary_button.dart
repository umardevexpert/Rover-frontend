import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

enum TertiaryButtonSize { small, large }

enum TertiaryButtonVariant { main, destructive }

class TertiaryButton extends StatelessWidget {
  final TertiaryButtonSize size;
  final TertiaryButtonVariant variant;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onPressed;
  final Widget child;

  const TertiaryButton({
    super.key,
    this.size = TertiaryButtonSize.small,
    this.variant = TertiaryButtonVariant.main,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final theme = Theme.of(context);
    final textButtonStyle = theme.textButtonTheme.style;

    return TextButton(
      style: textButtonStyle?.copyWith(
        textStyle: size == TertiaryButtonSize.small
            ? MaterialStateProperty.resolveWith(
                (states) => textButtonStyle.textStyle?.resolve(states)?.copyWith(fontSize: 14),
              )
            : null,
        foregroundColor: variant == TertiaryButtonVariant.destructive
            ? MaterialStateProperty.resolveWith(
                (states) {
                  if (states.isEmpty ||
                      states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.hovered)) {
                    return appTheme?.colorScheme.red;
                  }
                  return textButtonStyle.foregroundColor?.resolve(states);
                },
              )
            : null,
        overlayColor: variant == TertiaryButtonVariant.destructive
            ? MaterialStateProperty.resolveWith(
                (states) => states.contains(MaterialState.pressed) || states.contains(MaterialState.hovered)
                    ? appTheme?.colorScheme.red.withOpacity(0.05)
                    : null,
              )
            : null,
      ),
      onPressed: onPressed,
      child: IconTheme.merge(
        data: IconThemeData(size: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: SMALLER_UI_GAP),
                child: prefixIcon,
              ),
            child,
            if (suffixIcon != null)
              Padding(
                padding: const EdgeInsets.only(left: SMALLER_UI_GAP),
                child: suffixIcon,
              ),
          ],
        ),
      ),
    );
  }
}
