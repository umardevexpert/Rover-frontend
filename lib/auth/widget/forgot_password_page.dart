import 'package:flutter/material.dart';
import 'package:rover/auth/widget/auth_page_body_template.dart';
import 'package:rover/auth/widget/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageBodyTemplate(
      title: 'Reset password',
      subtitle: 'Type in your email and we will send you instructions on how to reset your password.',
      content: ForgotPasswordForm(),
    );
  }
}
