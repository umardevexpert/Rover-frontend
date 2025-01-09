import 'package:database_kit/collection_read/contract/collection_getter.dart';
import 'package:database_kit/collection_read/contract/collection_observer.dart';
import 'package:database_kit/collection_read/contract/collection_observer_with_state.dart';
import 'package:database_kit/collection_read/contract/collection_reader.dart';
import 'package:database_kit/collection_read/contract/collection_reader_with_state.dart';
import 'package:database_kit/collection_read_write/collection_repository.dart';
import 'package:database_kit/collection_read_write/collection_with_state_repository.dart';
import 'package:database_kit/collection_write/collection_writer.dart';
import 'package:get_it/get_it.dart';
import 'package:master_kit/contracts/serializable.dart';
import 'package:master_kit/type_system/type_utilities.dart';

extension GetItCollectionRepoExtension on GetIt {
  TRepo registerCollectionRepoAsSingleton<T extends Serializable, TRepo extends CollectionRepository<T>>(
    TRepo instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<TRepo>? dispose,
  }) {
    registerSingleton<CollectionRepository<T>>(instance, instanceName: instanceName);
    _registerIfSubtype<CollectionWithStateRepository<T>, TRepo>(instance, instanceName);

    registerCollectionWriterAsSingleton<T, TRepo>(instance, instanceName: instanceName);
    return registerCollectionReaderAsSingleton<T, TRepo>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose,
    );
  }

  TReader registerCollectionReaderAsSingleton<T extends Serializable, TReader extends CollectionReader<T>>(
    TReader instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<TReader>? dispose,
  }) {
    _registerIfSubtype<CollectionObserverWithState<T>, TReader>(instance, instanceName);
    _registerIfSubtype<CollectionReaderWithState<T>, TReader>(instance, instanceName);

    registerSingleton<CollectionGetter<T>>(instance, instanceName: instanceName);
    registerSingleton<CollectionObserver<T>>(instance, instanceName: instanceName);
    registerSingleton<CollectionReader<T>>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose == null ? null : (repo) => dispose(repo as TReader),
    );

    return instance;
  }

  void registerCollectionWriterAsSingleton<T extends Serializable, TWriter extends CollectionWriter<T>>(
    TWriter instance, {
    String? instanceName,
    bool? signalsReady,
    DisposingFunc<TWriter>? dispose,
  }) {
    registerSingleton<CollectionWriter<T>>(
      instance,
      instanceName: instanceName,
      signalsReady: signalsReady,
      dispose: dispose == null ? null : (repo) => dispose(repo as TWriter),
    );
  }

  void _registerIfSubtype<TCandidate extends Object, TService extends Object>(TService instance, String? instanceName) {
    // the ternary operator is only an optimisation. Since isSubtypeOf works by creating a new object it is faster to
    // use is operator if calling isSubtypeOf is equivalent of the is operator
    if (instance is TCandidate && (instance.runtimeType == TService || isSubtypeOf<TService, TCandidate>())) {
      registerSingleton<TCandidate>(instance, instanceName: instanceName);
    }
  }

  // this is the original version that registers all the super interfaces of a service regardless of what is specified
  // as TReader type parameter
  // void _registerIfSubtype<TService extends Object>(Object instance, String? instanceName) {
  //   if (instance is TService) {
  //     registerSingleton<TService>(instance, instanceName: instanceName);
  //   }
  // }
}
