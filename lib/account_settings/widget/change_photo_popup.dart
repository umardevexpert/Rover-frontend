import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:rover/account_settings/widget/crop_preview.dart';
import 'package:rover/account_settings/widget/image_upload_drag_and_drop_area.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/rover_dialog.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/common/widget/tertiary_button.dart';
import 'package:ui_kit/util/assets.dart';

class ChangePhotoPopup extends StatefulWidget {
  const ChangePhotoPopup({super.key});

  @override
  State<ChangePhotoPopup> createState() => _ChangePhotoPopupState();
}

class _ChangePhotoPopupState extends State<ChangePhotoPopup> {
  Uint8List? _selectedImage;
  final _cropController = CustomImageCropController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return RoverDialog(
      width: mediaQuery.size.width * 0.45,
      title: 'Change photo',
      subtitle: 'Some description goes here',
      content: SizedBox(
        width: double.infinity,
        height: 322,
        child: (_selectedImage == null)
            ? ImageUploadDragAndDropArea(
                onImagePicked: (image) => setState(() => _selectedImage = image),
              )
            : CropPreview(
                cropController: _cropController,
                imageBytes: _selectedImage!,
                onImageChanged: (image) => setState(() => _selectedImage = image),
              ),
      ),
      actions: Row(
        children: [
          if (_selectedImage != null) ...[
            SecondaryButton(
              onPressed: () => _cropController.addTransition(CropImageData(scale: 0.9)),
              child: Assets.svgImage('icon/circle_minus'),
            ),
            SMALLER_GAP,
            SecondaryButton(
              onPressed: () => _cropController.addTransition(CropImageData(scale: 1.1)),
              child: Assets.svgImage('icon/circle_plus'),
            ),
          ],
          const Spacer(),
          TertiaryButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          STANDARD_GAP,
          PrimaryButton(
            enabled: _selectedImage != null,
            onPressed: () async {
              final image = await _cropController.onCropImage();
              print('Cropped image result size is ${image?.bytes.lengthInBytes} bytes');
              // TODO upload the image maybe rescale?
            },
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
}
