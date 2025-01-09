import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/patient_detail/model/presentation.dart';
import 'package:rover/patient_detail/widget/presentation_card.dart';
import 'package:ui_kit/util/assets.dart';

class PresentationsSection extends StatelessWidget {
  final List<Presentation> presentations;
  const PresentationsSection({super.key, required this.presentations});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    if (presentations.isEmpty) {
      return _buildEmptyPresentationPage(appTheme);
    }

    return SizedBox.expand(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: LARGER_UI_GAP),
        child: Wrap(
          spacing: STANDARD_UI_GAP,
          runSpacing: STANDARD_UI_GAP,
          children: presentations.map((presentation) => PresentationCard(presentation: presentation)).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyPresentationPage(AppTheme? appTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LARGER_UI_GAP),
      child: SizedBox.expand(
        child: RoverCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.svgImage('no_images', width: 232, height: 152),
              const SizedBox(height: 20),
              Text(
                "You haven't sent any presentations yet",
                style: appTheme?.textTheme.bodyL.copyWith(color: appTheme.colorScheme.grey700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
