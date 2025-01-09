import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress}) : assert(progress >= 0 && progress <= 1);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return LayoutBuilder(
      builder: (context, constrains) {
        return Stack(
          children: [
            _buildTrack(width: constrains.maxWidth, color: appTheme?.colorScheme.grey200),
            _buildTrack(width: constrains.maxWidth * progress, color: appTheme?.colorScheme.secondary),
          ],
        );
      },
    );
  }

  Widget _buildTrack({required double width, required Color? color}) {
    return Container(
      width: width,
      height: 6,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: color,
      ),
    );
  }
}
