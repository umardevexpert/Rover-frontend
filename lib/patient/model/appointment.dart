import 'package:rover/patient/model/appointment_status.dart';

class Appointment {
  final String id;
  final String patientId;
  final DateTime date;
  final AppointmentStatus status;
  final String? doctorAbbreviation;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.date,
    required this.status,
    required this.doctorAbbreviation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Appointment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          patientId == other.patientId &&
          date == other.date &&
          status == other.status &&
          doctorAbbreviation == other.doctorAbbreviation;

  @override
  int get hashCode => id.hashCode ^ patientId.hashCode ^ date.hashCode ^ status.hashCode ^ doctorAbbreviation.hashCode;

  Appointment copyWith({
    String? id,
    String? patientId,
    DateTime? date,
    AppointmentStatus? status,
    String? doctorAbbreviation,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      status: status ?? this.status,
      doctorAbbreviation: doctorAbbreviation ?? this.doctorAbbreviation,
    );
  }
}
