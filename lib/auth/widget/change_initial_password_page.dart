import 'package:flutter/material.dart';
import 'package:rover/auth/widget/auth_page_body_template.dart';
import 'package:rover/auth/widget/change_initial_password_form.dart';

class ChangeInitialPasswordPage extends StatelessWidget {
  final String oldPassword;

  const ChangeInitialPasswordPage({super.key, required this.oldPassword});

  @override
  Widget build(BuildContext context) {
    return AuthPageBodyTemplate(
      title: 'Create new password',
      subtitle: 'Create a new password for your account',
      content: ChangeInitialPasswordForm(oldPassword: oldPassword),
    );
  }
}
