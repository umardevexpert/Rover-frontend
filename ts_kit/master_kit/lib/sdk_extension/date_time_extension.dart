extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  // Excluding
  DateTime get endOfDay => startOfDay.add(Duration(days: 1));

  DateTime get endOfDayInclusive => endOfDay.subtract(Duration(microseconds: 1));

  DateTime get endOfYearInclusive => DateTime(year, 12, 31).endOfDayInclusive;

  DateTime get startOfMonth => DateTime(year, month);

  int get numberOfDaysInMonth {
    final startOfCurrentMonth = startOfMonth;
    final nextMonth = DateTime(year, month + 1);

    return nextMonth.difference(startOfCurrentMonth).inDays;
  }
}
