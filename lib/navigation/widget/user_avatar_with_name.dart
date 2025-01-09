import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/user_avatar.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';

class UserAvatarWithName extends StatelessWidget {
  final User user;

  const UserAvatarWithName({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar(
          name: user.name,
          surname: user.surname,
          profilePictureUrl: user.pictureURL,
          size: 44,
          backgroundColor: Colors.white.withOpacity(0.6),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.name} ${user.surname.characters.first}.',
              style: appTheme?.textTheme.bodyL.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              user.role.label,
              style: appTheme?.textTheme.bodyS.copyWith(
                color: appTheme.colorScheme.grey700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }
}
