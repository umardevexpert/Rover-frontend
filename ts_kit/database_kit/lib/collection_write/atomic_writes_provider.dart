import 'package:database_kit/collection_write/collection_writer.dart';

abstract interface class AtomicWritesProvider {
  /// Only valid for [CollectionWriter.mergeIn] or [CollectionWriter.createOrMergeIn]. When specified as a value of a key, removes the key from
  /// the document atomically (in a way that is save to use with a lot of concurrent writes).
  Object get deleteField;

  /// When specified as a value of a document key when writing, the value of that key will be server time
  /// (milliseconds since epoch start) upon writing the document to the collection on the server.
  Object get serverTimestamp;

  /// If specified as a value of a document numeric key when writing, the value of the key will be atomically
  /// incremented by the [value]. This increment is ACID in highly concurrent environments.
  ///
  /// Fails if the current value of the same key of the document on the server is not a number. To decrement, pass
  /// negative [value].
  Object increment(num value);
  Object arrayUnion<TElement>(List<TElement> toAdd);
  Object arrayAppend<TElement>(List<TElement> toAppend);
  // TODO(rasto): Write documentation comment specifying if all instances of the be deleted elements are deleted or just
  // the first
  Object arrayDeleteValues<TElement>(List<TElement> toDelete);
}
