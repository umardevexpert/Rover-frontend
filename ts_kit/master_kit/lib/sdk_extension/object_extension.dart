import 'package:master_kit/util/shared_type_definitions.dart';

extension ObjectExtension<T> on T {
  // TODO(rasto): rename to asOrNull
  TCast? maybeCast<TCast>() {
    final self = this;
    return self is TCast ? self : null;
  }

  // TODO(rasto): rename to asSubtypeOrNull
  TSubtype? maybeSubtype<TSubtype extends T>() => maybeCast<TSubtype>();

  TResult byCalling<TResult>(Projector<T, TResult> transformer) => transformer(this);
}
