import 'dart:async';

import 'package:client_kit/auth/contract/auth_service.dart';
import 'package:client_kit/auth/model/auth_event.dart';
import 'package:client_kit/auth/model/auth_event_type.dart';
import 'package:client_kit/auth/model/auth_state.dart';
import 'package:get_it/get_it.dart';
import 'package:master_kit/contracts/identifiable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthDependentStreamController<TUserDetails extends Identifiable, TData> implements Disposable {
  final _dataController = BehaviorSubject<TData?>();
  StreamSubscription<TData?>? _subscription;

  @protected
  late final Stream<TData?> stream = _dataController.stream;

  /// !!! IMPORTANT !!!
  ///
  /// When you use this value it doesn't automatically rebuild the widget!
  /// In case you want a widget that updates according to the changes of this controller use [stream] instead.
  @protected
  TData? get value => _dataController.valueOrNull;

  AuthDependentStreamController({required AuthService<TUserDetails> authService}) {
    _handleAuthStreamUpdates(authService.authStream);
    _handleEventStreamUpdates(authService.eventStream);
  }

  Future<void> _handleAuthStreamUpdates(Stream<AuthState<TUserDetails>> authStream) async {
    // BUG FIX: Added await for instead of listen
    // Await for processes events synchronously. If we were to use listen instead, the items would have
    // been processed in parallel (more can be read here: https://www.notion.so/typesoft/Dart-Flutter-1a3e24f4e9d1480cbfcb1b5a437301f0?pvs=4#9ce73d090a074a4fa0e9a3ff91aa37ae).
    // Parallel processing leads to possible race condition. Cancelling the subscription is asynchronous function, which
    // can take some time to cleanup after the stream. This can lead to situation, where we receive (for example) 2 different
    // auth events and the first event will take longer to cancel its stream (leading to bug, where the second auth event
    // does not cancel the first ones subscription, because it was not created yet) and afterwards, both events create
    // new listeners (and the first one will never be cancelled)
    await for (final authState in authStream) {
      if (authState is LoggedInAuthState<TUserDetails>) {
        final stream = obtainStreamWhenLoggedIn(authState.user);
        if (stream == null) {
          _dataController.add(null);
        } else {
          // BUG FIX: Added subscription cancel
          // Since authStream and eventStream is handled in parallel, the scheduler can decide process authStream first.
          // This leads to a bug, where previous subscription is not canceled and both exist in the app concurrently
          // (and the previous one will never be cancelled after that).
          await _subscription?.cancel();
          _subscription = stream.listen(_dataController.add);
        }
      }
    }
  }

  Future<void> _handleEventStreamUpdates(Stream<AuthEvent<TUserDetails>> eventStream) async {
    // BUG FIX: Added await for instead of listen - same as above
    await for (final event in eventStream) {
      if (event.type == AuthEventType.willChangeAuthState && event.newState is LoggedOutAuthState) {
        await onLogout();
        await _subscription?.cancel();
        _subscription = null;
        _dataController.add(null);
      }
    }
  }

  Stream<TData?>? obtainStreamWhenLoggedIn(TUserDetails initialSignedInUser);

  FutureOr<void> onLogout() {}

  @mustCallSuper
  @override
  FutureOr<void> onDispose() {
    _subscription?.cancel();
  }
}
