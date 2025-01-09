import 'package:rover/common/widget/rover_table_cell.dart';

const _HEADER_CELL_HEIGHT = 46.0;

class RoverTableHeaderCell extends RoverTableCell {
  RoverTableHeaderCell.box({
    super.key,
    required super.width,
    required super.child,
  }) : super.box(cellHeight: _HEADER_CELL_HEIGHT);

  RoverTableHeaderCell.expanded({
    super.key,
    super.flex = 1,
    required super.child,
  }) : super.expanded(cellHeight: _HEADER_CELL_HEIGHT);
}
