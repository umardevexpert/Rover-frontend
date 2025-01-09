import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';

class ConnectionFailedBody extends StatelessWidget {
  const ConnectionFailedBody({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Connection failed',
            style: appTheme?.textTheme.titleXL.copyWith(color: appTheme.colorScheme.grey900),
          ),
          SizedBox(height: 16),
          Text(
            'Problems connecting to the server. Please contact your administrator.',
            textAlign: TextAlign.center,
            style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
          ),
        ],
      ),
    );
  }
}
