import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum DeleteAccessTokenFailure implements AuthFailure {
  accessTokenNotFound(AuthFailureType.accessTokenNotFound),
  noPermissionToDeleteAccessToken(AuthFailureType.noPermissionToDeleteAccessToken),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const DeleteAccessTokenFailure(this.authFailureType);
}
