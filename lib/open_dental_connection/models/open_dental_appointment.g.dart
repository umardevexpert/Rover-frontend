// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dental_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenDentalAppointment _$OpenDentalAppointmentFromJson(
        Map<String, dynamic> json) =>
    OpenDentalAppointment(
      id: json['AptNum'] as int,
      patientId: json['PatNum'] as int,
      date: DateTime.parse(json['AptDateTime'] as String),
      providerAbbreviation: nullIfEmptyString(json, 'provAbbr') as String?,
    );

Map<String, dynamic> _$OpenDentalAppointmentToJson(
        OpenDentalAppointment instance) =>
    <String, dynamic>{
      'AptNum': instance.id,
      'PatNum': instance.patientId,
      'AptDateTime': instance.date.toIso8601String(),
      'provAbbr': instance.providerAbbreviation,
    };
