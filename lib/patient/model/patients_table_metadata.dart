import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';

class PatientsTableMetadata {
  final PatientsTableColumnType sortColumn;
  final TableSortingType sortingType;
  final double scrollOffset;

  const PatientsTableMetadata({
    required this.scrollOffset,
    required this.sortColumn,
    required this.sortingType,
  });
}
