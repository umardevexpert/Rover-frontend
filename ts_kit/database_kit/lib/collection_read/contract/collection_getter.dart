import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';

abstract interface class CollectionGetter<T> {
  Future<List<T>> getDocuments({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    int? limit,
  });

  Future<T?> getDocument(String id);

  Future<bool> documentExists(String id);

  Future<List<T>> getDocumentsByIds(List<String> ids, {List<SortingParameter> sortBy = const []});
}
