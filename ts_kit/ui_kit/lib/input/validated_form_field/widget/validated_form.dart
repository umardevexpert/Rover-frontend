import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';

class ValidatedForm extends Form {
  const ValidatedForm({super.key, required super.child, super.onChanged, super.onWillPop, super.autovalidateMode});

  static ValidatedFormState? of(BuildContext context) => Form.of(context).maybeSubtype<ValidatedFormState>();

  @override
  ValidatedFormState createState() => ValidatedFormState();
}

class ValidatedFormState extends FormState {
  final Map<String, String> _validationIdToError = {};
  bool _validationIncludingExplicitInProgress = false;

  // Map<String, String> get validationIdToMessage => Map.unmodifiable(_validationIdToMessage);

  void clearExplicitValidations() => _validationIdToError.clear();

  String? getExplicitValidationForId(String validationId) => _validationIdToError[validationId];

  String? getExplicitValidationWithIdIfValidatingExplicit(String validationId) {
    if (!_validationIncludingExplicitInProgress) {
      return null;
    }
    return _validationIdToError[validationId];
  }

  void setExplicitValidation({required String validationId, required String? message}) {
    if (message == null) {
      _validationIdToError.remove(validationId);
      return;
    }
    _validationIdToError[validationId] = message;
  }

  void addExplicitValidations(Map<String, String> validationErrors) => _validationIdToError.addAll(validationErrors);

  void setExplicitValidations(Map<String, String> validationErrors) {
    clearExplicitValidations();
    addExplicitValidations(validationErrors);
  }

  bool validateIncludingExplicit() {
    _validationIncludingExplicitInProgress = true;
    final validationSuccessful = validate();
    _validationIncludingExplicitInProgress = false;
    return validationSuccessful;
  }
}
