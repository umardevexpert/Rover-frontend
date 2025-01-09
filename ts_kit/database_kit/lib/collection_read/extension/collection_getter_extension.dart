import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';
import 'package:master_kit/contracts/serializable.dart';

extension CollectionGetterExtension<T extends Serializable> on CollectionGetter<T> {
  Future<T?> readFirst({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
  }) =>
      getDocuments(filters: filters, sortBy: sortBy, limit: 1).then((event) => event.firstOrNull);
}
