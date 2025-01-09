import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class GetHelpCard extends StatelessWidget {
  const GetHelpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(LARGE_UI_GAP),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: double.infinity,
            height: 102,
            child: Placeholder(),
          ),
          SizedBox(height: 45),
          Text('Need Help?'),
          SizedBox(height: 14),
          Text(
            'Please contact us if you need help or have questions about Rover at rover@supports.com, or  call +125 688 909 8545',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
