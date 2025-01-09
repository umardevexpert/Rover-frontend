import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:client_kit/auth/model/auth_failure_type.dart';

enum ValidateTokenSecretResult implements AuthFailure {
  invalidTokenSecret(AuthFailureType.invalidTokenSecret),
  tokenSecretAlreadyInUse(AuthFailureType.tokenSecretAlreadyInUse),
  tooManyRequests(AuthFailureType.tooManyRequests),
  connectionFailure(AuthFailureType.connectionFailure),
  other(AuthFailureType.other);

  @override
  final AuthFailureType authFailureType;

  const ValidateTokenSecretResult(this.authFailureType);
}
