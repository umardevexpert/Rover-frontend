import 'package:database_kit/collection_read/contract/collection_reader_with_state.dart';
import 'package:database_kit/collection_read_write/collection_repository.dart';
import 'package:master_kit/contracts/serializable.dart';

abstract interface class CollectionWithStateRepository<T extends Serializable>
    implements CollectionRepository<T>, CollectionReaderWithState<T> {}
