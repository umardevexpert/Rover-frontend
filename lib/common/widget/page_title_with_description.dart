import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/gradient_background.dart';

class PageTitleWithDescription extends StatelessWidget {
  final String title;
  final String description;
  final String? chipText;

  const PageTitleWithDescription({
    super.key,
    required this.title,
    required this.description,
    this.chipText,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Stack(
      children: [
        GradientBackground(clipTop: NAVIGATION_BAR_HEIGHT, height: 171),
        Padding(
          padding: PAGE_HORIZONTAL_PADDING,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 51),
                  Text(title, style: appTheme?.textTheme.headingHero),
                  const SizedBox(height: 4),
                  Text(description, style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700)),
                ],
              ),
              if (chipText != null)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: appTheme?.colorScheme.grey900.withOpacity(0.2) ?? Colors.black),
                    borderRadius: SMALLER_BORDER_RADIUS,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: Text(
                    chipText!,
                    style: appTheme?.textTheme.bodyS.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
