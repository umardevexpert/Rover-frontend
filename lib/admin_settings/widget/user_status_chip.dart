import 'package:flutter/material.dart';
import 'package:rover/common/widget/rover_chip.dart';

class UserStatusChip extends StatelessWidget {
  final bool active;

  const UserStatusChip({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return RoverChip(
      showDecorationDot: true,
      color: active ? RoverChipColor.green : RoverChipColor.grey,
      label: active ? 'Active' : 'Deactivated',
    );
  }
}
