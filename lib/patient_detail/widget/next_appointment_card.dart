import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/assets.dart';

class NextAppointmentCard extends StatelessWidget {
  final DateTime date;

  const NextAppointmentCard({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: appTheme?.colorScheme.grey100,
        borderRadius: STANDARD_BORDER_RADIUS,
      ),
      padding: const EdgeInsets.symmetric(horizontal: STANDARD_UI_GAP, vertical: SMALL_UI_GAP),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next appointment',
            style: appTheme?.textTheme.bodyS.copyWith(
              fontWeight: FontWeight.w500,
              color: appTheme.colorScheme.grey600,
            ),
          ),
          SMALL_GAP,
          Row(
            children: [
              Assets.svgImage('icon/calendar', width: 20, height: 20),
              SMALL_GAP,
              Text(
                DateFormat(MEDIUM_DATE_WITH_DAY).format(date),
                style: appTheme?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
