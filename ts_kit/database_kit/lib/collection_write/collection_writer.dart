import 'package:database_kit/collection_write/atomic_writes_provider.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:master_kit/util/shared_type_definitions.dart';

abstract interface class CollectionWriter<T extends Serializable> implements AtomicWritesProvider {
  /// Creates a new document in the collection by serializing given [document].
  ///
  /// If [id] is specified, it will be used as the new document's ID in the collection. Otherwise, a unique ID will be
  /// generated automatically. If [id] is specified and such ID already exists in the collection, this method will fail
  /// with error.
  ///
  /// The returned future is resolved when the document is created in the DB and it returns the passed in or generated
  /// ID of the created document.
  Future<String> create(T document, {String? id});

  /// Adds the specified [document] to the collection (if it does not exist) under given [id] or overwrites the existing
  /// DB document for given [id] with specified [document] (in case it already exists in the DB).
  Future<void> createOrReplace(T document, String id);

  /// Adds the specified [document] to the collection under given [id] if it is previously NOT present in the
  /// collection. Otherwise, the non-null fields of [document] will override existing fields specified by [document]
  /// keys of collection document with [id] or are added to it (recursively). Any pre-existing document fields not
  /// present in document keys will be unaffected.
  Future<void> createOrMergeIn(T document, String id);

  /// Merges given JSON (its fields) [partialDocument] into an existing collection document specified by given ID. The
  /// [partialDocument] may only contain some of the fields of type [T], possibly also missing some required fields.
  /// If the document with given [id] does not exist in the collection, an error may be thrown.
  ///
  /// "Merge into" in this context means that the fields specified by keys of [partialDocument] will override existing
  /// fields of the pre-existing collection document with [id] or are added to it (recursively). Any pre-existing
  /// document fields not present in [partialDocument]s keys will not be affected.
  ///
  /// ### "Merge into" explanation:
  /// Take for example following collection **User** exists with fields `"name"`, `"surname"` and an object field
  /// `"details"`, which contains sub-fields `"age"` and `"married"`.
  ///
  /// If [mergeIn] is called with following [partialDocument] `{"name": "Jack", "details.age": 12}`, then only fields
  /// `"name"` and `"age"` (nested in object field `"details"`) will be overwritten, and fields `"surname"` and
  /// `"married"` will be unchanged.
  ///
  /// However if [mergeIn] is called with following [partialDocument] `{"name": "Jack", "details": {"age": 12}}`, then
  /// fields `"name"` and `"details"` will be overwritten (field `"married"` will be deleted) and only field `"surname"`
  /// will be unchanged.
  Future<void> mergeIn(String id, JsonDoc partialDocument);

  // default behavior of Firebase implementation.
  /// Adds the specified [partialDocument] to the collection under given [id] if it is previously NOT present in the
  /// collection. Otherwise, the non-null fields of [partialDocument] will be deeply merged in with existing fields of
  /// collection document.
  ///
  /// If [jsonPath] is provided, then fields provided by [partialDocument] will NOT be used as the root of the
  /// collection document with [id] but will be merged in under path specified by [jsonPath]. [jsonPath] may contain
  /// fields in dot notation.
  Future<void> createOrDeepMergeIn(String id, String? jsonPath, Object partialDocument);

  /// Deletes the document with given [id] from the collection.
  Future<void> delete(String id);
}
