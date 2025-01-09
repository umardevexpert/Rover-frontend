import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:rover/open_dental_connection/json_parsing_helper.dart';

part 'open_dental_appointment.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenDentalAppointment implements Serializable {
  @JsonKey(name: 'AptNum')
  final int id;
  @JsonKey(name: 'PatNum')
  final int patientId;
  @JsonKey(name: 'AptDateTime')
  final DateTime date;
  @JsonKey(name: 'provAbbr', readValue: nullIfEmptyString)
  final String? providerAbbreviation;

  const OpenDentalAppointment({
    required this.id,
    required this.patientId,
    required this.date,
    required this.providerAbbreviation,
  });

  factory OpenDentalAppointment.fromJson(Map<String, dynamic> json) => _$OpenDentalAppointmentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenDentalAppointmentToJson(this);
}
