import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/labeled.dart';

class CurrentUserInfoForm extends StatelessWidget {
  const CurrentUserInfoForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Labeled(
                label: 'First Name',
                child: TextField(),
              ),
            ),
            SizedBox(width: 60),
            Expanded(
              child: Labeled(
                label: 'Last Name',
                child: TextField(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
        Row(
          children: const [
            Expanded(
              child: Labeled(
                label: 'Phone Number',
                child: TextField(),
              ),
            ),
            SizedBox(width: 60),
            Spacer(),
          ],
        ),
        LARGE_GAP,
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Save & Update'),
          ),
        ),
      ],
    );
  }
}
