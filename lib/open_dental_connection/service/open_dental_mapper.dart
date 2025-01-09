import 'package:rover/open_dental_connection/models/open_dental_appointment.dart';
import 'package:rover/open_dental_connection/models/open_dental_patient.dart';
import 'package:rover/open_dental_connection/models/open_dental_tooth_initials.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment_plan.dart';
import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/appointment_status.dart';
import 'package:rover/patient/model/gender.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/tooth_initials.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient/model/treatment_plan.dart';
import 'package:rover/pms_connection/contract/pms_mapper.dart';

class OpenDentalMapper
    implements
        PMSMapper<OpenDentalPatient, OpenDentalAppointment, OpenDentalTreatmentPlan, OpenDentalTreatment,
            OpenDentalToothInitials> {
  @override
  Patient mapPatient(OpenDentalPatient odPatient) => Patient(
        id: odPatient.id.toString(),
        firstName: odPatient.firstName,
        lastName: odPatient.lastName,
        gender: _parseGender(odPatient.gender),
        dayOfBirth: odPatient.dayOfBirth,
        phoneNumber: odPatient.wirelessPhoneNumber ?? odPatient.homePhoneNumber ?? odPatient.workPhoneNumber,
        email: odPatient.email,
        doctorAbbreviation: odPatient.providerAbbreviation,
      );

  @override
  Appointment mapAppointment(OpenDentalAppointment odAppointment) => Appointment(
        id: odAppointment.id.toString(),
        patientId: odAppointment.patientId.toString(),
        date: odAppointment.date,
        status: AppointmentStatus.upcoming,
        doctorAbbreviation: odAppointment.providerAbbreviation,
      );

  @override
  Treatment mapTreatment(OpenDentalTreatment odTreatment) => Treatment(
        id: odTreatment.id.toString(),
        toothNumber: odTreatment.toothNumber,
        adaCode: odTreatment.adaCode,
        toothSurface: odTreatment.toothSurface,
        description: odTreatment.description,
        date: odTreatment.date,
      );

  @override
  TreatmentPlan mapTreatmentPlan(OpenDentalTreatmentPlan odPlan) =>
      TreatmentPlan(id: odPlan.id.toString(), name: odPlan.name);

  @override
  ToothInitials mapToothInitials(OpenDentalToothInitials odToothInitials) => ToothInitials(
        toothInitialNum: odToothInitials.toothInitialNum,
        patientId: odToothInitials.patientId,
        toothNum: odToothInitials.toothNum,
        initialType: odToothInitials.initialType,
      );

  Gender _parseGender(String stringGender) => switch (stringGender) {
        'Male' => Gender.male,
        'Female' => Gender.female,
        'Other' => Gender.other,
        _ => Gender.unknown,
      };
}
