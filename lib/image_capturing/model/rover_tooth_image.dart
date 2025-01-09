import 'dart:typed_data';

class RoverToothImage {
  final Uint8List bytes;
  final String id;
  final DateTime createdAt;

  RoverToothImage(this.id, this.bytes, this.createdAt);
}
