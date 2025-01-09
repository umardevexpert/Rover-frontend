import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:rover/account_settings/util/no_border_crop_path_painter.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/assets.dart';

class CropPreview extends StatelessWidget {
  final CustomImageCropController cropController;
  final Uint8List imageBytes;
  final ValueChanged<Uint8List?> onImageChanged;

  const CropPreview({super.key, required this.cropController, required this.imageBytes, required this.onImageChanged});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: STANDARD_BORDER_RADIUS,
      child: Stack(
        children: [
          CustomImageCrop(
            image: MemoryImage(imageBytes),
            cropPercentage: 0.9,
            overlayColor: Colors.black.withOpacity(0.3),
            cropController: cropController,
            drawPath: (path, {pathPaint}) => NoBorderCropPathPainter.drawPath(path),
          ),
          _buildCancelSelectionButton()
        ],
      ),
    );
  }

  Widget _buildCancelSelectionButton() {
    return Positioned(
      top: SMALL_UI_GAP,
      right: SMALL_UI_GAP,
      child: InkWell(
        onTap: () => onImageChanged(null),
        child: Assets.svgImage(
          'icon/close',
          color: Colors.white,
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}
