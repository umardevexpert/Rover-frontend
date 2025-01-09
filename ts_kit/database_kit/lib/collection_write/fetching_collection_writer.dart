import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:master_kit/util/shared_type_definitions.dart';

/// Implementors must add ID fields to the fetched JSON before fromJson is called.
abstract interface class FetchingCollectionWriter<T extends Serializable> implements CollectionWriter<T> {
  /// Like [create] but returns a [Future] of the created document as it is after creation instead of the document's ID.
  /// See [create] for details.
  Future<T> createFetch(T document, {String id});

  /// Like [createOrReplace] but returns a [Future] of the document as it is immediately after
  /// this call is applied. See [createOrReplace] for details.
  Future<T> createOrReplaceFetch(T document, String id);

  /// Like [createOrMergeIn]but returns a [Future] of the document as it is immediately after
  /// this call is applied. See [createOrMergeIn] for details.
  Future<T> createOrMergeInFetch(T document, String id);

  /// Like [mergeIn] but returns a [Future] of the document as it is immediately after
  /// this call is applied. See [mergeIn] for details.
  Future<T> mergeInFetch(String id, JsonDoc partialDocument);

  /// Like [createOrDeepMergeIn] but returns a [Future] of the document as it is immediately after
  /// this call is applied. See [createOrDeepMergeIn] for details.
  Future<T> createOrDeepMergeInFetch(String id, String? jsonPath, Object partialDocument);

  /// Like [delete] but returns a [Future] of the deleted document as it is found immediately before deleting.
  /// See [delete] for details.
  Future<T> deleteFetch(String id);
}
