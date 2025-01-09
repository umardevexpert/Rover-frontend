import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class AuthPageBodyTemplate extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;

  const AuthPageBodyTemplate({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    return SizedBox.expand(
      child: Material(
        color: theme.colorScheme.background,
        child: Center(
          child: SizedBox(
            width: 384,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: appTheme?.textTheme.headingH1),
                SMALL_GAP,
                Text(subtitle, style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey600)),
                LARGER_GAP,
                content,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
