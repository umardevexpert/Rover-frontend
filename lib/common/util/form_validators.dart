import 'package:email_validator/email_validator.dart';

class FormValidators {
  const FormValidators._();

  static String? validateNotNull(dynamic value, {String? message}) {
    if (value == null) {
      return message ?? 'Please provide a non-empty value.';
    }
    return null;
  }

  static String? validateNotNullAndNotEmpty(String? value, {String? message}) {
    final validationResult = validateNotNull(value, message: message);
    if (validationResult != null) {
      return validationResult;
    }
    if (value!.trim().isEmpty) {
      return message ?? 'Please provide a non-empty value.';
    }
    return null;
  }

  static String? validateEmail(String? email, {String? message}) {
    final validationResult = validateNotNullAndNotEmpty(email, message: message);

    if (validationResult != null) {
      return validationResult;
    }

    if (!EmailValidator.validate(email!)) {
      return message ?? 'Email format is invalid.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? number, {String? message}) {
    final validationResult = validateNotNullAndNotEmpty(number, message: message);

    if (validationResult != null) {
      return validationResult;
    }

    const PHONE_NUMBER_REGEX = r'((\+\d{1,2}\s?)?1?\-?\.?\s?\(?\d{3}\)?[\s.-]?)?\d{3}[\s.-]?\d{4}';
    if (!RegExp(PHONE_NUMBER_REGEX).hasMatch(number!)) {
      return message ?? 'Phone number is invalid.';
    }
    return null;
  }

  static String? validatePasswordStrength(String? password, {String? message}) {
    final validationResult = validateNotNullAndNotEmpty(password, message: message);

    if (validationResult != null) {
      return validationResult;
    }

    if (password!.length < 8 ||
        !password.contains(RegExp('[A-Z]')) ||
        !password.contains(RegExp('[0-9]')) ||
        !password.contains(RegExp('[a-z]'))) {
      return message ?? 'Min. eight characters with one lowercase letter, one uppercase letter, one number.';
    }
    return null;
  }
}
