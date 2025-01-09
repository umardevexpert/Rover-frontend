import 'package:client_kit/auth/model/auth_failure.dart';
import 'package:master_kit/sdk_extension/object_extension.dart';

sealed class AuthResult<TAuthFailureType extends AuthFailure> {
  const AuthResult();

  factory AuthResult.success() => AuthResultSuccess<TAuthFailureType>();

  factory AuthResult.withError(TAuthFailureType failure) => AuthResultFailure<TAuthFailureType>(failure);
}

class AuthResultSuccess<TAuthFailureType extends AuthFailure> extends AuthResult<TAuthFailureType> {
  const AuthResultSuccess();
}

class AuthResultFailure<TAuthFailureType extends AuthFailure> extends AuthResult<TAuthFailureType> {
  final TAuthFailureType failure;

  const AuthResultFailure(this.failure);
}

extension AuthResultExtension<TAuthFailureType extends AuthFailure> on AuthResult<TAuthFailureType> {
  bool get isFailure => this is AuthResultFailure;

  bool get isSuccess => !isFailure;

  TAuthFailureType? get failure => maybeCast<AuthResultFailure<TAuthFailureType>>()?.failure;
}
