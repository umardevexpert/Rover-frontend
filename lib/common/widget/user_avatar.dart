import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final String? profilePictureUrl;
  final String name;
  final String surname;

  const UserAvatar({
    super.key,
    this.size = 40.0,
    this.backgroundColor,
    this.textStyle,
    this.profilePictureUrl,
    required this.name,
    required this.surname,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? appTheme?.colorScheme.grey100,
      foregroundImage: (profilePictureUrl == null) ? null : NetworkImage(profilePictureUrl!),
      child: Text(
        '${name.characters.first.toUpperCase()}${surname.characters.first.toUpperCase()}',
        style: textStyle ?? appTheme?.textTheme.titleL.copyWith(color: appTheme.colorScheme.grey600),
      ),
    );
  }
}
