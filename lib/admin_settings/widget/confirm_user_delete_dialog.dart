import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_dialog.dart';
import 'package:rover/common/widget/rover_snackbar.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:ui_kit/util/assets.dart';

class ConfirmUserDeleteDialog extends StatefulWidget {
  final User user;

  const ConfirmUserDeleteDialog({super.key, required this.user});

  @override
  State<ConfirmUserDeleteDialog> createState() => _ConfirmUserDeleteDialogState();
}

class _ConfirmUserDeleteDialogState extends State<ConfirmUserDeleteDialog> {
  final _userRepository = get<CollectionWriter<User>>();
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return RoverDialog(
      width: 416,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme?.colorScheme.redLight),
            child: Assets.svgImage('icon/delete', color: appTheme?.colorScheme.red, width: 24, height: 24),
          ),
          LARGE_GAP,
          Text('Delete user?', style: appTheme?.textTheme.titleXL),
          SMALLER_GAP,
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
              children: [
                TextSpan(text: 'Are you sure you want to delete '),
                TextSpan(
                  text: '${widget.user.name} ${widget.user.surname}',
                  style: appTheme?.textTheme.bodyL.copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' permanently?'),
              ],
            ),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: TertiaryButton(
              size: TertiaryButtonSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No, Cancel'),
            ),
          ),
          STANDARD_GAP,
          Expanded(
            child: PrimaryButton(
              isLoading: _deleteInProgress,
              variant: PrimaryButtonVariant.destructive,
              onPressed: () async {
                setState(() => _deleteInProgress = true);
                await _userRepository.delete(widget.user.id);
                context
                  ..pop()
                  ..pop();
                showRoverSnackbar(
                  variant: RoverSnackbarVariant.success,
                  onClosePressed: (context) => OverlaySupportEntry.of(context)?.dismiss(),
                  title: 'User successfully deleted',
                );
              },
              child: Text('Yes, Delete'),
            ),
          ),
        ],
      ),
    );
  }
}
