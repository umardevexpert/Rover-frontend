import 'package:master_kit/util/platform.dart';
import 'package:ui_kit/adaptive/model/adaptive_class.dart';

class AdaptiveBreakpoint {
  final AdaptiveClass id;
  final double upToScreenWidth;
  final Set<Platform>? validPlatforms;

  const AdaptiveBreakpoint(this.upToScreenWidth, {required this.id, this.validPlatforms});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveBreakpoint &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          upToScreenWidth == other.upToScreenWidth &&
          validPlatforms == other.validPlatforms;

  @override
  int get hashCode => id.hashCode ^ upToScreenWidth.hashCode ^ validPlatforms.hashCode;
}
