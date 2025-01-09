// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pms_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PMSSettings _$PMSSettingsFromJson(Map<String, dynamic> json) => PMSSettings(
      customerKey: json['customerKey'] as String,
      id: json['id'] as String,
      developerKey: json['developerKey'] as String,
      ipAddress: json['ipAddress'] as String,
    );

Map<String, dynamic> _$PMSSettingsToJson(PMSSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'developerKey': instance.developerKey,
      'customerKey': instance.customerKey,
      'ipAddress': instance.ipAddress,
    };
