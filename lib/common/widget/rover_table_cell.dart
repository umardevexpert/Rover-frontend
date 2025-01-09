import 'package:flutter/material.dart';

const _HORIZONTAL_PADDING = 24.0;
const _BODY_CELL_HEIGHT = 79.0;

class RoverTableCell extends StatelessWidget {
  final int? flex;
  final double? width;
  final double horizontalPadding;
  final double cellHeight;
  final Widget child;

  const RoverTableCell.box({
    super.key,
    required double this.width,
    required this.child,
    this.cellHeight = _BODY_CELL_HEIGHT,
  })  : flex = null,
        horizontalPadding = _HORIZONTAL_PADDING;

  const RoverTableCell.expanded({
    super.key,
    int this.flex = 1,
    required this.child,
    this.cellHeight = _BODY_CELL_HEIGHT,
  })  : width = null,
        horizontalPadding = _HORIZONTAL_PADDING;

  @override
  Widget build(BuildContext context) {
    final result = Container(
      height: cellHeight,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      alignment: Alignment.centerLeft,
      child: child,
    );

    if (flex == null) {
      return result;
    }
    return Expanded(flex: flex!, child: result);
  }
}
