import 'package:flutter/material.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/person_name_and_email_table_cell.dart';
import 'package:rover/common/widget/rover_table_cell.dart';
import 'package:rover/patient/model/patients_appointment.dart';
import 'package:rover/patient/model/patients_table_column_type.dart';
import 'package:rover/patient/widget/appointment_date_table_cell.dart';
import 'package:rover/patient/widget/appointment_status_chip.dart';
import 'package:rover/patient/widget/patient_age_and_sex_table_cell.dart';
import 'package:rover/patient/widget/patient_phone_cell.dart';
import 'package:rover/patient/widget/rover_card_slice.dart';
import 'package:rover/patient/widget/table_row_slice.dart';

class PatientsTableRows extends StatelessWidget {
  final List<PatientsAppointment> patientsData;
  final List<PatientsTableColumnType> columnsOrder;
  final Consumer<PatientsAppointment> onRowTap;

  const PatientsTableRows({super.key, required this.patientsData, required this.onRowTap, required this.columnsOrder});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final itemCount = patientsData.length;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: itemCount,
        (context, rowIndex) => Container(
          color: appTheme?.colorScheme.grey100,
          padding: const EdgeInsets.symmetric(horizontal: 68.0),
          child: RoverCardSlice(
            padding: const EdgeInsets.only(left: LARGE_UI_GAP, right: LARGE_UI_GAP),
            child: TableRowSlice(
              onTap: () => onRowTap(patientsData[rowIndex]),
              last: rowIndex == itemCount - 1,
              cells: _buildRowCells(patientsData[rowIndex]).map((e) => RoverTableCell.expanded(child: e)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Iterable<Widget> _buildRowCells(PatientsAppointment data) {
    final patient = data.patient;
    final appointment = data.appointment;
    return columnsOrder.map(
      (columnType) => switch (columnType) {
        PatientsTableColumnType.phone => PatientPhoneCell(phone: patient.phoneNumber),
        PatientsTableColumnType.appointmentDate => AppointmentDateTableCell(date: appointment.date),
        PatientsTableColumnType.age => PatientAgeAndSexTableCell(birthDate: patient.dayOfBirth, gender: patient.gender),
        PatientsTableColumnType.name =>
          PersonNameAndEmailTableCell(fullName: patient.fullName, email: patient.email ?? ''),
        PatientsTableColumnType.status =>
          Align(alignment: Alignment.centerLeft, child: AppointmentStatusChip(status: appointment.status)),
      },
    );
  }
}
