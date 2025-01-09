// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_dental_tooth_initials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenDentalToothInitials _$OpenDentalToothInitialsFromJson(
        Map<String, dynamic> json) =>
    OpenDentalToothInitials(
      toothInitialNum: json['ToothInitialNum'] as int,
      patientId: json['PatNum'] as int,
      toothNum: json['ToothNum'] as int,
      initialType: json['InitialType'] as String,
    );

Map<String, dynamic> _$OpenDentalToothInitialsToJson(
        OpenDentalToothInitials instance) =>
    <String, dynamic>{
      'ToothInitialNum': instance.toothInitialNum,
      'PatNum': instance.patientId,
      'ToothNum': instance.toothNum,
      'InitialType': instance.initialType,
    };
