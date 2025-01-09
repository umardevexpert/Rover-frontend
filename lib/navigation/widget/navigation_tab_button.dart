import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/navigation/model/navigation_tab_definition.dart';

class NavigationTabButton extends StatelessWidget {
  final NavigationTabDefinition tab;

  const NavigationTabButton({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final isSelected = GoRouter.of(context).routeInformationProvider.value.location?.startsWith(tab.route) ?? false;

    return InkWell(
      onTap: () => context.go(tab.route),
      borderRadius: SMALLER_BORDER_RADIUS,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: SMALLER_BORDER_RADIUS,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: appTheme?.textTheme.titleL.copyWith(color: isSelected ? appTheme.colorScheme.primary : null) ??
              TextStyle(),
          child: Text(
            tab.label,
            textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
          ),
        ),
      ),
    );
  }
}
