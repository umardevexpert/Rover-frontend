// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      email: json['email'] as String,
      phone: json['phone'] as String,
      pictureURL: json['pictureURL'] as String?,
      hasChangedInitialPassword:
          json['hasChangedInitialPassword'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
      joinDate: DateTime.parse(json['joinDate'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'role': _$UserRoleEnumMap[instance.role]!,
      'email': instance.email,
      'phone': instance.phone,
      'pictureURL': instance.pictureURL,
      'hasChangedInitialPassword': instance.hasChangedInitialPassword,
      'archived': instance.archived,
      'joinDate': instance.joinDate.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.doctor: 'doctor',
  UserRole.admin: 'admin',
};
