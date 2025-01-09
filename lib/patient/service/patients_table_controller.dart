import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/util/table_sorting_type_extension.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';
import 'package:rover/patient/model/patients_table_metadata.dart';
import 'package:rxdart/rxdart.dart';

/// This class controls the scroll offset and sorting state of 1 `PatientsTable`
class PatientsTableController {
  final _tableMetadataStreamController = BehaviorSubject<PatientsTableMetadata>();
  final PatientsTableColumnType initialSortColumn;
  final TableSortingType initialSortingType;
  var _orderByColumn = PatientsTableColumnType.appointmentDate;
  var _sortingType = TableSortingType.ascending;
  var _scrollOffset = 0.0;

  PatientsTableController({required this.initialSortColumn, required this.initialSortingType}) {
    setDefaultValues();
  }

  Stream<PatientsTableMetadata> get tableMetadataStream => _tableMetadataStreamController.stream;

  set scrollOffset(double value) => _scrollOffset = value;

  set sortColumn(PatientsTableColumnType value) {
    if (value == _orderByColumn) {
      _sortingType = _sortingType.reverse();
    } else {
      _orderByColumn = value;
      _sortingType = TableSortingType.ascending;
    }
    updateStream();
  }

// TODO(matej): check for the "scroll-state" above the table (hidden/partially/visible informationCardRow) and keep it consistent while switching the tabs?
  void updateStream() {
    _tableMetadataStreamController.add(PatientsTableMetadata(
      scrollOffset: _scrollOffset,
      sortColumn: _orderByColumn,
      sortingType: _sortingType,
    ));
  }

  void setDefaultValues() {
    _sortingType = initialSortingType;
    _orderByColumn = initialSortColumn;
    _scrollOffset = 0;
    _tableMetadataStreamController.done;
  }
}
