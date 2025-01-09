import 'dart:async';

import 'package:age_calculator/age_calculator.dart';
import 'package:master_kit/util/reference_wrapper.dart';
import 'package:rover/patient/model/age_range.dart';
import 'package:rover/patient/model/patient_filter.dart';
import 'package:rover/patient/model/patients_appointment.dart';
import 'package:rxdart/rxdart.dart';

const _FILTER_THROTTLE_DURATION = Duration(milliseconds: 200);

class PatientsFilteringService {
  final _filterController = BehaviorSubject.seeded(PatientFilter());

  Stream<List<PatientsAppointment>?> getFilteredPatientList({
    required Stream<List<PatientsAppointment>?> patientStream,
  }) {
    return _filterController.stream
        .throttleTime(_FILTER_THROTTLE_DURATION, trailing: true)
        // TODO(jirka): There is currently bug where the filter equality is same when different age range are picked
        // .distinct((previousFilter, currentFilter) => previousFilter == currentFilter)
        .switchMap(
          (filter) => patientStream.map(
            (patients) => patients?.where((patient) => _filterPatient(patient, filter)).toList(),
          ),
        );
  }

  void resetFilter() => _filterController.add(PatientFilter());

  void filterPatientsBySearchPhrase(String searchedPhrase) {
    _filterController.add(_filterController.value.copyWith(searchedPhrase: searchedPhrase.trim().toLowerCase()));
  }

  void filterPatientsByAppointmentDate({ReferenceWrapper<DateTime?>? from, ReferenceWrapper<DateTime?>? to}) {
    _filterController.add(_filterController.value.copyWith(fromAppointmentDate: from, toAppointmentDate: to));
  }

  void filterPatientsByAgeRange(Set<AgeRange> ageRanges) {
    _filterController.add(_filterController.value.copyWith(ageRanges: ageRanges));
  }

  bool _filterPatient(PatientsAppointment patientWithAppointment, PatientFilter filter) {
    final patient = patientWithAppointment.patient;
    final searchedPhrase = filter.searchedPhrase;
    final appointmentDate = patientWithAppointment.appointment.date;

    if (!(appointmentDate.isAfterOrEqual(filter.fromDate) && appointmentDate.isBeforeOrEqual(filter.toDate))) {
      return false;
    }

    if (!_patientIsWithinAgeRanges(filter.ageRanges, AgeCalculator.age(patient.dayOfBirth).years)) {
      return false;
    }

    if (searchedPhrase == '') {
      return true;
    }

    for (var i = 0; i < searchedPhrase.length; i++) {
      final character = searchedPhrase[i];

      if (character == '@') {
        return _patientEmailMatchesSearchPhrase(patient.email, searchedPhrase);
      }

      if (character == ' ') {
        return _patientNameMatchesSearchedPhrase(
          patient.firstNameInLowerCase,
          patient.lastNameInLowerCase,
          searchedPhrase,
        );
      }

      if (RegExp('[0-9]').hasMatch(character)) {
        return _patientPhoneMatchesSearchPhrase(patient.phoneNumber, searchedPhrase) ||
            _patientEmailMatchesSearchPhrase(patient.email, searchedPhrase);
      }
    }

    return _patientEmailMatchesSearchPhrase(patient.email, searchedPhrase) ||
        _patientNameMatchesSearchedPhrase(patient.firstNameInLowerCase, patient.lastNameInLowerCase, searchedPhrase);
  }

  bool _patientIsWithinAgeRanges(Set<AgeRange> ageRanges, int patientAge) {
    return ageRanges.isEmpty ||
        ageRanges.any(
          (ageRange) =>
              (ageRange.fromAge == null || patientAge >= ageRange.fromAge!) &&
              (ageRange.toAge == null || patientAge <= ageRange.toAge!),
        );
  }

  bool _patientNameMatchesSearchedPhrase(String firstName, String lastName, String searchedPhrase) {
    final searchedNames = searchedPhrase.split(' ');

    if (searchedNames.length == 1) {
      return firstName.startsWith(searchedNames[0]) || lastName.startsWith(searchedNames[0]);
    }

    return (firstName.startsWith(searchedNames[0]) && lastName.startsWith(searchedNames[1])) ||
        (firstName.startsWith(searchedNames[1]) && lastName.startsWith(searchedNames[0]));
  }

  bool _patientPhoneMatchesSearchPhrase(String? phone, String searchedPhrase) {
    return phone != null && phone.startsWith(searchedPhrase);
  }

  bool _patientEmailMatchesSearchPhrase(String? email, String searchedPhrase) {
    return email != null && email.startsWith(searchedPhrase);
  }
}

extension on DateTime {
  bool isAfterOrEqual(DateTime? other) {
    return other == null || (other == this || isAfter(other));
  }

  bool isBeforeOrEqual(DateTime? other) {
    return other == null || (other == this || isBefore(other));
  }
}
