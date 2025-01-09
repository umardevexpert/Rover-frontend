import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/appointment_date_filter.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/tooth_initials.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient/model/treatment_plan.dart';

abstract interface class PMSConnectionService {
  Future<List<Patient>> getPatients();

  Future<List<Appointment>> getAppointments({AppointmentDateFilter? filter});

  Future<List<TreatmentPlan>> getTreatmentPlansByPatientId(String id);

  Future<List<Treatment>> getTreatmentsByTreatmentPlanId(String id);

  Future<List<ToothInitials>> getToothInitialsByPatientId(String id);
}
