import 'dart:async';

import 'package:rxdart/rxdart.dart';

extension StreamExtension<T> on Stream<T> {
  /// Returns ValueStream that is broadcast stream as well. This stream is done when the original stream is done (which
  /// is only when the original stream is canceled via its StreamController). The returned broadcast stream is not
  /// canceled when all its subscriptions are canceled (standard broadcast stream behaviour).
  ValueStream<T> asValueBroadcastStream() {
    if (this is ValueStream<T> && isBroadcast) {
      return this as ValueStream<T>;
    }
    // could also be implemented very shortly as `return publishValue()..connect();` (no, there is no memory leak or any
    // other issue) but this is more explicit and clear about what it does
    final valueConnectableController = BehaviorSubject<T>(sync: true);
    StreamSubscription<T>? subscription;
    subscription = listen(
      valueConnectableController.add,
      onDone: () {
        subscription?.cancel();
        valueConnectableController.close();
      },
      onError: valueConnectableController.addError,
    );
    return valueConnectableController.stream;
  }
}
