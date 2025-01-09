import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';

part 'open_dental_tooth_initials.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenDentalToothInitials implements Serializable {
  @JsonKey(name: 'ToothInitialNum')
  final int toothInitialNum;
  @JsonKey(name: 'PatNum')
  final int patientId;
  @JsonKey(name: 'ToothNum')
  final int toothNum;
  @JsonKey(name: 'InitialType')
  final String initialType;

  const OpenDentalToothInitials({
    required this.toothInitialNum,
    required this.patientId,
    required this.toothNum,
    required this.initialType,
  });

  factory OpenDentalToothInitials.fromJson(Map<String, dynamic> json) => _$OpenDentalToothInitialsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenDentalToothInitialsToJson(this);
}
