import 'package:flutter/material.dart';
import 'package:rover/common/widget/secondary_button.dart';
import 'package:ui_kit/util/assets.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double size;

  const DeleteButton({super.key, required this.onPressed, this.padding = const EdgeInsets.all(11), this.size = 46});

  @override
  Widget build(BuildContext context) {
    return SecondaryButton(
      variant: SecondaryButtonVariant.destructive,
      onPressed: onPressed,
      buttonStyle: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        minimumSize: MaterialStateProperty.all(Size(size, size)),
      ),
      child: Assets.svgImage('icon/delete'),
    );
  }
}
