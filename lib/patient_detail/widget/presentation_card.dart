import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/common/widget/rover_chip.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/patient_detail/model/presentation.dart';
import 'package:rover/patient_detail/widget/progress_bar.dart';
import 'package:ui_kit/util/assets.dart';

class PresentationCard extends StatelessWidget {
  final Presentation presentation;

  const PresentationCard({super.key, required this.presentation});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return RoverCard(
      width: 306,
      height: 307,
      padding: const EdgeInsets.all(STANDARD_UI_GAP),
      child: Column(
        children: [
          _buildImageWithChips(),
          const SizedBox(height: 12),
          _buildProgressText(appTheme),
          SMALLER_GAP,
          ProgressBar(progress: presentation.percentage / 100),
          STANDARD_GAP,
          _buildActionButtons()
        ],
      ),
    );
  }

  Widget _buildProgressText(AppTheme? appTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Treatment status:',
          style: appTheme?.textTheme.bodyS.copyWith(
            fontWeight: FontWeight.w500,
            color: appTheme.colorScheme.grey600,
          ),
        ),
        Text(
          '${presentation.percentage}%',
          style: appTheme?.textTheme.titleL.copyWith(
            fontWeight: FontWeight.w600,
            color: appTheme.colorScheme.grey900,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            size: SecondaryButtonSize.small,
            onPressed: () {},
            suffixIcon: Assets.svgImage('icon/send_message'),
            child: Text('Send'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PrimaryButton(
            size: PrimaryButtonSize.small,
            onPressed: () {},
            suffixIcon: Assets.svgImage('icon/arrow_right'),
            child: Text('Open'),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithChips() {
    return Container(
      width: double.infinity,
      height: 145,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/image/presentation_cover.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: STANDARD_BORDER_RADIUS,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RoverChip(color: RoverChipColor.darkBlue, label: presentation.status),
              SMALLER_GAP,
              RoverChip(color: RoverChipColor.darkBlue, label: DateFormat(SHORT_DATE).format(presentation.date)),
            ],
          ),
          RoverChip(color: RoverChipColor.golden, label: '${presentation.slidesCount} slides'),
        ],
      ),
    );
  }
}
