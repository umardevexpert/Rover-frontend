// a replacement for dart:io that is only needed for Chrome debugging, for deployment dart:io works as well
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:master_kit/util/platform.dart';
import 'package:ui_kit/adaptive/model/adaptive_breakpoint.dart';
import 'package:ui_kit/adaptive/model/adaptive_class.dart';
import 'package:ui_kit/adaptive/model/adaptive_details.dart';
import 'package:ui_kit/adaptive/model/adaptive_state.dart';

typedef AdaptiveClassSelector = AdaptiveClass Function(double screenWidth, AdaptiveDetails state);

Size screenSize(BuildContext context) => MediaQuery.of(context).size;
double screenWidth(BuildContext context) => screenSize(context).width;
double screenHeight(BuildContext context) => screenSize(context).height;

/// WARNING this method does not sign you up for listening to updates of safe area height
/// in case you want widget to rebuild every time the size changes use [bottomSafeAreaHeight].
double oneTimeOnlyBottomSafeAreaHeight() => MediaQueryData.fromWindow(ui.window).padding.bottom;

class Adaptive extends InheritedWidget {
  final AdaptiveClassSelector? classSelector;
  final List<AdaptiveBreakpoint>? breakpoints;
  final List<AdaptiveBreakpoint>? landscapeBreakpoints;

  factory Adaptive.builder({
    Key? key,
    Widget? child,
    AdaptiveClassSelector? classSelector,
    List<AdaptiveBreakpoint>? breakpoints,
    List<AdaptiveBreakpoint>? landscapeBreakpoints,
  }) =>
      Adaptive(
        key: key,
        classSelector: classSelector,
        breakpoints: breakpoints,
        landscapeBreakpoints: landscapeBreakpoints,
        child: child ?? const SizedBox(),
      );

  const Adaptive({
    Key? key,
    required Widget child,
    this.classSelector,
    this.breakpoints,
    this.landscapeBreakpoints,
  })  : assert(classSelector != null || breakpoints != null,
            'activeClassSelector function or responsive breakpoints must be specified'),
        super(key: key, child: child);

  static AdaptiveState of(BuildContext context) {
    final adaptive = context.dependOnInheritedWidgetOfExactType<Adaptive>();
    final mQuery = context.dependOnInheritedWidgetOfExactType<MediaQuery>()?.data;
    if (adaptive == null) {
      throw StateError('Trying to access adaptiveState before Adaptive widget is mounted in the widget tree. '
          'This can happen if you did not use Adaptive widget or when  you try accessing adaptiveState from a widget '
          'that is a parent of Adaptive widget.');
    }
    if (mQuery == null) {
      throw StateError('Adaptive widget may only be access in context that contains MediaQuery '
          '(e.g. descendant of MaterialApp)');
    }
    final details = AdaptiveDetails(platform, mQuery.orientation);
    final selector = adaptive.classSelector == null ? adaptive._findIdInBreakpoints : adaptive.classSelector!;
    final _class = selector(mQuery.size.width, details);
    return AdaptiveState(_class, details);
  }

  AdaptiveClass _findIdInBreakpoints(double screenWidth, AdaptiveDetails state) {
    if (state.orientation == Orientation.landscape && landscapeBreakpoints != null) {
      return _selectFromBreakpoints(screenWidth, landscapeBreakpoints!, state);
    }
    return _selectFromBreakpoints(screenWidth, breakpoints!, state);
  }

  AdaptiveClass _selectFromBreakpoints(
    double screenWidth,
    List<AdaptiveBreakpoint> breakpoints,
    AdaptiveDetails state,
  ) {
    final validBreakpoints =
        breakpoints.where((breakpoint) => breakpoint.validPlatforms?.contains(state.platform) != false);
    if (validBreakpoints.isEmpty) {
      throw StateError('Current platform `${state.platform}` has no valid breakpoints');
    }
    for (final breakpoint in validBreakpoints) {
      if (screenWidth <= breakpoint.upToScreenWidth) {
        return breakpoint.id;
      }
    }
    return breakpoints.last.id;
  }

  static Platform get platform => Platform.current;

  @override
  bool updateShouldNotify(Adaptive old) {
    return classSelector != old.classSelector ||
        !listEquals(breakpoints, old.breakpoints) ||
        !listEquals(landscapeBreakpoints, old.landscapeBreakpoints);
  }
}
