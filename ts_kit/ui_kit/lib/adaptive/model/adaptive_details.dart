import 'package:flutter/widgets.dart';
import 'package:master_kit/util/platform.dart';

class AdaptiveDetails {
  final Platform platform;
  final Orientation orientation;

  AdaptiveDetails(this.platform, this.orientation);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveDetails &&
          runtimeType == other.runtimeType &&
          platform == other.platform &&
          orientation == other.orientation;

  @override
  int get hashCode => platform.hashCode ^ orientation.hashCode;
}
