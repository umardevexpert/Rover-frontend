import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/util/auth_failure_type_extension.dart';

extension AuthFailureExtension on AuthFailure {
  String get errorDescription => authFailureType.defaultUIMessage;
}
