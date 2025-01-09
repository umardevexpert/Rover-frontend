import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/data_with_loading_state.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';

abstract interface class CollectionObserverWithState<T> implements CollectionObserver<T> {
  @override
  Stream<List<T>> observeDocs({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    int? limit,
    bool ignoreCached = false,
    bool ignoreWithPendingChanges = false,
  });

  Stream<DataWithLoadingState<List<T>>> observeDocsWithState({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    int? limit,
  });

  @override
  Stream<T?> observeDocument(
    String id, {
    bool ignoreLocal = false,
    bool ignoreWithPendingChanges = false,
  });

  Stream<DataWithLoadingState<T>> observeDocumentWithState(String id);
}
