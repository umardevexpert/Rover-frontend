import 'package:flutter/material.dart';
import 'package:rover/common/widget/rover_chip.dart';
import 'package:rover/users_management/model/user_role.dart';

class UserRoleChip extends StatelessWidget {
  final UserRole role;

  const UserRoleChip({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == UserRole.admin;

    return RoverChip(color: isAdmin ? RoverChipColor.darkBlue : RoverChipColor.golden, label: role.label);
  }
}
