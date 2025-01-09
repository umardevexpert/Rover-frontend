import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:database_kit/collection_read/contract/collection_observer.dart';

const DOCUMENT_ID_FIELD_NAME = 'documentId';

abstract interface class CollectionReader<T> implements CollectionGetter<T>, CollectionObserver<T> {}
