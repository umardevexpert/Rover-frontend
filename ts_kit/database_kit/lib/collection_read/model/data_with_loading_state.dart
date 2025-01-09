class DataWithLoadingState<T> {
  final T? data;
  final bool isLoaded;
  final bool isFromCache;
  final bool hasPendingWrites;

  const DataWithLoadingState(this.data, this.isLoaded, this.isFromCache, this.hasPendingWrites);
  const DataWithLoadingState.initial()
      : data = null,
        isLoaded = false,
        isFromCache = false,
        hasPendingWrites = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataWithLoadingState &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          isLoaded == other.isLoaded &&
          isFromCache == other.isFromCache &&
          hasPendingWrites == other.hasPendingWrites;

  @override
  int get hashCode => data.hashCode ^ isLoaded.hashCode ^ isFromCache.hashCode ^ hasPendingWrites.hashCode;

  @override
  String toString() {
    return 'DataWithLoadingState{data: $data, isLoaded: $isLoaded, isFromCache: $isFromCache, hasPendingWrites: $hasPendingWrites}';
  }
}

enum EntityState { unknown, doesNotExist, loaded }
