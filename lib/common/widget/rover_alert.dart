import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/assets.dart';

enum RoverAlertVariant { error, info, neutral, warning, success }

class RoverAlert extends StatelessWidget {
  final RoverAlertVariant variant;
  final VoidCallback? onClosePressed;
  final String? title;
  final String content;

  const RoverAlert({
    super.key,
    this.variant = RoverAlertVariant.neutral,
    required this.onClosePressed,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final colorScheme = appTheme?.colorScheme;

    const closeButtonSize = 20.0;

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(colorScheme),
        borderRadius: STANDARD_BORDER_RADIUS,
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.svgImage(_iconPath, color: _getIconColor(colorScheme)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(title!, style: appTheme?.textTheme.titleL),
                  ),
                Text(
                  content,
                  style: appTheme?.textTheme.bodyM.copyWith(color: colorScheme?.grey700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (onClosePressed != null)
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size.zero),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                fixedSize: MaterialStateProperty.all(Size(closeButtonSize, closeButtonSize)),
              ),
              onPressed: onClosePressed,
              icon: Assets.svgImage('icon/close'),
              color: colorScheme?.grey600,
            )
          else
            const SizedBox.square(dimension: closeButtonSize),
        ],
      ),
    );
  }

  Color? _getBackgroundColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case RoverAlertVariant.error:
        return colorScheme?.redLight;
      case RoverAlertVariant.warning:
        return colorScheme?.yellowLight;
      case RoverAlertVariant.info:
        return colorScheme?.blueLight;
      case RoverAlertVariant.neutral:
        return colorScheme?.grey100;
      case RoverAlertVariant.success:
        return colorScheme?.greenLight;
    }
  }

  String get _iconPath {
    switch (variant) {
      case RoverAlertVariant.error:
      case RoverAlertVariant.warning:
        return 'icon/warning';
      case RoverAlertVariant.info:
      case RoverAlertVariant.neutral:
        return 'icon/info';
      case RoverAlertVariant.success:
        return 'icon/success';
    }
  }

  Color? _getIconColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case RoverAlertVariant.error:
        return colorScheme?.red;
      case RoverAlertVariant.warning:
        return colorScheme?.yellow;
      case RoverAlertVariant.info:
        return colorScheme?.blue;
      case RoverAlertVariant.neutral:
        return colorScheme?.grey600;
      case RoverAlertVariant.success:
        return colorScheme?.green;
    }
  }
}
