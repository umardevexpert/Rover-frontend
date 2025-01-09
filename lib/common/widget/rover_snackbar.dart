import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/extension/rover_color_scheme_extension.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/assets.dart';

enum RoverSnackbarVariant { error, info, neutral, warning, success }

class RoverSnackbar extends StatelessWidget {
  final RoverSnackbarVariant variant;
  final Consumer<BuildContext>? onClosePressed;
  final String? title;
  final String? content;

  const RoverSnackbar({
    super.key,
    this.variant = RoverSnackbarVariant.neutral,
    required this.onClosePressed,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final colorScheme = appTheme?.colorScheme;

    const closeButtonSize = 20.0;

    final accentColor = _getAccentColor(colorScheme);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: accentColor ?? Colors.white, width: 4)),
        boxShadow: const [BoxShadow(color: Color(0x38888D95), blurRadius: 5, offset: Offset(0, 3))],
      ),
      padding: const EdgeInsets.only(top: SMALL_UI_GAP, bottom: SMALL_UI_GAP, left: SMALL_UI_GAP, right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.svgImage(_iconPath, color: accentColor),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(title!, style: appTheme?.textTheme.titleL),
                ),
              if (title != null && content != null) const SizedBox(height: 2),
              if (content != null)
                Text(
                  content!,
                  style: appTheme?.textTheme.bodyM.copyWith(color: colorScheme?.grey700),
                ),
            ],
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
              onPressed: onClosePressed == null ? null : () => onClosePressed!(context),
              icon: Assets.svgImage('icon/close'),
              color: colorScheme?.grey600,
            )
          else
            const SizedBox.square(dimension: closeButtonSize),
        ],
      ),
    );
  }

  String get _iconPath {
    switch (variant) {
      case RoverSnackbarVariant.error:
      case RoverSnackbarVariant.warning:
        return 'icon/warning';
      case RoverSnackbarVariant.info:
      case RoverSnackbarVariant.neutral:
        return 'icon/info';
      case RoverSnackbarVariant.success:
        return 'icon/success';
    }
  }

  Color? _getAccentColor(RoverColorScheme? colorScheme) {
    switch (variant) {
      case RoverSnackbarVariant.error:
        return colorScheme?.red;
      case RoverSnackbarVariant.warning:
        return colorScheme?.yellow;
      case RoverSnackbarVariant.info:
        return colorScheme?.blue;
      case RoverSnackbarVariant.neutral:
        return colorScheme?.grey600;
      case RoverSnackbarVariant.success:
        return colorScheme?.green;
    }
  }
}
