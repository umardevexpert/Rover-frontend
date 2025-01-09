import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';
import 'package:master_kit/contracts/serializable.dart';

extension CollectionObserverExtension<T extends Serializable> on CollectionObserver<T> {
  Stream<T?> observeFirst({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
  }) =>
      observeDocs(filters: filters, sortBy: sortBy, limit: 1).map((event) => event.firstOrNull);
}
