import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

enum PrimaryButtonSize { small, medium, large }

enum PrimaryButtonVariant { main, destructive }

class PrimaryButton extends StatelessWidget {
  final PrimaryButtonSize size;
  final PrimaryButtonVariant variant;
  final ButtonStyle? buttonStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget child;

  const PrimaryButton({
    super.key,
    this.size = PrimaryButtonSize.medium,
    this.variant = PrimaryButtonVariant.main,
    this.buttonStyle,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    required this.child,
  }) : assert(prefixIcon == null || suffixIcon == null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    final colorScheme = appTheme?.colorScheme;

    final defaultButtonStyle = theme.elevatedButtonTheme.style?.copyWith(
      padding: _padding,
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme?.grey200;
          }
          if (states.contains(MaterialState.pressed)) {
            return _getPressedBackgroundColor(colorScheme);
          }
          if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
            return _getHoverBackgroundColor(colorScheme);
          }
          return _getDefaultBackgroundColor(colorScheme);
        },
      ),
    );

    return ElevatedButton(
      style: buttonStyle?.merge(defaultButtonStyle) ?? defaultButtonStyle,
      onPressed: (isLoading || !enabled) ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
          : IconTheme.merge(
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

  MaterialStateProperty<EdgeInsetsGeometry?>? get _padding {
    switch (size) {
      case PrimaryButtonSize.large:
        return MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0));
      case PrimaryButtonSize.medium:
        return null;
      case PrimaryButtonSize.small:
        return MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0));
    }
  }

  Color? _getPressedBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case PrimaryButtonVariant.main:
        return colorScheme?.primary;
      case PrimaryButtonVariant.destructive:
        return colorScheme?.red;
    }
  }

  Color? _getHoverBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case PrimaryButtonVariant.main:
        return colorScheme?.primaryDark;
      case PrimaryButtonVariant.destructive:
        return colorScheme?.redDark;
    }
  }

  Color? _getDefaultBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case PrimaryButtonVariant.main:
        return colorScheme?.primary;
      case PrimaryButtonVariant.destructive:
        return colorScheme?.red;
    }
  }
}
