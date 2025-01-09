// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dental_treatment_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenDentalTreatmentPlan _$OpenDentalTreatmentPlanFromJson(
        Map<String, dynamic> json) =>
    OpenDentalTreatmentPlan(
      id: json['TreatPlanNum'] as int,
      name: json['Heading'] as String,
    );

Map<String, dynamic> _$OpenDentalTreatmentPlanToJson(
        OpenDentalTreatmentPlan instance) =>
    <String, dynamic>{
      'TreatPlanNum': instance.id,
      'Heading': instance.name,
    };
