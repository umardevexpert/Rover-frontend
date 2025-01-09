import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum UsernameSignInFailure implements AuthFailure {
  userNotFound(AuthFailureType.userNotFound),
  userDisabled(AuthFailureType.userDisabled),
  wrongPassword(AuthFailureType.wrongPassword),
  weakPassword(AuthFailureType.weakPassword),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const UsernameSignInFailure(this.authFailureType);
}
