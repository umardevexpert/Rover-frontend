enum UserRole {
  doctor,
  admin;
}

const _USER_ROLE_TO_LABEL = {
  UserRole.doctor: 'Doctor',
  UserRole.admin: 'Admin',
};

extension UserRoleExtension on UserRole {
  String get label => _USER_ROLE_TO_LABEL[this]!;
}
