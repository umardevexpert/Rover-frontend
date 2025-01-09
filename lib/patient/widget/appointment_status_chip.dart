import 'package:flutter/material.dart';
import 'package:rover/common/widget/rover_chip.dart';
import 'package:rover/patient/model/appointment_status.dart';

class AppointmentStatusChip extends StatelessWidget {
  final AppointmentStatus status;

  const AppointmentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return RoverChip(
      showDecorationDot: true,
      color: _color,
      label: _label,
    );
  }

  RoverChipColor get _color {
    switch (status) {
      case AppointmentStatus.next:
        return RoverChipColor.golden;
      case AppointmentStatus.current:
        return RoverChipColor.darkBlue;
      case AppointmentStatus.upcoming:
        return RoverChipColor.lightBlue;
      case AppointmentStatus.finished:
        return RoverChipColor.grey;
      case AppointmentStatus.recentlyFinished:
        return RoverChipColor.grey;
    }
  }

  String get _label {
    switch (status) {
      case AppointmentStatus.current:
        return 'Current patient';
      case AppointmentStatus.next:
        return 'Next patient';
      case AppointmentStatus.upcoming:
        return 'Upcoming';
      case AppointmentStatus.finished:
        return 'Finished';
      case AppointmentStatus.recentlyFinished:
        return 'Recently finished';
    }
  }
}
