import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';

part 'open_dental_treatment_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenDentalTreatmentPlan implements Serializable {
  @JsonKey(name: 'TreatPlanNum')
  final int id;

  // TODO(matej): Make sure it's really this key
  @JsonKey(name: 'Heading')
  final String name;

  OpenDentalTreatmentPlan({required this.id, required this.name});

  factory OpenDentalTreatmentPlan.fromJson(Map<String, dynamic> json) => _$OpenDentalTreatmentPlanFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenDentalTreatmentPlanToJson(this);
}
