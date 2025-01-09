class AgeRange {
  final int? fromAge;
  final int? toAge;

  const AgeRange({this.fromAge, this.toAge});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgeRange && runtimeType == other.runtimeType && fromAge == other.fromAge && toAge == other.toAge;

  @override
  int get hashCode => fromAge.hashCode ^ toAge.hashCode;
}
