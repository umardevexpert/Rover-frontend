import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class PatientPhoneCell extends StatelessWidget {
  final String? phone;

  const PatientPhoneCell({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    return Text(phone ?? '-', style: AppTheme.of(context)?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500));
  }
}
