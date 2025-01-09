import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum DeleteAccountFailure implements AuthFailure {
  accountNotFound(AuthFailureType.accountNotFound),
  noPermissionToDeleteAccounts(AuthFailureType.noPermissionToDeleteAccounts),
  userNotFound(AuthFailureType.userNotFound),
  userDisabled(AuthFailureType.userDisabled),

  userNotLoggedIn(AuthFailureType.userNotLoggedIn),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const DeleteAccountFailure(this.authFailureType);
}
