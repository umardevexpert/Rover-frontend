import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:ui_kit/util/assets.dart';

class PasswordValidationPopup extends StatelessWidget {
  final String password;

  const PasswordValidationPopup({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      height: 134,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.pngAssetImage('password_strength_popup'),
          alignment: Alignment.topLeft,
          fit: BoxFit.none,
        ),
      ),
      clipBehavior: Clip.none,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 13, top: 2, bottom: 8, right: 5),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            (isSatisfied: password.length >= 8, text: 'At least 8 characters in length'),
            (isSatisfied: RegExp('[a-z]').hasMatch(password), text: 'Lower case letters (a-z)'),
            (isSatisfied: RegExp('[A-Z]').hasMatch(password), text: 'Upper case letters (A-Z)'),
            (isSatisfied: RegExp('[0-9]').hasMatch(password), text: 'Number (i.e. 0-9)'),
          ]
              .map<Widget>(
                (condition) => Row(
                  children: [
                    Assets.svgImage(
                      'icon/${condition.isSatisfied ? 'success' : 'failure'}',
                      color: condition.isSatisfied ? Color(0xFF0FA760) : Color(0xFFE95959),
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      condition.text,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Color(0xFF6C757D)),
                    ),
                  ],
                ),
              )
              .intersperse(const SizedBox(height: 4))
              .toList(),
        ),
      ),
    );
  }
}
