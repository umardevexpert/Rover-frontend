import 'package:client_kit/auth/model/auth_failure_type.dart';

abstract class AuthFailure implements Enum {
  AuthFailureType get authFailureType;
}
