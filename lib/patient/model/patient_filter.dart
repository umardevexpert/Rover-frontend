import 'package:collection/collection.dart';
import 'package:master_kit/util/reference_wrapper.dart';
import 'package:rover/patient/model/age_range.dart';

const _SET_EQUALITY = SetEquality<AgeRange>();

class PatientFilter {
  final String searchedPhrase;
  final ReferenceWrapper<DateTime?> fromAppointmentDate;
  final ReferenceWrapper<DateTime?> toAppointmentDate;
  final Set<AgeRange> ageRanges;

  DateTime? get fromDate => fromAppointmentDate.wrapped;
  DateTime? get toDate => toAppointmentDate.wrapped;

  const PatientFilter({
    this.searchedPhrase = '',
    this.fromAppointmentDate = const ReferenceWrapper(null),
    this.toAppointmentDate = const ReferenceWrapper(null),
    this.ageRanges = const {},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientFilter &&
          runtimeType == other.runtimeType &&
          searchedPhrase == other.searchedPhrase &&
          fromAppointmentDate.wrapped == other.fromAppointmentDate.wrapped &&
          toAppointmentDate.wrapped == other.toAppointmentDate.wrapped &&
          _SET_EQUALITY.equals(ageRanges, other.ageRanges);

  @override
  int get hashCode =>
      searchedPhrase.hashCode ^
      fromAppointmentDate.wrapped.hashCode ^
      toAppointmentDate.wrapped.hashCode ^
      _SET_EQUALITY.hash(ageRanges);

  PatientFilter copyWith({
    String? searchedPhrase,
    ReferenceWrapper<DateTime?>? fromAppointmentDate,
    ReferenceWrapper<DateTime?>? toAppointmentDate,
    Set<AgeRange>? ageRanges,
  }) {
    return PatientFilter(
      searchedPhrase: searchedPhrase ?? this.searchedPhrase,
      fromAppointmentDate: fromAppointmentDate ?? this.fromAppointmentDate,
      toAppointmentDate: toAppointmentDate ?? this.toAppointmentDate,
      ageRanges: ageRanges ?? this.ageRanges,
    );
  }
}
