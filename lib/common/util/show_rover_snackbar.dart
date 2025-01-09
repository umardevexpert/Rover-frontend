import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_snackbar.dart';

OverlaySupportEntry showRoverSnackbar({
  RoverSnackbarVariant variant = RoverSnackbarVariant.neutral,
  required Consumer<BuildContext>? onClosePressed,
  String? title,
  String? content,
  Duration duration = const Duration(seconds: 5),
}) {
  return showOverlay(
    (context, progress) => Align(
      alignment: Alignment.topRight,
      child: FractionalTranslation(
        translation: Offset.lerp(const Offset(1, 0), Offset.zero, progress)!,
        child: Padding(
          padding: const EdgeInsets.only(top: NAVIGATION_BAR_HEIGHT + 5, right: STANDARD_UI_GAP),
          child: Material(
            color: Colors.transparent,
            child: RoverSnackbar(
              variant: variant,
              onClosePressed: onClosePressed,
              title: title,
              content: content,
            ),
          ),
        ),
      ),
    ),
    duration: duration,
  );
}

OverlaySupportEntry showErrorSnackbarWithClose({
  String? title,
  String? content,
  Duration duration = const Duration(seconds: 5),
}) {
  return showRoverSnackbar(
    title: title,
    content: content,
    duration: duration,
    variant: RoverSnackbarVariant.error,
    onClosePressed: (context) => OverlaySupportEntry.of(context)?.dismiss(),
  );
}
