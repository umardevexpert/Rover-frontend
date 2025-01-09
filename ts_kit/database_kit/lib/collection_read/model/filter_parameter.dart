part of 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';

@immutable
class FilterParameter extends AbstractFilterParameter {
  final String field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final Object? arrayDoesNotContain;
  final List<Object?>? arrayContainsAny;
  final List<Object?>? arrayContainsAll;
  final List<Object?>? whereIn;
  final bool? exists;
  final bool? isNull;

  const FilterParameter(
    this.field, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayDoesNotContain,
    this.arrayContainsAny,
    this.arrayContainsAll,
    this.whereIn,
    this.exists,
    this.isNull,
  }) : assert(isEqualTo != null ||
            isNotEqualTo != null ||
            isLessThan != null ||
            isLessThanOrEqualTo != null ||
            isGreaterThan != null ||
            isGreaterThanOrEqualTo != null ||
            arrayContains != null ||
            arrayDoesNotContain != null ||
            arrayContainsAny != null ||
            arrayContainsAll != null ||
            whereIn != null ||
            exists != null ||
            isNull != null);
}
