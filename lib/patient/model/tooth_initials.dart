class ToothInitials {
  final int toothInitialNum;
  final int patientId;
  final int toothNum;
  final String initialType;

  ToothInitials({
    required this.toothInitialNum,
    required this.patientId,
    required this.toothNum,
    required this.initialType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToothInitials &&
          runtimeType == other.runtimeType &&
          toothInitialNum == other.toothInitialNum &&
          patientId == other.patientId &&
          toothNum == other.toothNum &&
          initialType == other.initialType;

  @override
  int get hashCode => toothInitialNum.hashCode ^ patientId.hashCode ^ toothNum.hashCode ^ initialType.hashCode;
}
