import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';

abstract interface class CollectionObserver<T> {
  Stream<List<T>> observeDocs({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    int? limit,
  });

  Stream<T?> observeDocument(String id);

  Stream<List<T>> observeDocumentsByIds(List<String> ids, {List<SortingParameter> sortBy = const []});
}
