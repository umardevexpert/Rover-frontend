// Do NOT move this file to collection_projected_read/model folder. This model is used in constructors of
// implementations of CollectionGetRepository, CollectionObserveRepository, etc. that logically do not need to import
// folder collection_projected_read
import 'package:collection/collection.dart';

const _ITERABLE_EQUALITY = IterableEquality<Field>();

class Field {
  final String name;
  final Iterable<Field> children;

  const Field(this.name, [this.children = const []]);

  static const ALL = Field('*');

  @override
  bool operator ==(Object other) =>
      other is Field &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      _ITERABLE_EQUALITY.equals(children, other.children);

  @override
  int get hashCode => name.hashCode ^ _ITERABLE_EQUALITY.hash(children);
}
