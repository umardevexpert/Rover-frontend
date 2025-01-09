import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class PersonNameAndEmailTableCell extends StatelessWidget {
  final String fullName;
  final String email;

  const PersonNameAndEmailTableCell({super.key, required this.fullName, required this.email});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(fullName, style: appTheme?.textTheme.titleL),
        const SizedBox(height: 2),
        Text(email, style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600)),
      ],
    );
  }
}
