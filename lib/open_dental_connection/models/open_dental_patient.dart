import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:rover/open_dental_connection/json_parsing_helper.dart';

part 'open_dental_patient.g.dart';

@JsonSerializable(explicitToJson: true)
class OpenDentalPatient implements Serializable {
  @JsonKey(name: 'PatNum')
  final int id;
  @JsonKey(name: 'FName')
  final String firstName;
  @JsonKey(name: 'LName')
  final String lastName;
  @JsonKey(name: 'Gender', defaultValue: 'Other')
  final String gender;
  @JsonKey(name: 'Birthdate')
  final DateTime dayOfBirth;
  @JsonKey(name: 'HmPhone', readValue: nullIfEmptyString)
  final String? homePhoneNumber;
  @JsonKey(name: 'WkPhone', readValue: nullIfEmptyString)
  final String? workPhoneNumber;
  @JsonKey(name: 'WirelessPhone', readValue: nullIfEmptyString)
  final String? wirelessPhoneNumber;
  @JsonKey(name: 'Email', readValue: nullIfEmptyString)
  final String? email;
  @JsonKey(name: 'priProvAbbr',readValue: nullIfEmptyString)
  final String? providerAbbreviation;

  const OpenDentalPatient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dayOfBirth,
    required this.email,
    required this.homePhoneNumber,
    required this.workPhoneNumber,
    required this.wirelessPhoneNumber,
    required this.providerAbbreviation
  });

  factory OpenDentalPatient.fromJson(Map<String, dynamic> json) => _$OpenDentalPatientFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$OpenDentalPatientToJson(this);
}
