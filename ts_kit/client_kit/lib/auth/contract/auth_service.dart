import 'package:client_kit/auth/model/auth_event.dart';
import 'package:client_kit/auth/model/auth_state.dart';
import 'package:master_kit/contracts/identifiable.dart';

abstract interface class AuthService<TUserDetails extends Identifiable> {
  /// Emits [AuthEvent] values on auth change. This stream is updated ONLY on an auth change and the emitted values
  /// will contain [TUserDetails] that were received when auth change event was received (I.E. when user signs in
  /// or signs out).
  Stream<AuthEvent<TUserDetails>> get eventStream;

  /// Emits the [AuthState] and [TUserDetails] on auth change. This stream contains only [TUserDetails] received
  /// on an auth change (I.E. when user signs in or signs out). If you wish to observe current [TUserDetails],
  /// use [signedInUserStream]
  Stream<AuthState<TUserDetails>> get authStream;

  /// The [signedInUserStream] observes the current [TUserDetails]. The difference between [signedInUserStream] and
  /// [authStream] is that [authStream] only emits [TUserDetails] on auth changes and [signedInUserStream] also emits
  /// values when the [TUserDetails] stream changes.
  Stream<TUserDetails?> get signedInUserStream;

  TUserDetails? get signedInUser;

  Future<void> signOut();
}
