import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum CreateAccountFailure implements AuthFailure {
  invalidUsername(AuthFailureType.invalidUsername),
  usernameAlreadyInUse(AuthFailureType.usernameAlreadyInUse),
  weakPassword(AuthFailureType.weakPassword),
  noPermissionToCreateAccounts(AuthFailureType.noPermissionToCreateAccounts),

  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const CreateAccountFailure(this.authFailureType);
}
