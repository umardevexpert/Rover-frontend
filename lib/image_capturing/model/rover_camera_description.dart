class RoverCameraDescription {
  /// String value shows in the dropdown
  final String displayName;

  final String rawName;

  const RoverCameraDescription({required this.displayName, required this.rawName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoverCameraDescription &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName &&
          rawName == other.rawName;

  @override
  int get hashCode => displayName.hashCode ^ rawName.hashCode;

  RoverCameraDescription copyWith({String? displayName, String? rawName}) =>
      RoverCameraDescription(displayName: displayName ?? this.displayName, rawName: rawName ?? this.rawName);
}
