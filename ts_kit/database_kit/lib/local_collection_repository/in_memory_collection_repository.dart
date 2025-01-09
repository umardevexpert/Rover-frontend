import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:database_kit/collection_read/model/abstract_filter_parameter.dart';
import 'package:database_kit/collection_read/model/data_with_loading_state.dart';
import 'package:database_kit/collection_read/model/sorting_parameter.dart';
import 'package:database_kit/collection_read_write/collection_with_state_repository.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:master_kit/util/shared_type_definitions.dart';
import 'package:rxdart/rxdart.dart';

const _UNORDERED_DEEP_COLLECTION_EQUALITY = DeepCollectionEquality.unordered();

/// To be used only during development or for mocking when testing
class InMemoryCollectionRepository<T extends Serializable> implements CollectionWithStateRepository<T> {
  final BehaviorSubject<Map<String, T>> _behaviorSubject;
  final DocDeserializer<T> mapper;

  @override
  Object get deleteField => UnimplementedError('deleteField server-side atomic operation is not implemented for '
      '$InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository to gain access to this feature.');
  @override
  Object get serverTimestamp => UnimplementedError('serverTimestamp server-side atomic operation is not implemented for'
      ' $InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository to access this operation.');
  @override
  Object increment(num value) => UnimplementedError('increment server-side atomic operation is not implemented for '
      '$InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository to gain access to this feature.');
  @override
  Object arrayUnion<TElement>(List<TElement> toAdd) => UnimplementedError('arrayUnion server-side atomic operation '
      'is not implemented for $InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository to get '
      'access to this operation.');
  @override
  Object arrayAppend<TElement>(List<TElement> toAppend) => UnimplementedError('arrayAppend server-side atomic operation'
      ' is not implemented for $InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository to get '
      'access to this operation.');
  @override
  Object arrayDeleteValues<TElement>(List<TElement> toDelete) => UnimplementedError('arrayDelete server-side atomic '
      'operation is not implemented for $InMemoryCollectionRepository. Use another implementation of $CollectionWithStateRepository '
      'to access this operation.');

  InMemoryCollectionRepository({required this.mapper, Map<String, T>? seed})
      : _behaviorSubject = BehaviorSubject<Map<String, T>>.seeded(seed ?? {});

  @override
  Future<String> create(T newData, {String? id}) {
    id ??= generateRandomString();
    _behaviorSubject.add(_behaviorSubject.value..[id] = newData);
    return Future.value(id);
  }

  @override
  Future<void> createOrReplace(T newData, String id) {
    _behaviorSubject.add(_behaviorSubject.value..[id] = newData);
    return Future.value(null);
  }

  @override
  Future<void> createOrMergeIn(T newData, String id) async {
    _behaviorSubject.add(_behaviorSubject.value..[id] = newData);
  }

  @override
  Future<void> delete(String id) {
    _behaviorSubject.add(_behaviorSubject.value..remove(id));
    return Future.value(null);
  }

  @override
  Future<bool> documentExists(String id) {
    return Future.value(_behaviorSubject.value.containsKey(id));
  }

  @override
  Future<List<T>> getDocumentsByIds(
    List<String> ids, {
    Iterable<Object>? fields,
    List<SortingParameter> sortBy = const [],
  }) {
    _ensureFieldsNull(fields);
    final result = _getDocumentsByIds(ids: ids, currentState: _behaviorSubject.value);
    return Future.value(result);
  }

  @override
  Stream<List<T>> observeDocs({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    Iterable<Object>? fields,
    int? limit,
    bool ignoreCached = false,
    bool ignoreWithPendingChanges = false,
  }) {
    _ensureFieldsNull(fields);
    return _behaviorSubject.stream.map(
      (currentState) => _evaluateQuery(currentState: currentState, filters: filters, sortBy: sortBy, limit: limit),
    );
  }

  @override
  Stream<DataWithLoadingState<List<T>>> observeDocsWithState({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    Iterable<Object>? fields,
    int? limit,
  }) {
    _ensureFieldsNull(fields);
    return Rx.concat(
      [
        Stream.value(DataWithLoadingState.initial()),
        observeDocs(filters: filters, sortBy: sortBy, limit: limit)
            .map((data) => DataWithLoadingState(data, true, false, false)),
      ],
    );
  }

  @override
  Stream<T?> observeDocument(
    String id, {
    Iterable<Object>? fields,
    bool ignoreLocal = false,
    bool ignoreWithPendingChanges = false,
  }) {
    _ensureFieldsNull(fields);
    return _behaviorSubject.stream.map((currentState) => currentState[id]);
  }

  @override
  Stream<DataWithLoadingState<T>> observeDocumentWithState(String id, {Iterable<Object>? fields}) {
    _ensureFieldsNull(fields);
    return Rx.concat(
      [
        Stream.value(DataWithLoadingState.initial()),
        observeDocument(id).map((data) => DataWithLoadingState(data, true, false, false)),
      ],
    );
  }

