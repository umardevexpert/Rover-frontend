import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class LargeDialogTemplate extends StatelessWidget {
  final String titleText;
  final Widget child;
  final List<Widget> buttons;

  const LargeDialogTemplate({
    super.key,
    required this.titleText,
    required this.child,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(appTheme),
          SizedBox(child: Divider(height: 0, thickness: 1)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: PAGE_HORIZONTAL_PADDING_SIZE),
              child: child,
            ),
          ),
          Divider(height: 0, thickness: 1),
          _buildActionButtons(buttons),
        ],
      ),
    );
  }

  Widget _buildTitle(AppTheme? appTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PAGE_HORIZONTAL_PADDING_SIZE, vertical: STANDARD_UI_GAP),
      child: Text(titleText, style: appTheme?.textTheme.titleXL),
    );
  }

  Widget _buildActionButtons(List<Widget> buttons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PAGE_HORIZONTAL_PADDING_SIZE, vertical: STANDARD_UI_GAP),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: buttons,
      ),
    );
  }
}
