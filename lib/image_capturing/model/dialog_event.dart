import 'package:rover/patient/model/patient.dart';

sealed class DialogEvent {
  bool get isOpen;

  Patient? get patient;
}

class OpenDialogEvent implements DialogEvent {
  final Patient? _patient;

  OpenDialogEvent(this._patient);

  @override
  Patient? get patient => _patient;

  @override
  bool get isOpen => true;
}

class CloseDialogEvent implements DialogEvent {
  @override
  bool get isOpen => false;

  @override
  Patient? get patient => null;
}
