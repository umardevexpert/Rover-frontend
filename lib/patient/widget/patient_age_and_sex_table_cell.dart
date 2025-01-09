import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/patient/extension/gender_extension.dart';
import 'package:rover/patient/model/gender.dart';

class PatientAgeAndSexTableCell extends StatelessWidget {
  final DateTime birthDate;
  final Gender gender;

  PatientAgeAndSexTableCell({super.key, required this.birthDate, required this.gender});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    final dateAndSexTextStyle = appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: <Widget>[
            Text(
              '${AgeCalculator.age(birthDate).years} yo',
              style: appTheme?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              '•',
              style: TextStyle(
                color: appTheme?.colorScheme.grey600,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            Text(DateFormat(SHORT_DATE).format(birthDate), style: dateAndSexTextStyle),
          ].intersperse(const SizedBox(width: 6)).toList(),
        ),
        const SizedBox(height: 2),
        Text(gender.label, style: dateAndSexTextStyle),
      ],
    );
  }
}
