import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/adaptive/widget/conditional_wrapper.dart';
import 'package:ui_kit/util/assets.dart';

class RoverDialog extends StatelessWidget {
  final double? width;
  final double? height;
  final bool expandContent;
  final String? title;
  final String? subtitle;
  final Widget content;
  final Widget actions;

  const RoverDialog({
    super.key,
    this.width,
    this.height,
    this.expandContent = false,
    this.title,
    this.subtitle,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          height: height,
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(vertical: LARGE_UI_GAP),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConditionalWrapper(
                wrapIf: expandContent,
                wrapperBuilder: (child) => Flexible(child: child),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LARGE_UI_GAP),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title != null) Text(title!, style: appTheme?.textTheme.titleXL),
                                if (subtitle != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      subtitle!,
                                      style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey700),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Assets.svgImage('icon/close'),
                          ),
                        ],
                      ),
                      SMALL_GAP,
                      Flexible(child: content),
                    ],
                  ),
                ),
              ),
              LARGE_GAP,
              Divider(height: 0),
              STANDARD_GAP,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LARGER_UI_GAP),
                child: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
