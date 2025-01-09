// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dental_treatment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenDentalTreatment _$OpenDentalTreatmentFromJson(Map<String, dynamic> json) =>
    OpenDentalTreatment(
      id: json['ProcTPNum'] as int,
      toothNumber: json['ToothNumTP'] as String,
      adaCode: json['ProcCode'] as String,
      toothSurface: nullIfEmptyString(json, 'Surf') as String?,
      description: nullIfEmptyString(json, 'Descript') as String?,
      date: DateTime.parse(json['DateTP'] as String),
    );

Map<String, dynamic> _$OpenDentalTreatmentToJson(
        OpenDentalTreatment instance) =>
    <String, dynamic>{
      'ProcTPNum': instance.id,
      'ToothNumTP': instance.toothNumber,
      'ProcCode': instance.adaCode,
      'Surf': instance.toothSurface,
      'Descript': instance.description,
      'DateTP': instance.date.toIso8601String(),
    };
