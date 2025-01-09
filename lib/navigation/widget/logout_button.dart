import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/confirm_logout_dialog.dart';
import 'package:ui_kit/util/assets.dart';

const _BUTTON_SIZE = 44.0;

class LogoutButton extends StatelessWidget {
  LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return InkWell(
      onTap: () => _showLogoutPopup(context),
      child: Container(
        width: _BUTTON_SIZE,
        height: _BUTTON_SIZE,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), shape: BoxShape.circle),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Assets.svgImage('icon/logout', color: appTheme?.colorScheme.grey900),
        ),
      ),
    );
  }

  Future<void> _showLogoutPopup(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => ConfirmLogoutDialog(),
    );
  }
}
