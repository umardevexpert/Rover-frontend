import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/appointment_status.dart';
import 'package:rover/patient/model/patient.dart';

class PatientsAppointment {
  final Patient patient;
  final Appointment appointment;

  const PatientsAppointment({required this.patient, required this.appointment});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PatientsAppointment &&
              runtimeType == other.runtimeType &&
              patient == other.patient &&
              appointment == other.appointment;

  @override
  int get hashCode => patient.hashCode ^ appointment.hashCode;

  PatientsAppointment changeStatus(AppointmentStatus status) =>
      copyWith(appointment: appointment.copyWith(status: status));

  PatientsAppointment copyWith({
    Patient? patient,
    Appointment? appointment,
  }) {
    return PatientsAppointment(
      patient: patient ?? this.patient,
      appointment: appointment ?? this.appointment,
    );
  }
}
