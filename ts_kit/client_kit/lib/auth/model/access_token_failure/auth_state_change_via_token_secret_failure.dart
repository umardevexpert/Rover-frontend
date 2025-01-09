import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum AuthStateChangeViaAccessTokenFailure implements AuthFailure {
  invalidTokenSecret(AuthFailureType.invalidTokenSecret),
  tokenSecretNotFound(AuthFailureType.accessTokenNotFoundOrAssigned),
  userNotFound(AuthFailureType.userNotFound),
  userDisabled(AuthFailureType.userDisabled),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const AuthStateChangeViaAccessTokenFailure(this.authFailureType);
}
