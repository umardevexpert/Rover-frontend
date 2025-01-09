import 'package:flutter/material.dart';
import 'package:rover/account_settings/widget/current_user_info_form.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class CurrentUserInfoCard extends StatelessWidget {
  const CurrentUserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 45.5, vertical: 43),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('User Info'),
          STANDARD_GAP,
          Text('Lorem ipsum dolor sit amet consectetur. Et nibh convallis ultrices urna laoreet elit quam.'),
          SizedBox(height: 31),
          CurrentUserInfoForm(),
          Divider(),
        ],
      ),
    );
  }
}
