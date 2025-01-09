import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/error/invalid_column_sort_exception.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/rover_table_cell.dart';
import 'package:rover/common/widget/rover_table_header_cell.dart';
import 'package:rover/common/widget/rover_table_header_label.dart';
import 'package:rover/common/widget/sortable_rover_table.dart';
import 'package:rover/image_capturing/model/tooth_preview.dart';
import 'package:rover/patient/model/treatment.dart';
import 'package:rover/patient_detail/model/treatments_table_column_type.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down.dart';

class TreatmentsTable extends StatefulWidget {
  final List<Treatment>? treatments;
  final List<ToothPreview>? teethPreview;

  TreatmentsTable({super.key, this.treatments, this.teethPreview});

  @override
  State<TreatmentsTable> createState() => _TreatmentsTableState();
}

class _TreatmentsTableState extends State<TreatmentsTable> {
  final _checkboxState = Map<String, bool>();
  final _columnsOrder = [
    TreatmentsTableColumnType.checkbox,
    TreatmentsTableColumnType.date,
    TreatmentsTableColumnType.toothNumber,
    TreatmentsTableColumnType.diagnosis,
    TreatmentsTableColumnType.adaCode,
    TreatmentsTableColumnType.toothSurface,
    TreatmentsTableColumnType.image,
    TreatmentsTableColumnType.description,
  ];

  @override
  void didUpdateWidget(covariant TreatmentsTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.treatments?.forEach((treatment) {
      if (!_checkboxState.containsKey(treatment.id)) {
        _checkboxState[treatment.id] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.treatments == null) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: STANDARD_UI_GAP),
        child: SortableRoverTable(
          columnsOrder: _columnsOrder,
          tableData: widget.treatments!,
          headerCellBuilder: (_, column, sortingType, sortCallback) =>
              _headerCellBuilder(column, sortingType, sortCallback),
          rowCellBuilder: _rowCellBuilder,
          sortCallback: _sortRows,
          defaultSortColumn: TreatmentsTableColumnType.date,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }

  Widget _headerCellBuilder(
    TreatmentsTableColumnType columnType,
    TableSortingType sortingType,
    Consumer<TreatmentsTableColumnType> sortCallback,
  ) {
    Widget buildLabel(String label, bool sortable) {
      return RoverTableHeaderCell.expanded(
        child: RoverTableHeaderLabel(
          label: label,
          sortingType: sortable ? sortingType : null,
          onSortingPressed: sortable ? () => sortCallback(columnType) : null,
        ),
      );
    }

    return switch (columnType) {
      TreatmentsTableColumnType.checkbox => _buildMainCheckbox(),
      TreatmentsTableColumnType.date => buildLabel('Date', true),
      TreatmentsTableColumnType.toothNumber => buildLabel('Tooth #', true),
      TreatmentsTableColumnType.diagnosis => buildLabel('Diagnosis', false),
      TreatmentsTableColumnType.adaCode => buildLabel('Ada code', true),
      TreatmentsTableColumnType.toothSurface => buildLabel('Tooth surface', false),
      TreatmentsTableColumnType.image =>
        RoverTableHeaderCell.box(width: 108, child: RoverTableHeaderLabel(label: 'Images')),
      TreatmentsTableColumnType.description => buildLabel('Description', false),
    };
  }

  Widget _rowCellBuilder(BuildContext context, TreatmentsTableColumnType columnType, Treatment treatment) {
    final appTheme = AppTheme.of(context);
    final textStyle = appTheme?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500);
    final toothNumber = int.tryParse(treatment.toothNumber);
    final teethRelatedToTreatment =
        toothNumber == null ? null : widget.teethPreview?.where((preview) => preview.teeth.contains(toothNumber)) ?? [];

    return switch (columnType) {
      TreatmentsTableColumnType.checkbox => _buildCheckboxCell(treatment.id),
      TreatmentsTableColumnType.date => _buildTextCell(DateFormat(SHORT_DATE).format(treatment.date), textStyle),
      TreatmentsTableColumnType.toothNumber => _buildTextCell(treatment.toothNumber, textStyle),
      TreatmentsTableColumnType.diagnosis => _buildDropDownCell(),
      TreatmentsTableColumnType.adaCode => _buildTextCell(treatment.adaCode, textStyle),
      TreatmentsTableColumnType.toothSurface => _buildTextCell(treatment.toothSurface, textStyle),
      TreatmentsTableColumnType.image =>
        _buildImageCell(teethRelatedToTreatment.isNullOrEmpty ? null : teethRelatedToTreatment!.last),
      TreatmentsTableColumnType.description => _buildDescriptionCell(treatment.description, appTheme),
    };
  }

  RoverTableCell _buildMainCheckbox() {
    final mainCheckboxState = _getMainCheckboxState();

    return RoverTableHeaderCell.box(
      width: 72,
      child: SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: mainCheckboxState,
          tristate: true,
          onChanged: (_) {
            if (mainCheckboxState == null || !mainCheckboxState) {
              setState(() => _checkboxState.updateAll((_, __) => true));
            } else {
              setState(() => _checkboxState.updateAll((_, __) => false));
            }
          },
        ),
      ),
    );
  }

  RoverTableCell _buildCheckboxCell(String id) {
    final selected = _checkboxState[id] ?? true;
    return RoverTableCell.box(
      width: 72,
      child: Checkbox(value: selected, onChanged: (_) => setState(() => _checkboxState[id] = !selected)),
    );
  }

  RoverTableCell _buildImageCell(ToothPreview? toothPreview) {
    return RoverTableCell.box(
      width: 108,
      child: toothPreview == null
          ? Text('-')
          : Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                image: DecorationImage(
                  image: MemoryImage(toothPreview.image.bytes),
                  fit: BoxFit.cover,
                ),
              ),
              clipBehavior: Clip.antiAlias,
            ),
    );
  }

  RoverTableCell _buildDescriptionCell(String? text, AppTheme? appTheme) {
    return RoverTableCell.expanded(
      child: Text(
        text ?? '-',
        style: appTheme?.textTheme.bodyM,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  RoverTableCell _buildTextCell(String? text, TextStyle? style) {
    return RoverTableCell.expanded(child: Text(text ?? '-', style: style));
  }

  RoverTableCell _buildDropDownCell() {
    return RoverTableCell.expanded(child: DropDown(value: 'Cavities', options: const ['Cavities']));
  }

  bool? _getMainCheckboxState() {
    if (_checkboxState.values.every((e) => e)) {
      return true;
    } else if (_checkboxState.values.every((e) => !e)) {
      return false;
    }
    return null;
  }

  void _sortRows(TreatmentsTableColumnType column) {
    return switch (column) {
      TreatmentsTableColumnType.date => widget.treatments?.sort((a, b) => a.date.compareTo(b.date)),
      TreatmentsTableColumnType.adaCode => widget.treatments?.sort((a, b) => a.adaCode.compareTo(b.adaCode)),
      TreatmentsTableColumnType.toothNumber =>
        widget.treatments?.sort((a, b) => a.toothNumber.compareTo(b.toothNumber)),
      _ => throw InvalidColumnSortException(message: "Can't sort by this column"),
    };
  }
}
