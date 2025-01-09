import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/image_capturing/model/dialog_event.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/image_capturing/service/intra_oral_camera_button_press_service.dart';
import 'package:rover/image_capturing/widget/image_capture_dialog.dart';
import 'package:rover/patient/model/patient.dart';

const _DOUBLE_CLICK_THRESHOLD = 300;
const _CAMERA_BUTTON_KEY = LogicalKeyboardKey.keyG;

class CameraListenerWrapper extends StatefulWidget {
  final Widget child;
  final Patient patient;

  const CameraListenerWrapper({super.key, required this.child, required this.patient});

  @override
  State<CameraListenerWrapper> createState() => _CameraListenerWrapperState();
}

class _CameraListenerWrapperState extends State<CameraListenerWrapper> {
  final _cameraButtonService = get<IntraOralCameraButtonPressService>();
  final _dialogController = get<ImageCaptureDialogController>();
  late final StreamSubscription<DialogEvent> _streamSubscription;
  BuildContext? _dialogContext;

  Timer? _clickTimer;
  bool _doubleClickDetected = false;

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);

    _streamSubscription = _cameraButtonService.dialogOpenStream.listen((dialogEvent) {
      _dialogController.patient = widget.patient;
      if (dialogEvent.isOpen) {
        showDialog<void>(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            _dialogContext = context;
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ImageCaptureDialog(),
              ),
            );
          },
        );
      } else {
        if (_dialogContext != null) {
          Navigator.of(_dialogContext!).pop();
          _dialogContext = null;
        }
      }
    });
  }

  @override
  void dispose() {
    _clickTimer?.cancel();
    super.dispose();
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  bool _onKey(KeyEvent event) {
    if (event.logicalKey == _CAMERA_BUTTON_KEY && event is KeyDownEvent) {
      if (_clickTimer != null && _clickTimer!.isActive) {
        _clickTimer!.cancel();
        _doubleClickDetected = true;
        _cameraButtonService.doubleClick();
      } else {
        _doubleClickDetected = false;
        _clickTimer = Timer(Duration(milliseconds: _DOUBLE_CLICK_THRESHOLD), () {
          if (!_doubleClickDetected) {
            _cameraButtonService.singleClick();
          }
        });
      }
    }

    return false;
  }
}
