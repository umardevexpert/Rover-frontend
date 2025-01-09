import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:ui_kit/util/assets.dart';

class ImageUploadDragAndDropArea extends StatelessWidget {
  final ValueChanged<Uint8List> onImagePicked;

  const ImageUploadDragAndDropArea({super.key, required this.onImagePicked});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return DropTarget(
      onDragDone: (dropDetails) async {
        final files = dropDetails.files;
        if (files.length != 1) {
          return;
        }
        final file = files.first;
        if (!['.png', '.jpg', '.jpeg'].any(file.name.endsWith)) {
          return;
        }
        final bytes = await file.readAsBytes();
        onImagePicked(bytes);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: appTheme?.colorScheme.grey100, borderRadius: STANDARD_BORDER_RADIUS),
        child: DecoratedBox(
          decoration: DottedDecoration(
            shape: Shape.box,
            color: appTheme?.colorScheme.grey400 ?? Colors.black,
            borderRadius: STANDARD_BORDER_RADIUS,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Drag & drop files to upload',
                style: appTheme?.textTheme.bodyXL.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SMALLER_GAP,
              Text(
                'Supports PNG, JPEG',
                style: appTheme?.textTheme.bodyM.copyWith(color: appTheme.colorScheme.grey700),
              ),
              LARGER_GAP,
              SecondaryButton(
                onPressed: () async {
                  final filePickResult = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.image,
                    withData: true,
                    allowedExtensions: ['jpg', 'jpeg', 'png'],
                  );
                  if (filePickResult == null) {
                    return;
                  }
                  final file = filePickResult.files.first;
                  onImagePicked(file.bytes!);
                },
                prefixIcon: Assets.svgImage('icon/image'),
                child: Text('Browse file'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
