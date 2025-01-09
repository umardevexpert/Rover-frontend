// ignore_for_file: avoid_classes_with_only_static_members

import 'package:client_kit/auth/model/current_user.dart';
import 'package:client_kit/auth/model/in_memory_mocked_auth_user.dart';
import 'package:rover/auth/model/access_data.dart';
import 'package:rover/users_management/model/user_role.dart';

class TestUsers {
  static final users = [
    InMemoryMockedAuthUser(
      username: 'jacob@admin.com',
      password: 'Abcdef123',
      details: CurrentUser(
        '1',
        'jacob@admin.com',
        'Jacob A',
        false,
        AccessData(role: UserRole.admin),
      ),
    ),
    InMemoryMockedAuthUser(
      username: 'jacob@doctor.com',
      password: 'Abcdef123',
      details: CurrentUser(
        '2',
        'jacob@doctor.com',
        'Jacob D',
        false,
        AccessData(role: UserRole.doctor),
      ),
    ),
    InMemoryMockedAuthUser(
      username: 'ngu@mymetrodental.com',
      password: 'Abcdef123',
      details: CurrentUser(
        '3',
        'ngu@mymetrodental.com',
        'Ngu Mbandi',
        false,
        AccessData(role: UserRole.admin),
      ),
    ),
  ];
}
