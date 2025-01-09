import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_alert.dart';
import 'package:rover/common/widget/rover_dialog.dart';
import 'package:rover/common/widget/tertiary_button.dart';

class TemporaryPasswordPopup extends StatelessWidget {
  final String password;

  const TemporaryPasswordPopup({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return RoverDialog(
      width: 416,
      title: 'Password',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoverAlert(
            variant: RoverAlertVariant.warning,
            onClosePressed: null,
            title: 'Warning!',
            content:
                'This is a temporary password. The password will only be displayed once. You can send this password to the user by email or hand it to them in person.',
          ),
          SMALL_GAP,
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Material(
              type: MaterialType.transparency, //To show the splash
              child: InkWell(
                onTap: _copyPassword,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: SMALL_UI_GAP, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: appTheme?.colorScheme.grey400 ?? Colors.black),
                    borderRadius: STANDARD_BORDER_RADIUS,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 56),
                      const Spacer(),
                      SelectableText(password, style: appTheme?.textTheme.titleXL),
                      const Spacer(),
                      IconButton(onPressed: null, icon: Icon(Icons.copy))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: TertiaryButton(
              size: TertiaryButtonSize.large,
              onPressed: () => context.pop(),
              child: Text('Close'),
            ),
          ),
          STANDARD_GAP,
          PrimaryButton(onPressed: () {}, child: Text('Send to the user')),
        ],
      ),
    );
  }

  void _copyPassword() => FlutterClipboard.copy(password);
}
