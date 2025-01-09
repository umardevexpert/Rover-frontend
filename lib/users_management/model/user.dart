import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:master_kit/util/reference_wrapper.dart';
import 'package:rover/users_management/model/user_role.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User implements Serializable {
  final String id;
  final String name;
  final String surname;
  final UserRole role;
  final String email;
  final String phone;
  final String? pictureURL;
  final bool hasChangedInitialPassword;
  final bool archived;
  final DateTime joinDate;

  const User({
    required this.id,
    required this.name,
    required this.surname,
    required this.role,
    required this.email,
    required this.phone,
    required this.pictureURL,
    this.hasChangedInitialPassword = false,
    this.archived = false,
    required this.joinDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? surname,
    UserRole? role,
    String? email,
    String? phone,
    ReferenceWrapper<String>? pictureURL,
    bool? hasChangedInitialPassword,
    bool? archived,
    DateTime? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      pictureURL: pictureURL != null ? pictureURL.wrapped : this.pictureURL,
      hasChangedInitialPassword: hasChangedInitialPassword ?? this.hasChangedInitialPassword,
      archived: archived ?? this.archived,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          surname == other.surname &&
          role == other.role &&
          email == other.email &&
          phone == other.phone &&
          pictureURL == other.pictureURL &&
          hasChangedInitialPassword == other.hasChangedInitialPassword &&
          archived == other.archived &&
          joinDate == other.joinDate;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      surname.hashCode ^
      role.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      pictureURL.hashCode ^
      hasChangedInitialPassword.hashCode ^
      archived.hashCode ^
      joinDate.hashCode;
}
