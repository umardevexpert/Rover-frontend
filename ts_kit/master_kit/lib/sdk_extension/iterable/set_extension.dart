extension SetExtension<T> on Set<T> {
  void addOrRemoveIfExists(T value) => contains(value) ? remove(value) : add(value);
}
