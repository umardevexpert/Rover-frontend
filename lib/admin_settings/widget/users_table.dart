import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rover/admin_settings/model/user_table_column_type.dart';
import 'package:rover/admin_settings/widget/user_role_chip.dart';
import 'package:rover/admin_settings/widget/user_status_chip.dart';
import 'package:rover/common/error/invalid_column_sort_exception.dart';
import 'package:rover/common/model/table_sorting_type.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/person_name_and_email_table_cell.dart';
import 'package:rover/common/widget/rover_table_cell.dart';
import 'package:rover/common/widget/rover_table_header_cell.dart';
import 'package:rover/common/widget/rover_table_header_label.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:rover/common/widget/sortable_rover_table.dart';
import 'package:rover/users_management/model/user.dart';
import 'package:rover/users_management/model/user_role.dart';

class UsersTable extends StatelessWidget {
  final List<User> users;

  UsersTable({super.key, required this.users});

  final _columnsOrder = [
    UserTableColumnType.name,
    UserTableColumnType.designation,
    UserTableColumnType.phone,
    UserTableColumnType.status,
    UserTableColumnType.details,
  ];

  @override
  Widget build(BuildContext context) {
    return SortableRoverTable(
      columnsOrder: _columnsOrder,
      tableData: users,
      headerCellBuilder: (_, column, sortingType, sortCallback) =>
          _headerCellBuilder(column, sortingType, sortCallback),
      rowCellBuilder: _rowCellBuilder,
      sortCallback: _sortRows,
      defaultSortColumn: UserTableColumnType.name,
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget _headerCellBuilder(
    UserTableColumnType columnType,
    TableSortingType sortingType,
    Consumer<UserTableColumnType> sortCallback,
  ) {
    Widget buildSortableHeaderCell(String label) {
      return RoverTableHeaderLabel(
        label: label,
        sortingType: sortingType,
        onSortingPressed: () => sortCallback(columnType),
      );
    }

    return RoverTableHeaderCell.expanded(
      child: switch (columnType) {
        UserTableColumnType.name => buildSortableHeaderCell('User'),
        UserTableColumnType.status => buildSortableHeaderCell('Status'),
        UserTableColumnType.designation => buildSortableHeaderCell('Designation'),
        UserTableColumnType.phone => RoverTableHeaderLabel(label: 'Phone number'),
        UserTableColumnType.details => SizedBox.shrink(),
      },
    );
  }

  Widget _rowCellBuilder(BuildContext context, UserTableColumnType columnType, User user) {
    final appTheme = AppTheme.of(context);
    final child = switch (columnType) {
      UserTableColumnType.designation => UserRoleChip(role: user.role),
      UserTableColumnType.status => UserStatusChip(active: !user.archived),
      UserTableColumnType.name =>
        PersonNameAndEmailTableCell(fullName: '${user.name} ${user.surname}', email: user.email),
      UserTableColumnType.phone =>
        Text(user.phone, style: appTheme?.textTheme.bodyM.copyWith(fontWeight: FontWeight.w500)),
      UserTableColumnType.details => SecondaryButton(
          buttonStyle: ButtonStyle(minimumSize: MaterialStatePropertyAll(Size(double.infinity, 0))),
          size: SecondaryButtonSize.large,
          onPressed: () => context.go('/admin-settings/users/${user.id}'),
          child: Text('Details'),
        ),
    };
    return RoverTableCell.expanded(child: child);
  }

  void _sortRows(UserTableColumnType column) {
    return switch (column) {
      UserTableColumnType.name => users.sort((a, b) => a.surname.compareTo(b.surname)),
      UserTableColumnType.designation => users.sort((a, b) => a.role.label.compareTo(b.role.label)),
      UserTableColumnType.status => users.sort((a, b) => b.archived ? -1 : 1),
      _ => throw InvalidColumnSortException(message: "This column can't be sorted"),
    };
  }
}
