import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/user_avatar.dart';
import 'package:rover/patient/extension/gender_extension.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:ui_kit/util/assets.dart';

class PatientInfo extends StatelessWidget {
  final Patient patient;

  const PatientInfo({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Row(
      children: [
        UserAvatar(name: patient.firstName, surname: patient.lastName, size: 92),
        STANDARD_GAP,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(patient.fullName, style: appTheme?.textTheme.titleXL),
                _buildSeparationDot(appTheme, gapSize: 4),
                Text(
                  patient.gender.label,
                  style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildIconWithLabel(
                  appTheme: appTheme,
                  iconPath: 'bday_cake',
                  label: '${AgeCalculator.age(patient.dayOfBirth).years} yo',
                ),
                _buildSeparationDot(appTheme, gapSize: 6),
                Text(
                  DateFormat(SHORT_DATE).format(patient.dayOfBirth),
                  style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600),
                )
              ],
            ),
            SMALLER_GAP,
            Row(
              children: [
                _buildIconWithLabel(
                  appTheme: appTheme,
                  iconPath: 'phone',
                  label: patient.phoneNumber ?? 'No phone number',
                ),
                SMALL_GAP,
                _buildIconWithLabel(appTheme: appTheme, iconPath: 'email', label: patient.email ?? 'No e-mail'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeparationDot(AppTheme? appTheme, {required double gapSize}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gapSize),
      child: Text(
        '•',
        style: GoogleFonts.inter(
          color: appTheme?.colorScheme.grey600,
          fontSize: 12,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildIconWithLabel({required AppTheme? appTheme, required String iconPath, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.svgImage(
          'icon/$iconPath',
          width: 20,
          height: 20,
          color: appTheme?.colorScheme.grey500,
        ),
        SMALLER_GAP,
        Text(
          label,
          style: appTheme?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500, height: 1.25),
        )
      ],
    );
  }
}
