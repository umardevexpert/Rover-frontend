class Treatment {
  final String id;
  final String toothNumber;
  final String adaCode;
  final String? toothSurface;
  final String? description;
  final DateTime date;

  Treatment({
    required this.id,
    required this.toothNumber,
    required this.adaCode,
    required this.toothSurface,
    required this.description,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Treatment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          toothNumber == other.toothNumber &&
          adaCode == other.adaCode &&
          toothSurface == other.toothSurface &&
          description == other.description &&
          date == other.date;

  @override
  int get hashCode =>
      id.hashCode ^
      toothNumber.hashCode ^
      adaCode.hashCode ^
      toothSurface.hashCode ^
      description.hashCode ^
      date.hashCode;
}
