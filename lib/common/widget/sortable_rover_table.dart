import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/util/table_sorting_type_extension.dart';
import 'package:rover/common/widget/rover_table.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

const _deepListComparator = DeepCollectionEquality.unordered();

class SortableRoverTable<TColumnModel, TRowDataModel> extends StatefulWidget {
  final MainAxisSize mainAxisSize;
  final List<TRowDataModel> tableData;
  final List<TColumnModel> columnsOrder;
  final TColumnModel defaultSortColumn;
  final TableSortingType defaultSortingOrder;
  final Consumer<TColumnModel> sortCallback;
  final WidgetBuilder3<TColumnModel, TableSortingType, Consumer<TColumnModel>> headerCellBuilder;
  final WidgetBuilder2<TColumnModel, TRowDataModel> rowCellBuilder;

  const SortableRoverTable({
    super.key,
    required this.columnsOrder,
    required this.tableData,
    required this.headerCellBuilder,
    required this.rowCellBuilder,
    required this.sortCallback,
    required this.defaultSortColumn,
    this.mainAxisSize = MainAxisSize.max,
    this.defaultSortingOrder = TableSortingType.ascending,
  });

  @override
  State<SortableRoverTable<TColumnModel, TRowDataModel>> createState() =>
      _SortableRoverTableState<TColumnModel, TRowDataModel>();
}

class _SortableRoverTableState<TColumnModel, TRowDataModel>
    extends State<SortableRoverTable<TColumnModel, TRowDataModel>> {
  late TableSortingType _sortingType;
  late TColumnModel _sortByColumn;

  @override
  void initState() {
    super.initState();
    _sortingType = widget.defaultSortingOrder;
    _sortByColumn = widget.defaultSortColumn;
    widget.sortCallback(_sortByColumn);
  }

  @override
  void didUpdateWidget(covariant SortableRoverTable<TColumnModel, TRowDataModel> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_deepListComparator.equals(oldWidget.tableData, widget.tableData)) {
      widget.sortCallback(_sortByColumn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoverTable(
      tableData: _sortingType == TableSortingType.descending ? widget.tableData.reversed.toList() : widget.tableData,
      columnsOrder: widget.columnsOrder,
      mainAxisSize: widget.mainAxisSize,
      cellBuilder: widget.rowCellBuilder,
      headerCellBuilder: (context, column) => widget.headerCellBuilder(
          context, column, _sortByColumn == column ? _sortingType : TableSortingType.none, _setSortColumn),
    );
  }

  void _setSortColumn(TColumnModel column) {
    if (_sortByColumn == column) {
      setState(() => _sortingType = _sortingType.reverse());
      return;
    }
    setState(() {
      _sortingType = TableSortingType.ascending;
      _sortByColumn = column;
    });
    widget.sortCallback(column);
  }
}
