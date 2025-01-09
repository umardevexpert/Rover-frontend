import 'package:database_kit/collection_read/contract/collection_reader.dart';
import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:master_kit/contracts/serializable.dart';

abstract interface class CollectionRepository<T extends Serializable>
    implements CollectionReader<T>, CollectionWriter<T> {}
