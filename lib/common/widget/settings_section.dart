import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const SettingsSection({super.key, required this.title, required this.description, required this.child});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 321,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: appTheme?.textTheme.titleXL),
                  Text(
                    description,
                    style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(flex: 3, child: child),
      ],
    );
  }
}