  @override
  Stream<List<T>> observeDocumentsByIds(
    List<String> ids, {
    Iterable<Object>? fields,
    List<SortingParameter> sortBy = const [],
  }) {
    _ensureFieldsNull(fields);
    return _behaviorSubject.stream.map((currentState) => _getDocumentsByIds(ids: ids, currentState: currentState));
  }

  @override
  Future<List<T>> getDocuments({
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    Iterable<Object>? fields,
    int? limit,
  }) {
    _ensureFieldsNull(fields);
    final result = _evaluateQuery(currentState: _behaviorSubject.value, filters: filters, sortBy: sortBy, limit: limit);
    return Future.value(result);
  }

  @override
  Future<T?> getDocument(String id, {Iterable<Object>? fields}) {
    _ensureFieldsNull(fields);
    return Future.value(_behaviorSubject.value[id]);
  }

  @override
  Future<void> mergeIn(String id, Map<String, dynamic> data) {
    // TODO(jakub) implement updatePartial
    throw UnimplementedError();
  }

  @override
  Future<void> createOrDeepMergeIn(String id, String? jsonPath, Object data) {
    // TODO(jakub) implement updateSpecial
    throw UnimplementedError();
  }

  List<T> _getDocumentsByIds({required Iterable<String> ids, required Map<String, T> currentState}) {
    final results = <T>[];
    for (final id in ids) {
      final value = currentState[id];
      if (value == null) {
        throw StateError('No document found for id $id');
      }
      results.add(value);
    }
    return results;
  }

  List<T> _evaluateQuery({
    required Map<String, T> currentState,
    Iterable<AbstractFilterParameter> filters = const [],
    Iterable<SortingParameter> sortBy = const [],
    int? limit,
  }) {
    final jsonValues = currentState.values.map(jsonEncode).map(jsonDecode);
    var result = jsonValues;
    for (final filter in filters) {
      if (filter is! FilterParameter) {
        throw UnimplementedError();
      }
      result = result.where((json) => _evaluateFilter(json, filter));
    }
    result = result.sorted(
      (jsonA, jsonB) {
        for (final sort in sortBy) {
          final a = jsonA[sort.sortBy];
          final b = jsonB[sort.sortBy];

          if (a < b) {
            return -1;
          }
          if (a > b) {
            return 1;
          }
        }
        return 0;
      },
    );
    if (limit != null) {
      result = result.take(limit);
    }
    return result.map((e) => mapper(e)).toList();
  }

  bool _evaluateFilter(Map<String, dynamic> json, FilterParameter filter) {
    final value = json[filter.field];
    if (filter.isEqualTo != null) {
      return _evaluateEquality(value, filter.isEqualTo);
    }
    if (filter.isNotEqualTo != null) {
      return !_evaluateEquality(value, filter.isEqualTo);
    }
    if (filter.isLessThan != null) {
      return value < filter.isLessThan;
    }
    if (filter.isLessThanOrEqualTo != null) {
      return value <= filter.isLessThanOrEqualTo;
    }
    if (filter.isGreaterThan != null) {
      return value > filter.isGreaterThan;
    }
    if (filter.isGreaterThanOrEqualTo != null) {
      return value >= filter.isGreaterThanOrEqualTo;
    }
    if (filter.arrayContains != null) {
      return value.contains(filter.arrayContains);
    }
    if (filter.arrayDoesNotContain != null) {
      return !value.contains(filter.arrayContains);
    }
    if (filter.arrayContainsAny != null) {
      return value.any((element) => filter.arrayContainsAny!.contains(element));
    }
    if (filter.arrayContainsAll != null) {
      return value.every((element) => filter.arrayContainsAny!.contains(element));
    }
    if (filter.whereIn != null) {
      return filter.whereIn!.contains(value);
    }
    final exists = filter.exists;
    if (exists != null) {
      if (exists) {
        return json.containsKey(filter.field);
      }
      return !json.containsKey(filter.field);
    }
    final isNull = filter.isNull;
    if (isNull != null) {
      if (isNull) {
        return value == null;
      }
      return value != null;
    }
    throw ArgumentError('Invalid filter');
  }

  bool _evaluateEquality(Object? value, Object? equalsTo) {
    assert(
        value.runtimeType == equalsTo.runtimeType,
        'Warning: field with runtime type ${value.runtimeType} does not match with filtered value runtime type '
        '${equalsTo.runtimeType}');

    return _UNORDERED_DEEP_COLLECTION_EQUALITY.equals(value, equalsTo);
  }
// @override
// Future<int> countDocuments({
//   Iterable<AbstractFilterParameter> filters = const [],
// }) {
//   // TODO (jirka): implement countDocuments
//   throw UnimplementedError();
// }

  void _ensureFieldsNull(Iterable<Object>? fields) {
    assert(
      fields == null,
      '$InMemoryCollectionRepository does not support fields projection. fields parameter must be null',
    );
  }
}
