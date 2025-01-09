import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rover/common/error/rover_exception.dart';
import 'package:rover/common/util/show_rover_snackbar.dart';
import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/appointment_status.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/patients_appointment.dart';
import 'package:rover/patient/model/patients_table_metadata.dart';
import 'package:rover/patient/service/patients_filtering_service.dart';
import 'package:rover/patient/service/patients_table_controller.dart';
import 'package:rover/pms_connection/contract/pms_connection_service.dart';
import 'package:rxdart/rxdart.dart';

const _INITIAL_TAB_INDEX = 0;
const _deepListComparator = DeepCollectionEquality.unordered();
const _UPDATE_STATUS_DURATION = Duration(minutes: 1);

class PatientsPageController {
  final PMSConnectionService _pmsConnectionService;
  final PatientsTableController _allPatientsController;
  final PatientsTableController _todaysAppointmentsController;
  final PatientsFilteringService _patientsFilteringService;

  final _activeTabIndexStreamController = BehaviorSubject<int>();
  final _patientsPageDataStreamController = BehaviorSubject<List<PatientsAppointment>?>();
  final _patientsStreamController = BehaviorSubject<List<Patient>>();
  final _appointmentsStreamController = BehaviorSubject<List<Appointment>>();
  Timer? _timer;
  var _activeTabIndex = _INITIAL_TAB_INDEX;
  var _hasError = false;

  PatientsPageController(
    this._patientsFilteringService,
    this._pmsConnectionService,
    this._allPatientsController,
    this._todaysAppointmentsController,
  ) {
    _updateActiveTabIndexStream();
  }

  Stream<int> get activeTabIndexStream => _activeTabIndexStreamController.stream;

  Stream<List<PatientsAppointment>?> get patientsDataStream =>
      _patientsFilteringService.getFilteredPatientList(patientStream: _patientsPageDataStreamController.stream);

  Stream<PatientsTableMetadata> get sortingAndScrollingStream => activeTabIndexStream.switchMap((index) {
        return switch (index) {
          0 => _todaysAppointmentsController.tableMetadataStream,
          _ => _allPatientsController.tableMetadataStream
        };
      });

  Stream<List<Patient>> get allPatientsStream => _patientsStreamController.stream;

  Stream<List<Appointment>> get allAppointmentsStream => _appointmentsStreamController.stream;

  set activeTabIndex(int value) {
    if (value != 0 && value != 1) {
      throw StateError('Invalid active tab index');
    }
    if (_activeTabIndex != value) {
      _activeTabIndex = value;
      _updateActiveTabIndexStream();
      _updateStreamWithCurrentData();
      refreshTableControllers(); //to update the scroll offset
    }
  }

  set scrollOffset(double value) {
    _activeTabIndex == 0
        ? _todaysAppointmentsController.scrollOffset = value
        : _allPatientsController.scrollOffset = value;
  }

  void startRefreshTimer() => _timer = Timer.periodic(_UPDATE_STATUS_DURATION, (_) => _updateStreamWithCurrentData());

  void stopRefreshTimer() => _timer?.cancel();

  void refreshTableControllers() {
    _todaysAppointmentsController.updateStream();
    _allPatientsController.updateStream();
  }

  Future<void> refreshPatientsData() async {
    try {
      final newAppointments = await _pmsConnectionService.getAppointments();
      final newPatients = await _pmsConnectionService.getPatients();

      if (!_hasError &&
          _patientsStreamController.hasValue &&
          _appointmentsStreamController.hasValue &&
          _deepListComparator.equals(newPatients, _patientsStreamController.value) &&
          _deepListComparator.equals(newAppointments, _appointmentsStreamController.value)) {
        return;
      }
      _updatePatientDataStream(newAppointments, newPatients);
      _hasError = false;
      _patientsStreamController.add(newPatients);
      _appointmentsStreamController.add(newAppointments);
    } on RoverException catch (e) {
      showErrorSnackbarWithClose(title: 'Error while fetching data', content: e.message);
      _setErrorState(e);
    } catch (e) {
      showErrorSnackbarWithClose(title: 'Unexpected error occurred while trying to fetch data', content: e.toString());
      _setErrorState(e);
    }
  }

  void _updateStreamWithCurrentData() {
    if (_patientsStreamController.hasValue && _appointmentsStreamController.hasValue) {
      _updatePatientDataStream(_appointmentsStreamController.value, _patientsStreamController.value);
    }
  }

  void _updatePatientDataStream(List<Appointment> appointments, List<Patient> patients) {
    _patientsPageDataStreamController.add(_activeTabIndex == 0
        ? _calculateTodaysAppointments(appointments, patients)
        : _calculateAllPatients(appointments, patients));
  }

  void resetAllData() {
    _allPatientsController.setDefaultValues();
    _todaysAppointmentsController.setDefaultValues();
    _activeTabIndex = _INITIAL_TAB_INDEX;
    _hasError = false;
    _appointmentsStreamController.add(<Appointment>[]);
    _patientsStreamController.add(<Patient>[]);
    _updateActiveTabIndexStream();
    _patientsPageDataStreamController.done;
  }

  void _updateActiveTabIndexStream() => _activeTabIndexStreamController.add(_activeTabIndex);

  void _setErrorState(Object e) {
    _hasError = true;
    _patientsPageDataStreamController.addError(e);
  }

  List<PatientsAppointment> _calculateTodaysAppointments(List<Appointment> appointments, List<Patient> patients) {
    // TODO(matej): replace this mocked implementation
    // final now = DateTime.now();
    final now = DateTime(2020, 10, 27, 13, 37, 10);
    final sorted = appointments
        .where((appointment) => DateUtils.isSameDay(appointment.date, now))
        .map(
          (appointment) => PatientsAppointment(
            appointment: appointment,
            patient: patients.firstWhere((patient) => patient.id == appointment.patientId),
          ),
        )
        .toList()
      ..sortBy((element) => element.appointment.date);
    return _assignAppointmentStatus(sorted, now);
  }

  List<PatientsAppointment> _calculateAllPatients(List<Appointment> appointments, List<Patient> patients) {
    // TODO(matej): replace this mocked implementation -> Make appointment optional
    return patients
        .map((p) => PatientsAppointment(
            patient: p,
            appointment: appointments.firstWhere((a) => a.patientId == p.id, orElse: () => appointments.first)))
        .toList();
  }

  List<PatientsAppointment> _assignAppointmentStatus(List<PatientsAppointment> appointments, DateTime now) {
    if (appointments.isEmpty) {
      return appointments;
    }
    // Index of last started appointment (current appointment)
    final index = appointments.lastIndexWhere((element) => element.appointment.date.difference(now).isNegative);
    for (var i = 0; i < appointments.length; i++) {
      appointments[i] = appointments[i].changeStatus(_getAppointmentWithStatus(i, index));
    }
    return appointments;
  }

  AppointmentStatus _getAppointmentWithStatus(int thisIndex, int currentAppointmentIndex) {
    if (thisIndex == currentAppointmentIndex) {
      return AppointmentStatus.current;
    }
    if (thisIndex == currentAppointmentIndex - 1) {
      return AppointmentStatus.recentlyFinished;
    }
    if (thisIndex == currentAppointmentIndex + 1) {
      return AppointmentStatus.next;
    }
    if (thisIndex < currentAppointmentIndex) {
      return AppointmentStatus.finished;
    }
    return AppointmentStatus.upcoming;
  }
}
