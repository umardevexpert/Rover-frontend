import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/delete_button.dart';
import 'package:rover/common/widget/rover_card.dart';
import 'package:rover/image_capturing/model/rover_tooth_image.dart';

class ToothImagePreviewCard extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool> onSelected;
  final VoidCallback onDeletePressed;
  final Set<int>? capturedTeeth;
  final RoverToothImage imageFile;
  final DateTime? date;
  final BoxFit boxFit;
  final double cardWidth;
  final bool hasError;

  const ToothImagePreviewCard({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.onDeletePressed,
    required this.capturedTeeth,
    required this.imageFile,
    this.date,
    this.boxFit = BoxFit.cover,
    this.cardWidth = 323,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return InkWell(
      onTap: () => onSelected(!selected),
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: RoverCard(
        width: cardWidth,
        padding: EdgeInsets.all(selected ? 0 : 1),
        border: Border.all(
          color: _getColor(appTheme) ?? Colors.transparent,
          width: selected ? 2 : 1,
        ),
        child: Column(
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(SMALL_UI_GAP),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            capturedTeeth.isNullOrEmpty
                                ? 'No selected tooth'
                                : capturedTeeth!.sorted((a, b) => a.compareTo(b)).join(', '),
                            style: appTheme?.textTheme.titleL,
                          ),
                        ),
                        if (hasError) _buildErrorText(appTheme),
                        if (date != null) _buildDate(appTheme),
                      ],
                    ),
                  ),
                  DeleteButton(
                    onPressed: onDeletePressed,
                    padding: const EdgeInsets.all(SMALLER_UI_GAP),
                    size: 36,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getColor(AppTheme? appTheme) {
    if (selected) {
      return appTheme?.colorScheme.primary;
    }

    if (hasError) {
      return appTheme?.colorScheme.red;
    }

    return appTheme?.colorScheme.grey200;
  }

  Widget _buildErrorText(AppTheme? appTheme) {
    return Text(
      'Missing tooth number',
      style: appTheme?.textTheme.bodyS.copyWith(color: appTheme.colorScheme.red),
    );
  }

  SizedBox _buildImage() {
    // The images are taken in a 3:2 aspect ratio
    final height = cardWidth / 1.5;
    return SizedBox(
      width: cardWidth,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: SMALLER_CORNER_RADIUS, topRight: SMALLER_CORNER_RADIUS),
        child: Image.memory(imageFile.bytes, fit: boxFit),
      ),
    );
  }

  Padding _buildDate(AppTheme? appTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Text(
        DateFormat(SHORT_DATE).format(date!),
        style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey600),
      ),
    );
  }
}
