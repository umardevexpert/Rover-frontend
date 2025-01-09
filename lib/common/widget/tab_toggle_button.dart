import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class TabToggleButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPressed;
  final TabDefinition tab;

  const TabToggleButton({super.key, required this.isSelected, required this.onPressed, required this.tab});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final foregroundColor = isSelected ? appTheme?.colorScheme.primary : appTheme?.colorScheme.grey800;

    return InkWell(
      onTap: onPressed,
      canRequestFocus: false,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? appTheme?.colorScheme.primaryLight : null,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null)
              IconTheme(
                data: IconThemeData(
                  color: foregroundColor,
                  size: 20,
                ),
                child: Padding(padding: const EdgeInsets.only(right: SMALLER_UI_GAP), child: tab.icon),
              ),
            Text(
              tab.label,
              textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
              style: GoogleFonts.inter(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
