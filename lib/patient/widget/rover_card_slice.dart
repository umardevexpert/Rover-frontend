import 'package:flutter/material.dart';

class RoverCardSlice extends StatelessWidget {
  final bool first;
  final bool last;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  const RoverCardSlice({super.key, this.first = false, this.last = false, this.height, this.padding, this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        margin: EdgeInsets.only(
          top: first ? 3 : 0,
          left: 4,
          right: 4,
          bottom: last ? 5 : 0,
        ),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: first ? Radius.circular(8.0) : Radius.zero,
            bottom: last ? Radius.circular(8.0) : Radius.zero,
          ),
          boxShadow: const [BoxShadow(blurRadius: 5, offset: Offset(0, 1), color: Color(0x1F64748B))],
        ),
        alignment: Alignment.topLeft,
        padding: padding,
        child: child,
      ),
    );
  }
}
