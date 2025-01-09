import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/gradient_background.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:ui_kit/util/assets.dart';

class PageTemplate extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final bool hasBackButton;
  final String? backButtonText;
  final Widget body;

  const PageTemplate({
    super.key,
    this.padding = PAGE_HORIZONTAL_PADDING,
    this.hasBackButton = false,
    this.backButtonText,
    required this.body,
  }) : assert(!hasBackButton || backButtonText != null);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: appTheme?.colorScheme.grey100,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: GradientBackground(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: NAVIGATION_BAR_HEIGHT),
            child: Column(
              children: [
                if (hasBackButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 32.0,
                        bottom: STANDARD_UI_GAP,
                        left: PAGE_HORIZONTAL_PADDING_SIZE,
                        right: PAGE_HORIZONTAL_PADDING_SIZE,
                      ),
                      child: TertiaryButton(
                        size: TertiaryButtonSize.large,
                        onPressed: () => GoRouter.of(context).pop(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.svgImage('icon/arrow_left', width: 24, height: 24),
                            SMALLER_GAP,
                            Text(backButtonText ?? 'Back'),
                          ],
                        ),
                      ),
                    ),
                  ),
                Flexible(
                  child: Padding(
                    padding: padding,
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
