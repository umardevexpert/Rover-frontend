import 'package:flutter/widgets.dart';

class ConditionalWrapper extends StatelessWidget {
  final Widget? child;
  final Widget Function(Widget child) wrapperBuilder;
  final bool wrapIf;

  const ConditionalWrapper({super.key, required this.wrapperBuilder, required this.wrapIf, required this.child});

  @override
  Widget build(BuildContext context) {
    final child = this.child ?? const SizedBox();
    if (wrapIf) {
      return wrapperBuilder(child);
    }
    return child;
  }
}
