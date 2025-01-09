import 'package:meta/meta.dart';

sealed class AuthState<TUserDetails> {
  const AuthState();
}

class InitialAuthState<TUserDetails> extends AuthState<TUserDetails> {
  const InitialAuthState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is InitialAuthState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class LoggedOutAuthState<TUserDetails> extends AuthState<TUserDetails> {
  const LoggedOutAuthState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LoggedOutAuthState && runtimeType == other.runtimeType;

  @override
  int get hashCode => 1;
}

@immutable
class LoggedInAuthState<TUserDetails> extends AuthState<TUserDetails> {
  final TUserDetails user;

  const LoggedInAuthState(this.user);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoggedInAuthState<TUserDetails> && runtimeType == other.runtimeType && user == other.user;

  @override
  int get hashCode => user.hashCode;
}
