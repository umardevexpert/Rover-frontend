import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum ChangePasswordFailure implements AuthFailure {
  userDisabled(AuthFailureType.userDisabled),
  wrongPassword(AuthFailureType.wrongPassword),
  weakPassword(AuthFailureType.weakPassword),
  userNotLoggedIn(AuthFailureType.userNotLoggedIn),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const ChangePasswordFailure(this.authFailureType);
}
