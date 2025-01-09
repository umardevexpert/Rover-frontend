import 'package:rover/patient/model/gender.dart';

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final Gender gender;
  final DateTime dayOfBirth;
  final String? phoneNumber;
  final String? email;
  final String? doctorAbbreviation;

  // This is optimization for searching
  final String firstNameInLowerCase;
  final String lastNameInLowerCase;
  final String? emailInLowerCase;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dayOfBirth,
    required this.phoneNumber,
    required this.email,
    required this.doctorAbbreviation,
  })  : firstNameInLowerCase = firstName.toLowerCase(),
        lastNameInLowerCase = lastName.toLowerCase(),
        emailInLowerCase = email?.toLowerCase();

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Patient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          gender == other.gender &&
          dayOfBirth == other.dayOfBirth &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          doctorAbbreviation == other.doctorAbbreviation;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      gender.hashCode ^
      dayOfBirth.hashCode ^
      phoneNumber.hashCode ^
      email.hashCode ^
      doctorAbbreviation.hashCode;
}
