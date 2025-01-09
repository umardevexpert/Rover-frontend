import 'package:collection/collection.dart';

import 'package:master_kit/util/shared_type_definitions.dart';

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinct() sync* {
    final found = <T>{};

    // BUG FIX: the following implementation did not work for some really strange reason (like it removed all the elements):
    // return where((element) => found.add(element));

    for (final elem in this) {
      if (!found.contains(elem)) {
        yield elem;
        found.add(elem);
      }
    }
  }

  Iterable<(T, T)> consecutivePairs() sync* {
    if (isEmpty) {
      return;
    }

    final iterator = this.iterator;

    if (!iterator.moveNext()) {
      return;
    }
    var current = iterator.current;

    while (iterator.moveNext()) {
      final next = iterator.current;
      yield (current, next);
      current = next;
    }
  }

  Map<TKey, List<TValue>> groupBy<TKey, TValue>({
    required Projector<T, TKey> keySelector,
    Projector<T, TValue>? valueSelector,
  }) {
    return groupReduce(
      keySelector: keySelector,
      groupReducer: (currentList, newValue) =>
          (currentList ?? [])..add(valueSelector?.call(newValue) ?? newValue as TValue),
    );
  }

  Map<TKey, TGroup> groupReduce<TKey, TGroup>({
    required Projector<T, TKey> keySelector,
    required TGroup Function(TGroup?, T) groupReducer,
  }) {
    final result = <TKey, TGroup>{};

    for (final element in this) {
      final key = keySelector(element);
      result[key] = groupReducer(result[key], element);
    }

    return result;
  }

  bool containsAny(Iterable<Object?> other) => other.any(contains);

  Iterable<T> intersperseWithIndexedGenerative(T Function(int) func) sync* {
    final iterator = this.iterator;

    if (iterator.moveNext()) {
      yield iterator.current;
    }

    var index = 0;

    while (iterator.moveNext()) {
      yield func(index);
      index++;
      yield iterator.current;
    }
  }
}

extension NullableIterableExtension<T> on Iterable<T>? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  bool get isNotNullNotEmpty => !isNullOrEmpty;
}

extension IterableIntExtension on Iterable<int> {
  bool isSequence() {
    return consecutivePairs().every((pair) => pair.$2 - pair.$1 == 1);
  }

  bool isSequencePermutation() {
    return distinct().length == length && max - min + 1 == length;
  }
}
