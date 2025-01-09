import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_table_cell.dart';
import 'package:rover/common/widget/rover_table_header_cell.dart';
import 'package:rover/common/widget/rover_table_header_label.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';
import 'package:rover/patient/widget/rover_card_slice.dart';
import 'package:rover/patient/widget/table_row_slice.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PatientsTableHeader extends StatelessWidget {
  final List<PatientsTableColumnType> columnsOrder;
  final PatientsTableColumnType orderByColumn;
  final TableSortingType sortingType;
  final Consumer<PatientsTableColumnType> sortCallback;

  const PatientsTableHeader({
    super.key,
    required this.columnsOrder,
    required this.orderByColumn,
    required this.sortingType,
    required this.sortCallback,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return SliverPinnedHeader(
      child: Container(
        color: appTheme?.colorScheme.grey100,
        padding: const EdgeInsets.symmetric(horizontal: 68.0),
        child: RoverCardSlice(
          padding: const EdgeInsets.symmetric(horizontal: LARGE_UI_GAP),
          child: TableRowSlice(first: true, cells: _buildHeaderCells()),
        ),
      ),
    );
  }

  List<RoverTableCell> _buildHeaderCells() {
    return columnsOrder.map((columnType) {
      return RoverTableHeaderCell.expanded(
          child: switch (columnType) {
        PatientsTableColumnType.age => _buildSortableTableHeaderLabel('Age & Sex', columnType),
        PatientsTableColumnType.name => _buildSortableTableHeaderLabel('Patient name', columnType),
        PatientsTableColumnType.appointmentDate => _buildSortableTableHeaderLabel('Appointment date', columnType),
        PatientsTableColumnType.status => _buildSortableTableHeaderLabel('Status', columnType),
        PatientsTableColumnType.phone => Text('Phone number'),
      });
    }).toList();
  }

  // TODO(matej): this is duplicate in user/treatments table - figure out how to fix?
  Widget _buildSortableTableHeaderLabel(String label, PatientsTableColumnType columnType) {
    return RoverTableHeaderLabel(
      label: label,
      sortingType: orderByColumn == columnType ? sortingType : TableSortingType.none,
      onSortingPressed: () => sortCallback(columnType),
    );
  }
}
