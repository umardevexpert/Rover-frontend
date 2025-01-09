import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

enum SecondaryButtonSize { small, medium, large }

enum SecondaryButtonVariant { fill, outline, destructive }

class SecondaryButton extends StatelessWidget {
  final SecondaryButtonSize size;
  final SecondaryButtonVariant variant;
  final ButtonStyle? buttonStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget child;

  const SecondaryButton({
    super.key,
    this.size = SecondaryButtonSize.medium,
    this.variant = SecondaryButtonVariant.outline,
    this.buttonStyle,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    final colorScheme = appTheme?.colorScheme;

    final defaultButtonStyle = theme.outlinedButtonTheme.style?.copyWith(
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
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return colorScheme?.grey600;
          }
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }
          return _getDefaultForegroundColor(colorScheme);
        },
      ),
      side: MaterialStateProperty.resolveWith(
        (states) => BorderSide(color: _getBorderColor(colorScheme, states) ?? Colors.black),
      ),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0))),
    );

    return OutlinedButton(
      style: buttonStyle?.merge(defaultButtonStyle) ?? defaultButtonStyle,
      onPressed: (isLoading || !enabled) ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: colorScheme?.primary, strokeWidth: 3),
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
      case SecondaryButtonSize.large:
        return MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0));
      case SecondaryButtonSize.medium:
        return null;
      case SecondaryButtonSize.small:
        return MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0));
    }
  }

  Color? _getPressedBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.fill:
        return colorScheme?.primary;
      case SecondaryButtonVariant.destructive:
        return colorScheme?.red;
    }
  }

  Color? _getHoverBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.fill:
        return colorScheme?.primaryLight;
      case SecondaryButtonVariant.destructive:
        return colorScheme?.redLight;
    }
  }

  Color? _getDefaultBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.destructive:
        return Colors.white;
      case SecondaryButtonVariant.fill:
        return colorScheme?.primaryLight;
    }
  }

  Color? _getDefaultForegroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.fill:
        return colorScheme?.primary;
      case SecondaryButtonVariant.destructive:
        return colorScheme?.red;
    }
  }

  Color? _getDisabledBorderColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.destructive:
        return colorScheme?.grey300;
      case SecondaryButtonVariant.fill:
        return colorScheme?.grey200;
    }
  }

  Color? _getPressedBorderColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.fill:
        return colorScheme?.primary;
      case SecondaryButtonVariant.destructive:
        return colorScheme?.red;
    }
  }

  Color? _getHoverBorderColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
        return colorScheme?.primaryLight;
      case SecondaryButtonVariant.fill:
        return colorScheme?.primary;
      case SecondaryButtonVariant.destructive:
        return colorScheme?.redLight;
    }
  }

  Color? _getDefaultBorderColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case SecondaryButtonVariant.outline:
      case SecondaryButtonVariant.destructive:
        return colorScheme?.grey300;
      case SecondaryButtonVariant.fill:
        return colorScheme?.primaryLight;
    }
  }

  Color? _getBorderColor(RoverColorScheme? colorScheme, Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return _getDisabledBorderColor(colorScheme);
    }
    if (states.contains(MaterialState.pressed)) {
      return _getPressedBorderColor(colorScheme);
    }
    if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
      return _getHoverBorderColor(colorScheme);
    }
    return _getDefaultBorderColor(colorScheme);
  }
}
