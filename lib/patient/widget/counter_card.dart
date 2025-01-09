import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/rover_card.dart';

class CounterCard extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;

  const CounterCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Expanded(
      child: RoverCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey800)),
                IconTheme(
                  data: IconThemeData(color: appTheme?.colorScheme.colorScale3, size: 24),
                  child: icon,
                ),
              ],
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 29,
                height: 1.5,
                color: appTheme?.colorScheme.grey900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
