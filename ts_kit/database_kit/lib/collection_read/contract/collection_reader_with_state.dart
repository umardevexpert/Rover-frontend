import 'package:database_kit/collection_read/contract/collection_reader.dart';
import 'package:database_kit/collection_read/contract/collection_observer_with_state.dart';

abstract interface class CollectionReaderWithState<T> implements CollectionReader<T>, CollectionObserverWithState<T> {}
