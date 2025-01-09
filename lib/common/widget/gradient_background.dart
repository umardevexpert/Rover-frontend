import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:ui_kit/util/assets.dart';

const _GRADIENT_SIZE = 310.0;

class GradientBackground extends StatelessWidget {
  final double clipTop;
  final double height;

  const GradientBackground({super.key, this.clipTop = 0, this.height = _GRADIENT_SIZE});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constrains) {
        return Container(
          width: constrains.maxWidth,
          height: height,
          decoration: BoxDecoration(color: appTheme?.colorScheme.grey100),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                top: -clipTop,
                child: SizedBox(
                  width: constrains.maxWidth,
                  height: _GRADIENT_SIZE,
                  child: Assets.pngImage(
                    'nav_bar_background',
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomRight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
