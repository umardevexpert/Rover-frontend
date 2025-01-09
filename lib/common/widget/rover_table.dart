import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:ui_kit/util/shared_type_definitions.dart';

class RoverTable<TColumnModel, TRowDataModel> extends StatelessWidget {
  final List<TColumnModel> columnsOrder;
  final List<TRowDataModel> tableData;
  final WidgetBuilder2<TColumnModel, TRowDataModel> cellBuilder;
  final WidgetBuilder1<TColumnModel> headerCellBuilder;
  final MainAxisSize mainAxisSize;

  const RoverTable({
    super.key,
    required this.columnsOrder,
    required this.tableData,
    required this.headerCellBuilder,
    required this.cellBuilder,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: appTheme?.colorScheme.grey200 ?? Colors.black),
        borderRadius: STANDARD_BORDER_RADIUS,
      ),
      child: Column(mainAxisSize: mainAxisSize, children: [_buildHeader(context, appTheme), _buildBody(appTheme)]),
    );
  }

  Widget _buildHeader(BuildContext context, AppTheme? appTheme) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: appTheme?.colorScheme.grey100,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
          ),
          child: Row(children: columnsOrder.map((columnModel) => headerCellBuilder(context, columnModel)).toList()),
        ),
        Divider(height: 0, thickness: 1, color: appTheme?.colorScheme.grey200),
      ],
    );
  }

  Widget _buildBody(AppTheme? appTheme) {
    return Flexible(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: tableData.length,
        separatorBuilder: (context, index) => Divider(color: appTheme?.colorScheme.grey200, height: 0, thickness: 1),
        itemBuilder: (context, index) => Row(
          children: columnsOrder.map((columnModel) => cellBuilder(context, columnModel, tableData[index])).toList(),
        ),
      ),
    );
  }
}
