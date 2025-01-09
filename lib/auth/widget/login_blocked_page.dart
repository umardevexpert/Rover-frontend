import 'package:flutter/material.dart';
import 'package:rover/auth/widget/auth_page_body_template.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_alert.dart';

class LoginBlockedPage extends StatelessWidget {
  const LoginBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageBodyTemplate(
      title: 'Welcome!',
      subtitle: 'Please enter your details to continue',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoverAlert(
            onClosePressed: null,
            variant: RoverAlertVariant.error,
            title: 'Login failed!',
            content: 'You have made too many failed login attempts.\n\nRepeat after 15 minutes.',
          ),
          LARGER_GAP,
          PrimaryButton(
            size: PrimaryButtonSize.large,
            enabled: false,
            onPressed: () {},
            child: Text('Retry in 15 min'),
          ),
        ],
      ),
    );
  }
}
