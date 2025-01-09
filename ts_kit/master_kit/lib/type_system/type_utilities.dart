final class _EmptyGenericWrapper<T> {
  const _EmptyGenericWrapper();
}

bool isSubtypeOf<TCandidate, TSuperType>() => _EmptyGenericWrapper<TCandidate>() is _EmptyGenericWrapper<TSuperType>;
