import 'package:flutter/widgets.dart';
import 'package:master_kit/util/platform.dart';
import 'package:ui_kit/adaptive/model/adaptive_class.dart';
import 'package:ui_kit/adaptive/model/adaptive_details.dart';

class AdaptiveState {
  final AdaptiveClass classId;
  final AdaptiveDetails details;

  Platform get platform => details.platform;

  Orientation get orientation => details.orientation;

  AdaptiveState(this.classId, this.details);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveState &&
          runtimeType == other.runtimeType &&
          classId == other.classId &&
          details == other.details;

  @override
  int get hashCode => classId.hashCode ^ details.hashCode;
}
