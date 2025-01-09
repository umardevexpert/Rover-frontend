import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/patient/model/patients_appointment.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';
import 'package:rover/patient/model/patients_table_metadata.dart';
import 'package:rover/patient/service/patients_table_controller.dart';
import 'package:rover/patient/widget/patients_table_header.dart';
import 'package:rover/patient/widget/patients_table_rows.dart';
import 'package:sliver_tools/sliver_tools.dart';

typedef _PatientAppointmentComparator = Projector2<PatientsAppointment, PatientsAppointment, int>;

class PatientsTable extends StatelessWidget {
  final PatientsTableMetadata metadata;
  final List<PatientsAppointment> tableData;
  late final List<PatientsTableColumnType> _columnsOrder;
  late final PatientsTableController _tableController;

  PatientsTable({super.key, bool showStatusColumn = false, required this.metadata, required this.tableData}) {
    tableData.sort(_getComparator(metadata.sortColumn));
    _tableController = get<PatientsTableController>(
      instanceName: showStatusColumn ? TODAYS_APPOINTMENTS_INSTANCE_NAME : ALL_PATIENTS_INSTANCE_NAME,
    );
    _columnsOrder = [
      PatientsTableColumnType.name,
      PatientsTableColumnType.age,
      PatientsTableColumnType.phone,
      if (showStatusColumn) PatientsTableColumnType.status,
      PatientsTableColumnType.appointmentDate,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        PatientsTableHeader(
          columnsOrder: _columnsOrder,
          orderByColumn: metadata.sortColumn,
          sortingType: metadata.sortingType,
          sortCallback: _setSortingOption,
        ),
        PatientsTableRows(
          columnsOrder: _columnsOrder,
          patientsData: metadata.sortingType == TableSortingType.descending ? tableData.reversed.toList() : tableData,
          onRowTap: (rowData) => context.go('/dashboard/patient-detail', extra: rowData.patient),
        )
      ],
    );
  }

  void _setSortingOption(PatientsTableColumnType newColumn) {
    _tableController.sortColumn = newColumn;
    if (metadata.sortColumn != newColumn) {
      tableData.sort(_getComparator(newColumn));
    }
  }

  _PatientAppointmentComparator _getComparator(PatientsTableColumnType newColumn) {
    return switch (newColumn) {
      PatientsTableColumnType.age => (a, b) => b.patient.dayOfBirth.compareTo(a.patient.dayOfBirth),
      PatientsTableColumnType.appointmentDate => _appointmentDateComparator,
      PatientsTableColumnType.status => (a, b) {
          final res = a.appointment.status.index.compareTo(b.appointment.status.index);
          return res == 0 ? _appointmentDateComparator(a, b) : res;
        },
      _ => (a, b) => a.patient.lastName.compareTo(b.patient.lastName),
    };
  }

  int _appointmentDateComparator(PatientsAppointment a, PatientsAppointment b) {
    return a.appointment.date.compareTo(b.appointment.date);
  }
}
