import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';
import 'package:master_kit/sdk_extension/date_time_extension.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/app_root.dart';
import 'package:ui_kit/input/dropdown/widget/drop_down.dart';

const _MAX_VISIBLE_DROPDOWN_OPTIONS = 5;

enum DateRangeMode { rangeStart, rangeEnd }

class DateTimePicker extends StatelessWidget {
  final DateRangeMode dateRangeMode;
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final String label;

  const DateTimePicker.from({
    super.key,
    this.value,
    this.onChanged,
    this.label = 'From',
  }) : dateRangeMode = DateRangeMode.rangeStart;

  const DateTimePicker.to({
    super.key,
    this.value,
    this.onChanged,
    this.label = 'To',
  }) : dateRangeMode = DateRangeMode.rangeEnd;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final topPortalScopeLabels = [TOP_PORTAL_LAYER_ID];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: appTheme?.textTheme.titleM),
        SMALLER_GAP,
        Row(
          children: [
            SizedBox(
              width: 80,
              height: STANDARD_INPUT_HEIGHT,
              child: DropDown(
                placeholder: 'Day',
                value: value?.day,
                onChanged: _handleDayChange,
                options: List<int>.generate(
                  value == null ? DateTime.now().numberOfDaysInMonth : value!.numberOfDaysInMonth,
                  (i) => i + 1,
                ),
                maxPopupRows: _MAX_VISIBLE_DROPDOWN_OPTIONS,
                portalScopeLabels: topPortalScopeLabels,
              ),
            ),
            SizedBox(
              width: 100,
              height: STANDARD_INPUT_HEIGHT,
              child: DropDown(
                placeholder: 'Month',
                value: value?.month,
                onChanged: _handleMonthChange,
                displayStringForOption: (n) => DateFormat.LLL().format(DateTime(0, n)),
                options: List<int>.generate(12, (i) => i + 1),
                maxPopupRows: _MAX_VISIBLE_DROPDOWN_OPTIONS,
                portalScopeLabels: topPortalScopeLabels,
              ),
            ),
            SizedBox(
              width: 90,
              height: STANDARD_INPUT_HEIGHT,
              child: DropDown(
                placeholder: 'Year',
                value: value?.year,
                onChanged: _handleYearChange,
                options: List<int>.generate(30, (i) => DateTime.now().year - 15 + i),
                maxPopupRows: _MAX_VISIBLE_DROPDOWN_OPTIONS,
                portalScopeLabels: topPortalScopeLabels,
              ),
            ),
            IconButton(
              splashRadius: 20,
              onPressed: () => onChanged?.call(null),
              icon: Icon(Icons.clear, color: appTheme?.colorScheme.grey500),
            )
          ].intersperse(SMALLER_GAP).toList(),
        )
      ],
    );
  }

  void _handleDayChange(int day) {
    if (value == null) {
      final currentDay = DateTime.now();
      _callOnChangedWithStartOrEndOfDay(DateTime(currentDay.year, currentDay.month, day));
    } else {
      _callOnChangedWithStartOrEndOfDay(DateTime(value!.year, value!.month, day));
    }
  }

  void _handleYearChange(int year) {
    if (value == null) {
      _callOnChangedWithStartOrEndOfDay(_getBeginningOrEndOfYear(year));
    } else {
      _callOnChangedWithStartOrEndOfDay(
        DateTime(year, value!.month, _getLastDayInSelectedMonthIfNecessary(year: year, month: value!.month)),
      );
    }
  }

  void _handleMonthChange(int month) {
    if (value == null) {
      final currentYear = DateTime.now().year;
      _callOnChangedWithStartOrEndOfDay(
        DateTime(currentYear, month, _getFirstOrLastDayOfMonthYear(year: currentYear, month: month)),
      );
    } else {
      _callOnChangedWithStartOrEndOfDay(
        DateTime(value!.year, month, _getLastDayInSelectedMonthIfNecessary(year: value!.year, month: month)),
      );
    }
  }

  int _getFirstOrLastDayOfMonthYear({required int year, required int month}) {
    return dateRangeMode == DateRangeMode.rangeStart ? 1 : DateTime(year, month).numberOfDaysInMonth;
  }

  DateTime _getBeginningOrEndOfYear(int year) {
    return dateRangeMode == DateRangeMode.rangeStart ? DateTime(year) : DateTime(year).endOfYearInclusive;
  }

  int _getLastDayInSelectedMonthIfNecessary({required int year, required int month}) {
    final numberOfDaysInMonthYear = DateTime(year, month).numberOfDaysInMonth;
    return value!.day > numberOfDaysInMonthYear ? numberOfDaysInMonthYear : value!.day;
  }

  void _callOnChangedWithStartOrEndOfDay(DateTime newDateTime) {
    onChanged?.call(dateRangeMode == DateRangeMode.rangeStart ? newDateTime.startOfDay : newDateTime.endOfDayInclusive);
  }
}
