import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/gradient_background.dart';
import 'package:rover/patient/widget/filter_settings_row.dart';

// 48 (input size) + 24 (gap below)
const _FILTER_SETTINGS_HEADER_SIZE = 72.0;

class FilterSettingsPersistentHeader extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => _FILTER_SETTINGS_HEADER_SIZE;

  @override
  double get minExtent => _FILTER_SETTINGS_HEADER_SIZE;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        if (overlapsContent) GradientBackground(clipTop: 246, height: _FILTER_SETTINGS_HEADER_SIZE),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: STANDARD_INPUT_HEIGHT,
            child: Padding(
              padding: PAGE_HORIZONTAL_PADDING,
              child: FilterSettingsRow(),
            ),
          ),
        ),
      ],
    );
  }
}
