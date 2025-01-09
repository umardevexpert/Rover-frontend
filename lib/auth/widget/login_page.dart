import 'package:flutter/material.dart';
import 'package:rover/auth/widget/auth_page_body_template.dart';
import 'package:rover/auth/widget/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPageBodyTemplate(
      title: 'Welcome!',
      subtitle: 'Please enter your details to continue',
      content: LoginForm(),
    );
  }
}
