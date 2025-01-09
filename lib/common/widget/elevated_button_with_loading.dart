import 'package:flutter/material.dart';

class ElevatedButtonWithLoading extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget child;

  const ElevatedButtonWithLoading({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary),
            )
          : child,
    );
  }
}
