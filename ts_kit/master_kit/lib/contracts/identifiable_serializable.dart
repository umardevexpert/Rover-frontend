import 'package:master_kit/contracts/identifiable.dart';
import 'package:master_kit/contracts/serializable.dart';

abstract interface class IdentifiableSerializable implements Identifiable, Serializable {}

abstract class IdentifiableSerializableBase extends IdentifiableBase implements IdentifiableSerializable {
  const IdentifiableSerializableBase({required super.id});
}
