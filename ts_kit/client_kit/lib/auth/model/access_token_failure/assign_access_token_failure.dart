import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum AssignAccessTokenFailure implements AuthFailure {
  invalidTokenSecret(AuthFailureType.invalidTokenSecret),
  tokenSecretAlreadyInUse(AuthFailureType.tokenSecretAlreadyInUse),
  accountNotFound(AuthFailureType.accountNotFound),
  noPermissionToAssignAccessToken(AuthFailureType.noPermissionToAssignAccessToken),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const AssignAccessTokenFailure(this.authFailureType);
}
