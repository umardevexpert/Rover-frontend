import 'package:client_kit/auth/model/auth_event_type.dart';
import 'package:client_kit/auth/model/auth_state.dart';

class AuthEvent<TUserDetails> {
  final AuthEventType type;
  final AuthState<TUserDetails> previousState;
  final AuthState<TUserDetails> newState;

  const AuthEvent({required this.type, required this.previousState, required this.newState});

  bool get didSignIn =>
      previousState is LoggedOutAuthState && newState is LoggedInAuthState && type == AuthEventType.didChangeAuthState;

  bool get willSignOut =>
      previousState is LoggedInAuthState && newState is LoggedOutAuthState && type == AuthEventType.willChangeAuthState;
}
