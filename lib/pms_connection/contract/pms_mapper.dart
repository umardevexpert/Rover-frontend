import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/tooth_initials.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient/model/treatment_plan.dart';

abstract interface class PMSMapper<TPatient, TAppointment, TTreatmentPlan, TTreatment, TToothInitials> {
  Patient mapPatient(TPatient input);

  Appointment mapAppointment(TAppointment input);

  TreatmentPlan mapTreatmentPlan(TTreatmentPlan input);

  Treatment mapTreatment(TTreatment input);

  ToothInitials mapToothInitials(TToothInitials input);
}
