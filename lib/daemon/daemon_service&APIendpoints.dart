import 'dart:async';
import 'dart:convert';

import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/admin_settings/model/pms_settings.dart';
import 'package:rover/common/error/connection_exception.dart';
import 'package:rover/open_dental_connection/models/open_dental_appointment.dart';
import 'package:rover/open_dental_connection/models/open_dental_patient.dart';
import 'package:rover/open_dental_connection/models/open_dental_tooth_initials.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment.dart';
import 'package:rover/open_dental_connection/models/open_dental_treatment_plan.dart';
import 'package:rover/patient/model/appointment.dart';
import 'package:rover/patient/model/appointment_date_filter.dart';
import 'package:rover/patient/model/patient.dart';
import 'package:rover/patient/model/tooth_initials.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient/model/treatment_plan.dart';
import 'package:rover/pms_connection/contract/pms_connection_service.dart';
import 'package:rover/pms_connection/contract/pms_mapper.dart';

// const _TEST_URL = 'api.opendental.com'; //testing API
// const _TEST_AUTH_HEADER = {'Authorization': 'ODFHIR NFF6i0KrXrxDkZHt/VzkmZEaUWOjnQX2z'}; //testing API auth header
// const _BASE_URL = '127.0.0.1:30222';
// const _UPDATE_INTERVAL = Duration(seconds: 3);
const _PATIENTS_ENDPOINT = '/api/v1/patients/Simple';
const _TREATMENTS_ENDPOINT = '/api/v1/proctps';
const _TREATMENT_PLANS_ENDPOINT = '/api/v1/treatplans';
const _APPOINTMENTS_ENDPOINT = '/api/v1/appointments';
const _TOOTH_INITIALS_ENDPOINT = '/api/v1/toothinitials';
const _OPEN_DENTAL_DATE_FORMAT = 'yyyy-MM-dd';

// TODO(andy): temporary
const _TOOTH_INITIALS_ENDPOINT_READY = false;

class OpenDentalConnectionService implements PMSConnectionService {
  final _client = RetryClient(Client());
  final PMSMapper<OpenDentalPatient, OpenDentalAppointment, OpenDentalTreatmentPlan, OpenDentalTreatment,
      OpenDentalToothInitials> mapper;
  final _formatter = DateFormat(_OPEN_DENTAL_DATE_FORMAT);
  final CollectionGetter<PMSSettings> settingsRepository;

  OpenDentalConnectionService({required this.mapper, required this.settingsRepository});

  /// /api/v1/appointments
  /// /api/v1/appointments?dateStart=2020-07-30&dateEnd=2020-08-02
  @override
  Future<List<Appointment>> getAppointments({AppointmentDateFilter? filter}) => _makeRequest(
    endpointSuffix: _APPOINTMENTS_ENDPOINT,
    queryParameters: _createAppointmentDateQueryParameters(filter),
    fromJson: OpenDentalAppointment.fromJson,
    toDomainMapper: mapper.mapAppointment,
  );

  /// /api/v1/patients/Simple?hideInactive=true
  @override
  Future<List<Patient>> getPatients() async {
    final response = await _client.get(Uri.parse('http://192.168.18.11:8080/api/patients'));
    if (response.statusCode != 200) {
      throw ConnectionException(message: 'Failed to fetch patients from Daemon');
    }

    // Parse the response
    final List<dynamic> jsonList = jsonDecode(response.body);

    // Check if the list is empty
    if (jsonList.isEmpty) {
      print('No patients found.');
      return [];
    }

    // Map the JSON to Patient objects
    return jsonList.map((patientData) => mapper.mapPatient(OpenDentalPatient.fromJson(patientData))).toList();
  }
  /// /api/v1/treatplans?PatNum=1897
  @override
  Future<List<TreatmentPlan>> getTreatmentPlansByPatientId(String patientId) => _makeRequest(
    endpointSuffix: _TREATMENT_PLANS_ENDPOINT,
    queryParameters: {'PatNum': patientId},
    fromJson: OpenDentalTreatmentPlan.fromJson,
    toDomainMapper: mapper.mapTreatmentPlan,
  );

  /// /api/v1/proctps?TreatPlanNum=963
  @override
  Future<List<Treatment>> getTreatmentsByTreatmentPlanId(String treatmentPlanId) => _makeRequest(
    endpointSuffix: _TREATMENTS_ENDPOINT,
    queryParameters: {'TreatPlanNum': treatmentPlanId},
    fromJson: OpenDentalTreatment.fromJson,
    toDomainMapper: mapper.mapTreatment,
  );

