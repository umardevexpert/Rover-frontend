// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dental_patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenDentalPatient _$OpenDentalPatientFromJson(Map<String, dynamic> json) =>
    OpenDentalPatient(
      id: json['PatNum'] as int,
      firstName: json['FName'] as String,
      lastName: json['LName'] as String,
      gender: json['Gender'] as String? ?? 'Other',
      dayOfBirth: DateTime.parse(json['Birthdate'] as String),
      email: nullIfEmptyString(json, 'Email') as String?,
      homePhoneNumber: nullIfEmptyString(json, 'HmPhone') as String?,
      workPhoneNumber: nullIfEmptyString(json, 'WkPhone') as String?,
      wirelessPhoneNumber: nullIfEmptyString(json, 'WirelessPhone') as String?,
      providerAbbreviation: nullIfEmptyString(json, 'priProvAbbr') as String?,
    );

Map<String, dynamic> _$OpenDentalPatientToJson(OpenDentalPatient instance) =>
    <String, dynamic>{
      'PatNum': instance.id,
      'FName': instance.firstName,
      'LName': instance.lastName,
      'Gender': instance.gender,
      'Birthdate': instance.dayOfBirth.toIso8601String(),
      'HmPhone': instance.homePhoneNumber,
      'WkPhone': instance.workPhoneNumber,
      'WirelessPhone': instance.wirelessPhoneNumber,
      'Email': instance.email,
      'priProvAbbr': instance.providerAbbreviation,
    };
