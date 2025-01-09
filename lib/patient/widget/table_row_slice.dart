import 'package:flutter/material.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/widget/table_header.dart';

class TableRowSlice extends StatelessWidget {
  final bool first;
  final bool last;
  final VoidCallback? onTap;
  final List<Widget> cells;

  const TableRowSlice({super.key, this.first = false, this.last = false, this.onTap, required this.cells});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: appTheme?.colorScheme.grey200 ?? Colors.black,
          borderRadius: BorderRadius.vertical(
            top: first ? Radius.circular(8.0) : Radius.zero,
            bottom: last ? Radius.circular(8.0) : Radius.zero,
          ),
        ),
        width: double.infinity,
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(left: 1, right: 1, top: first ? 1 : 0, bottom: !first ? 1 : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: first ? Radius.circular(7.0) : Radius.zero,
              bottom: last ? Radius.circular(7.0) : Radius.zero,
            ),
          ),
          child: first ? TableHeader(columnLabels: cells) : Row(children: cells),
        ),
      ),
    );
  }
}
