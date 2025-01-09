import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_dialog.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:rover/patient/service/patients_page_controller.dart';
import 'package:ui_kit/util/assets.dart';

const _ICON_SIZE = 64.0;

class ConfirmLogoutDialog extends StatelessWidget {
  final _authService = get<UserAuthService>();
  final _patientsPageController = get<PatientsPageController>();

  ConfirmLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return RoverDialog(
      width: 416,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _ICON_SIZE,
            height: _ICON_SIZE,
            decoration: BoxDecoration(color: appTheme?.colorScheme.primaryLight, shape: BoxShape.circle),
            child: Assets.svgImage('icon/logout', width: 24, height: 24, color: appTheme?.colorScheme.primary),
          ),
          LARGE_GAP,
          Text('Log out', style: appTheme?.textTheme.titleXL),
          SMALLER_GAP,
          Text(
            'Are you sure you want to log out?',
            style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: TertiaryButton(
              size: TertiaryButtonSize.large,
              onPressed: context.pop,
              child: Text('Cancel'),
            ),
          ),
          STANDARD_GAP,
          Expanded(
            child: PrimaryButton(
              onPressed: () {
                _patientsPageController.resetAllData();
                _authService.signOut();
              },
              child: Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }
}
