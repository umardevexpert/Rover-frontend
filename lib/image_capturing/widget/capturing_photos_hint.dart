import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_alert.dart';

class CapturingPhotosHint extends StatelessWidget {
  final VoidCallback onClose;

  const CapturingPhotosHint({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SMALL_UI_GAP),
      child: RoverAlert(
        variant: RoverAlertVariant.info,
        onClosePressed: onClose,
        title: 'How it works?',
        content:
            '1. select which teeth you want to photograph in the diagram below and then take a photo\n2. or take photo and then select which teeth your photo relates to.\nAll photos taken with the Intraoral camera will appear here automatically.',
      ),
    );
  }
}
