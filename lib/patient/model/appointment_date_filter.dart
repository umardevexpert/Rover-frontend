class AppointmentDateFilter {
  /// Inclusive
  final DateTime? startDate;

  /// Inclusive
  final DateTime? endDate;

  /// The range is **inclusive**.
  /// Set the same date for both for a single day
  /// Set only startDate/endDate for all since/before (inclusive) that date
  AppointmentDateFilter({this.startDate, this.endDate})
      : assert(startDate != null || endDate != null, 'You must set either start or end date');
}
