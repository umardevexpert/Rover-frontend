import 'package:flutter/material.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';

class RoverCard extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final Widget? child;

  const RoverCard(
      {super.key, this.padding = const EdgeInsets.all(20), this.width, this.height, this.child, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: STANDARD_BORDER_RADIUS,
        border: border,
        boxShadow: const [BoxShadow(blurRadius: 5, offset: Offset(0, 1), color: Color(0x1F64748B))],
      ),
      padding: padding,
      child: child,
    );
  }
}
