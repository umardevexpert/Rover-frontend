import 'dart:async';

import 'package:rover/image_capturing/model/dialog_event.dart';
import 'package:rover/image_capturing/model/teeth_selection_mode.dart';
import 'package:rover/image_capturing/service/audio_player_controller.dart';
import 'package:rover/image_capturing/service/image_capture_dialog_controller.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rxdart/rxdart.dart';

class IntraOralCameraButtonPressService {
  final _buttonPressedStreamController = PublishSubject<DateTime>();
  final _dialogOpenStreamController = BehaviorSubject<DialogEvent>();
  final AudioPlayerController _audioPlayerController;
  final ImageCaptureDialogController _dialogController;

  IntraOralCameraButtonPressService(this._dialogController, this._audioPlayerController);

  Stream<DateTime> get buttonPressedStream => _buttonPressedStreamController.stream;

  Stream<DialogEvent> get dialogOpenStream => _dialogOpenStreamController.stream;

  void openImageCaptureDialog(Patient? patient) {
    _dialogOpenStreamController.add(OpenDialogEvent(patient));
  }

  void _tryOpenImageCaptureDialog(Patient? patient) {
    if (!_dialogOpenStreamController.hasValue || !_dialogOpenStreamController.value.isOpen) {
      openImageCaptureDialog(patient);
    }
  }

  void closeImageCaptureDialog() {
    _dialogController.resetStreams();
    _dialogOpenStreamController.add(CloseDialogEvent());
  }

  void singleClick() {
    _tryOpenImageCaptureDialog(null);
    _buttonPressedStreamController.add(DateTime.timestamp());
  }

  void doubleClick() {
    if (!_dialogOpenStreamController.hasValue || !_dialogOpenStreamController.value.isOpen) {
      _tryOpenImageCaptureDialog(null);
      return;
    }

    if (_dialogController.activeTeethSelectionMode == TeethSelectionMode.manual) {
      singleClick();
      return;
    }

    _dialogController.selectPreviousTeethBlock();
    _audioPlayerController.playBeep();
  }
}
