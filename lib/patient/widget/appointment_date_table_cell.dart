import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class AppointmentDateTableCell extends StatelessWidget {
  final DateTime? date;

  AppointmentDateTableCell({super.key, this.date});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final bodyM = appTheme?.textTheme.bodyM;

    // TODO(matej): Implement "Right now" & "Today" logic as in Figma
    if (date == null) {
      return Text('-', style: bodyM?.copyWith(fontWeight: FontWeight.w500));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat(MEDIUM_DATE_WITH_DAY).format(date!), style: bodyM?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(DateFormat(TIME_FORMAT).format(date!), style: bodyM?.copyWith(color: appTheme?.colorScheme.grey600)),
      ],
    );
  }
}
