import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:rover/open_dental_connection/json_parsing_helper.dart';

part 'open_dental_treatment.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenDentalTreatment implements Serializable {
  @JsonKey(name: 'ProcTPNum')
  final int id;
  @JsonKey(name: 'ToothNumTP')
  final String toothNumber;
  @JsonKey(name: 'ProcCode')
  final String adaCode;
  @JsonKey(name: 'Surf', readValue: nullIfEmptyString)
  final String? toothSurface;
  @JsonKey(name: 'Descript', readValue: nullIfEmptyString)
  final String? description;
  @JsonKey(name: 'DateTP')
  final DateTime date;

  OpenDentalTreatment({
    required this.id,
    required this.toothNumber,
    required this.adaCode,
    required this.toothSurface,
    required this.description,
    required this.date,
  });

  factory OpenDentalTreatment.fromJson(Map<String, dynamic> json) => _$OpenDentalTreatmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenDentalTreatmentToJson(this);
}