  /// TODO(andy): temporary
  List<ToothInitials> _getMockedToothInitialsOfPatient(String patientId) {
    final patientIdInt = int.tryParse(patientId) ?? 1;

    // Marvin Medicaid
    if (patientIdInt == 9) {
      return [ToothInitials(toothInitialNum: 1, patientId: patientIdInt, toothNum: 1, initialType: 'Missing')];
    }

    final timeVariableRemainder = DateTime.now().millisecondsSinceEpoch % 10;
    final patientToothNumOffset = (patientIdInt + timeVariableRemainder) % 10 + 1;

    if (patientIdInt < 10) {
      return [
        ToothInitials(
            toothInitialNum: 1, patientId: patientIdInt, toothNum: patientToothNumOffset, initialType: 'Missing')
      ];
    }

    return [
      ToothInitials(
          toothInitialNum: 1,
          patientId: patientIdInt,
          toothNum: timeVariableRemainder.isEven ? 1 : patientToothNumOffset,
          initialType: 'Missing'),
      ToothInitials(
          toothInitialNum: 2, patientId: patientIdInt, toothNum: patientToothNumOffset + 2, initialType: 'Missing')
    ];
  }

  /// /api/v1/toothinitials?PatNum=1897
  @override
  Future<List<ToothInitials>> getToothInitialsByPatientId(String patientId) {
    if (!_TOOTH_INITIALS_ENDPOINT_READY) {
      return Future(() => _getMockedToothInitialsOfPatient(patientId));
    }

    return _makeRequest(
      endpointSuffix: _TOOTH_INITIALS_ENDPOINT,
      queryParameters: {'PatNum': patientId},
      fromJson: OpenDentalToothInitials.fromJson,
      toDomainMapper: mapper.mapToothInitials,
    );
  }

  Future<List<TOut>> _makeRequest<TOut, TODental>({
    required String endpointSuffix,
    Map<String, dynamic>? queryParameters,
    required Projector<Map<String, dynamic>, TODental> fromJson,
    required Projector<TODental, TOut> toDomainMapper,
  }) async {
    final settings = await settingsRepository.getDocument('1');
    if (settings == null) {
      return Future.error(ConnectionException(message: "Couldn't fetch PMS settings from repository"));
    }
    final uri = settings.ipAddress.startsWith('https')
        ? Uri.https(settings.ipAddress.substring(8), endpointSuffix, queryParameters)
        : Uri.http(settings.ipAddress.substring(7), endpointSuffix, queryParameters);
    final initialResponse = await _client.get(
      uri,
      headers: {'Authorization': 'ODFHIR ${settings.developerKey}/${settings.customerKey}'},
    );

    if (initialResponse.statusCode != 200) {
      return Future.error(
        ConnectionException(message: '''
        Failed to fetch data.
        Status code: ${initialResponse.statusCode}
        Body: ${initialResponse.body}'''),
      );
    }
    return _parseResponseBody<TOut, TODental>(initialResponse.body, fromJson, toDomainMapper);

    // Continuously listen for updates - this is here if we decide to use Streams instead of Futures
    // Uncomment this for polling - stream (matej)
    // while (true) {
    //   await Future<void>.delayed(_UPDATE_INTERVAL);
    //
    //   final updatedResponse = await _client.get(uri, headers: headers);
    //   if (updatedResponse.statusCode == 200) {
    //     yield _parseResponseBody<TOut, TODental>(updatedResponse.body, fromJson, toDomainMapper);
    //   }
    // }
  }

  List<TOut> _parseResponseBody<TOut, TODental>(
      String responseBody,
      Projector<Map<String, dynamic>, TODental> fromJson,
      Projector<TODental, TOut> odMapper,
      ) {
    final jsonList = jsonDecode(responseBody) as List;
    return jsonList.map((e) => fromJson(e)).map(odMapper).toList();
  }

  Map<String, String>? _createAppointmentDateQueryParameters(AppointmentDateFilter? filter) {
    if (filter == null) {
      return null;
    }
    return {
      if (filter.startDate != null) 'dateStart': _formatter.format(filter.startDate!),
      if (filter.endDate != null) 'dateEnd': _formatter.format(filter.endDate!),
    };
  }
}