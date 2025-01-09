import 'package:rover/common/model/table_sorting_type.dart';

extension TableSortingTypeExtension on TableSortingType {
  TableSortingType reverse() =>
      this == TableSortingType.ascending ? TableSortingType.descending : TableSortingType.ascending;
}
