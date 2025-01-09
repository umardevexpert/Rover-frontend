import 'package:flutter/widgets.dart';

class ContentWidthLimiter extends StatelessWidget {
  final Widget? child;
  final double maxWidth;

  const ContentWidthLimiter({super.key, required this.maxWidth, this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
